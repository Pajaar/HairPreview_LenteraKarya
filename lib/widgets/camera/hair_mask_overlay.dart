import 'dart:typed_data';
import 'package:flutter/material.dart';

class HairMaskOverlay extends StatelessWidget {
  final Float32List? hairMask;
  final int maskWidth;
  final int maskHeight;
  final Color color;
  final Size sourceImageSize;
  final bool forceExactImageSpace;

  const HairMaskOverlay({
    super.key,
    required this.hairMask,
    required this.maskWidth,
    required this.maskHeight,
    required this.color,
    required this.sourceImageSize,
    this.forceExactImageSpace = false,
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
        size: forceExactImageSpace ? sourceImageSize : Size.infinite,
        painter: _HairMaskPainter(
          hairMask: hairMask!,
          maskWidth: maskWidth,
          maskHeight: maskHeight,
          color: color,
          sourceImageSize: sourceImageSize,
          forceExactImageSpace: forceExactImageSpace,
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
  final bool forceExactImageSpace;

  _HairMaskPainter({
    required this.hairMask,
    required this.maskWidth,
    required this.maskHeight,
    required this.color,
    required this.sourceImageSize,
    required this.forceExactImageSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect outputSubrect;

    if (forceExactImageSpace) {
      outputSubrect = Offset.zero & size;
    } else {
      final fitted = applyBoxFit(
        BoxFit.cover,
        sourceImageSize,
        size,
      );

      outputSubrect = Alignment.center.inscribe(
        fitted.destination,
        Offset.zero & size,
      );
    }

    const double scaleX = 1.20;
    const double scaleY = 1.08;
    const double offsetXRatio = -0.01;
    const double offsetYRatio = 0.01;

    final calibratedWidth = outputSubrect.width * scaleX;
    final calibratedHeight = outputSubrect.height * scaleY;

    final calibratedLeft =
        outputSubrect.left -
        ((calibratedWidth - outputSubrect.width) / 2) +
        (outputSubrect.width * offsetXRatio);

    final calibratedTop =
        outputSubrect.top -
        ((calibratedHeight - outputSubrect.height) / 2) +
        (outputSubrect.height * offsetYRatio);

    final cellWidth = calibratedWidth / maskWidth;
    final cellHeight = calibratedHeight / maskHeight;

    final paint = Paint()..style = PaintingStyle.fill;

    final maxPaintRow = (maskHeight * 0.60).floor();

    for (int y = 0; y < maskHeight; y++) {
      if (y > maxPaintRow) continue;

      for (int x = 0; x < maskWidth; x++) {
        final index = y * maskWidth + x;
        if (index >= hairMask.length) continue;

        final confidence = hairMask[index];
        if (confidence < 0.72) continue;

        paint.color = color.withOpacity(
          (confidence * 0.36).clamp(0.0, 0.40),
        );

        canvas.drawRect(
          Rect.fromLTWH(
            calibratedLeft + (x * cellWidth),
            calibratedTop + (y * cellHeight),
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
        oldDelegate.sourceImageSize != sourceImageSize ||
        oldDelegate.forceExactImageSpace != forceExactImageSpace;
  }
}