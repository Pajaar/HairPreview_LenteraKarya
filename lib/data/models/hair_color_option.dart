import 'package:flutter/material.dart';

enum HairColorOption {
  black,
  darkBrown,
  brown,
  lightBrown,
  burgundy,
}

extension HairColorOptionX on HairColorOption {
  String get label {
    switch (this) {
      case HairColorOption.black:
        return 'Black';
      case HairColorOption.darkBrown:
        return 'Dark Brown';
      case HairColorOption.brown:
        return 'Brown';
      case HairColorOption.lightBrown:
        return 'Light Brown';
      case HairColorOption.burgundy:
        return 'Burgundy';
    }
  }

  Color get color {
    switch (this) {
      case HairColorOption.black:
        return const Color(0xFF1F1A17);
      case HairColorOption.darkBrown:
        return const Color(0xFF3B2A22);
      case HairColorOption.brown:
        return const Color(0xFF6A4730);
      case HairColorOption.lightBrown:
        return const Color(0xFF8D623E);
      case HairColorOption.burgundy:
        return const Color(0xFF6B2D3A);
    }
  }
}