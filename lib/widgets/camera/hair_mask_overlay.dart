import 'dart:typed_data';
import 'package:flutter/material.dart';

class HairMaskOverlay extends StatelessWidget {
  final Float32List? hairMask;
  final int maskWidth;
  final int maskHeight;
  final Color color;
  final Size sourceImageSize;

  const HairMaskOverlay({
    super.key,
    required this.hairMask,
    required this.maskWidth,
    required this.maskHeight,
    required this.color,
    required this.sourceImageSize,
  });

  @override
  Widget build(BuildContext context) {
    if (hairMask == null ||
        maskWidth == 0 ||
        maskHeight == 0 ||
        sourceImageSize.width == 0 ||
        sourceImageSize.height == 0) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _HairMaskPainter(
          hairMask: hairMask!,
          maskWidth: maskWidth,
          maskHeight: maskHeight,
          color: color,
          sourceImageSize: sourceImageSize,
        ),
      ),
    );
  }
}

class _HairMaskPainter extends CustomPainter {
  final Float32List hairMask;
  final int maskWidth;
  final int maskHeight;
  final Color color;
  final Size sourceImageSize;

  _HairMaskPainter({
    required this.hairMask,
    required this.maskWidth,
    required this.maskHeight,
    required this.color,
    required this.sourceImageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fitted = applyBoxFit(
      BoxFit.cover,
      sourceImageSize,
      size,
    );

    final inputSubrect = Alignment.center.inscribe(
      fitted.source,
      Offset.zero & sourceImageSize,
    );

    final outputSubrect = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & size,
    );

    final drawLeft = outputSubrect.left;
    final drawTop = outputSubrect.top;
    final drawWidth = outputSubrect.width;
    final drawHeight = outputSubrect.height;

    final cellWidth = drawWidth / maskWidth;
    final cellHeight = drawHeight / maskHeight;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int y = 0; y < maskHeight; y++) {
      for (int x = 0; x < maskWidth; x++) {
        final index = y * maskWidth + x;
        if (index >= hairMask.length) continue;

        final confidence = hairMask[index];
        if (confidence < 0.45) continue;

        paint.color = color.withOpacity(
          (confidence * 0.42).clamp(0.0, 0.50),
        );

        canvas.drawRect(
          Rect.fromLTWH(
            drawLeft + (x * cellWidth),
            drawTop + (y * cellHeight),
            cellWidth + 0.5,
            cellHeight + 0.5,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HairMaskPainter oldDelegate) {
    return oldDelegate.hairMask != hairMask ||
        oldDelegate.maskWidth != maskWidth ||
        oldDelegate.maskHeight != maskHeight ||
        oldDelegate.color != color ||
        oldDelegate.sourceImageSize != sourceImageSize;
  }
}