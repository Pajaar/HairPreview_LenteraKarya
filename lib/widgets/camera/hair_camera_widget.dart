import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../data/models/hair_style_state.dart';
import '../../data/services/hair_segmentation_service.dart';
import 'hair_mask_overlay.dart';

class HairCameraWidget extends StatefulWidget {
  final HairStyleState hairState;

  const HairCameraWidget({
    super.key,
    required this.hairState,
  });

  @override
  State<HairCameraWidget> createState() => _HairCameraWidgetState();
}

class _HairCameraWidgetState extends State<HairCameraWidget> {
  CameraController? _controller;
  final HairSegmentationService _hairSegmentationService =
      HairSegmentationService();

  bool _isLoading = true;
  bool _cameraError = false;
  bool _isCapturing = false;
  String _errorMessage = '';

  Float32List? _hairMask;
  int _maskWidth = 0;
  int _maskHeight = 0;

  Uint8List? _capturedImageBytes;
  Size _capturedImageSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _setupAll();
  }

  Future<void> _setupAll() async {
    try {
      await _hairSegmentationService.initialize();
      await _setupCamera();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _cameraError = true;
          _errorMessage = 'No camera found on device';
          _isLoading = false;
        });
        return;
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      _controller = controller;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _captureAndSegment() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final file = await controller.takePicture();
      final imageBytes = await file.readAsBytes();

      final decoded = await decodeImageFromList(imageBytes);

      final imageSize = Size(
        decoded.width.toDouble(),
        decoded.height.toDouble(),
      );

      final result = await _hairSegmentationService.segmentHair(imageBytes);

      if (!mounted) return;

      if (result != null) {
        setState(() {
          _capturedImageBytes = imageBytes;
          _capturedImageSize = imageSize;
          _hairMask = result.hairMask;
          _maskWidth = result.width;
          _maskHeight = result.height;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hair segmentation failed'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Capture failed: $e'),
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _clearMask() {
    setState(() {
      _capturedImageBytes = null;
      _capturedImageSize = Size.zero;
      _hairMask = null;
      _maskWidth = 0;
      _maskHeight = 0;
    });
  }

  Widget _buildCapturedResult() {
    final imageBytes = _capturedImageBytes;
    if (imageBytes == null || _capturedImageSize == Size.zero) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        final fitted = applyBoxFit(
          BoxFit.cover,
          _capturedImageSize,
          viewportSize,
        );

        return ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _capturedImageSize.width,
                  height: _capturedImageSize.height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        imageBytes,
                        fit: BoxFit.fill,
                      ),
                      HairMaskOverlay(
                        hairMask: _hairMask,
                        maskWidth: _maskWidth,
                        maskHeight: _maskHeight,
                        color: widget.hairState.color,
                        sourceImageSize: _capturedImageSize,
                        forceExactImageSpace: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreview() {
    if (_capturedImageBytes != null) {
      return _buildCapturedResult();
    }

    return CameraPreview(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _hairSegmentationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraError) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Text(
          'Camera failed: $_errorMessage',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_isLoading || _controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildPreview(),
        Positioned(
          top: 18,
          left: 18,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.32),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              _hairMask != null ? 'Hair: detected' : 'Hair: ready',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isCapturing ? null : _captureAndSegment,
                  child: Text(
                    _isCapturing ? 'Processing...' : 'Capture Hair',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearMask,
                  child: Text(
                    _capturedImageBytes != null ? 'Retake' : 'Clear',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}