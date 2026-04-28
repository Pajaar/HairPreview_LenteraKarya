import 'package:flutter/material.dart';
import 'hair_color_option.dart';

enum HairStyle { natural, textured, wavy, slick }
enum FadeType { none, low, high, taper }
enum Neckline { rounded, squared, tapered }

class TopHairConfig {
  final double length;
  final HairStyle style;

  const TopHairConfig({
    required this.length,
    required this.style,
  });

  TopHairConfig copyWith({
    double? length,
    HairStyle? style,
  }) {
    return TopHairConfig(
      length: length ?? this.length,
      style: style ?? this.style,
    );
  }
}

class SidesHairConfig {
  final double length;
  final FadeType fade;

  const SidesHairConfig({
    required this.length,
    required this.fade,
  });

  SidesHairConfig copyWith({
    double? length,
    FadeType? fade,
  }) {
    return SidesHairConfig(
      length: length ?? this.length,
      fade: fade ?? this.fade,
    );
  }
}

class BackHairConfig {
  final double length;
  final Neckline neckline;

  const BackHairConfig({
    required this.length,
    required this.neckline,
  });

  BackHairConfig copyWith({
    double? length,
    Neckline? neckline,
  }) {
    return BackHairConfig(
      length: length ?? this.length,
      neckline: neckline ?? this.neckline,
    );
  }
}

class HairStyleState {
  final TopHairConfig top;
  final SidesHairConfig sides;
  final BackHairConfig back;
  final HairColorOption colorOption;
  final Color color;

  const HairStyleState({
    required this.top,
    required this.sides,
    required this.back,
    required this.colorOption,
    required this.color,
  });

  factory HairStyleState.initial() {
    return HairStyleState(
      top: const TopHairConfig(
        length: 0.45,
        style: HairStyle.natural,
      ),
      sides: const SidesHairConfig(
        length: 0.30,
        fade: FadeType.none,
      ),
      back: const BackHairConfig(
        length: 0.30,
        neckline: Neckline.rounded,
      ),
      colorOption: HairColorOption.black,
      color: HairColorOption.black.color,
    );
  }

  HairStyleState copyWith({
    TopHairConfig? top,
    SidesHairConfig? sides,
    BackHairConfig? back,
    HairColorOption? colorOption,
    Color? color,
  }) {
    return HairStyleState(
      top: top ?? this.top,
      sides: sides ?? this.sides,
      back: back ?? this.back,
      colorOption: colorOption ?? this.colorOption,
      color: color ?? this.color,
    );
  }
}