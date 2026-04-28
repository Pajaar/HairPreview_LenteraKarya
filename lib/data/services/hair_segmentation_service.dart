import 'dart:developer' as developer;
import 'dart:typed_data';
import 'package:face_detection_tflite/face_detection_tflite.dart';

class HairSegmentationResult {
  final Float32List hairMask;
  final int width;
  final int height;

  const HairSegmentationResult({
    required this.hairMask,
    required this.width,
    required this.height,
  });
}

class HairSegmentationService {
  SelfieSegmentation? _segmenter;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _segmenter = await SelfieSegmentation.create(
      config: const SegmentationConfig(
        model: SegmentationModel.multiclass,
      ),
    );

    _isInitialized = true;
    developer.log('HairSegmentationService initialized');
  }

  Future<HairSegmentationResult?> segmentHair(Uint8List imageBytes) async {
    if (!_isInitialized || _segmenter == null) {
      developer.log('segmentHair skipped: not initialized');
      return null;
    }

    try {
      developer.log('segmentHair bytes length: ${imageBytes.length}');

      final result = await _segmenter!.callFromBytes(imageBytes);

      developer.log('segmentHair result type: ${result.runtimeType}');

      if (result is MulticlassSegmentationMask) {
        developer.log(
          'hair mask ok: ${result.width}x${result.height}, hair len=${result.hairMask.length}',
        );

        return HairSegmentationResult(
          hairMask: result.hairMask,
          width: result.width,
          height: result.height,
        );
      }

      developer.log('segmentHair result was not MulticlassSegmentationMask');
      return null;
    } catch (e) {
      developer.log('segmentHair error: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    _segmenter?.dispose();
    _segmenter = null;
    _isInitialized = false;
  }
}