import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/hair_color_option.dart';
import '../data/models/hair_style_state.dart';

final hairStyleProvider =
    StateNotifierProvider<HairStyleNotifier, HairStyleState>(
  (ref) => HairStyleNotifier(),
);

class HairStyleNotifier extends StateNotifier<HairStyleState> {
  HairStyleNotifier() : super(HairStyleState.initial());

  void setHairColor(HairColorOption option) {
    state = state.copyWith(
      colorOption: option,
      color: option.color,
    );
  }

  void setTopLength(double value) {
    state = state.copyWith(
      top: state.top.copyWith(length: value.clamp(0.0, 1.0)),
    );
  }

  void setTopStyle(HairStyle style) {
    state = state.copyWith(
      top: state.top.copyWith(style: style),
    );
  }

  void setSidesFade(FadeType fade) {
    state = state.copyWith(
      sides: state.sides.copyWith(fade: fade),
    );
  }
}