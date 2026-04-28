import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/hair_style_state.dart';
import '../../providers/hair_style_provider.dart';
import '../../widgets/camera/hair_camera_widget.dart';
import '../../widgets/controls/manual_controls_sheet.dart';

class CameraPreviewScreen extends ConsumerWidget {
  final String initialMode;

  const CameraPreviewScreen({
    super.key,
    required this.initialMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hairState = ref.watch(hairStyleProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: HairCameraWidget(
              hairState: hairState,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          initialMode == 'chat' ? 'Chat with AI' : 'Manual Mode',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PreviewTag(label: _hairStyleLabel(hairState.top.style)),
                      _PreviewTag(label: _fadeLabel(hairState.sides.fade)),
                      _PreviewTag(label: _colorLabel(hairState.color)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionButton(
                        icon: Icons.tune_rounded,
                        label: 'Adjust',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const ManualControlsSheet(),
                          );
                        },
                      ),
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: const Center(
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      _ActionButton(
                        icon: Icons.auto_awesome_rounded,
                        label: 'Chat',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _hairStyleLabel(HairStyle style) {
    switch (style) {
      case HairStyle.natural:
        return 'Natural';
      case HairStyle.textured:
        return 'Textured';
      case HairStyle.wavy:
        return 'Wavy';
      case HairStyle.slick:
        return 'Slick';
    }
  }

  String _fadeLabel(FadeType fade) {
    switch (fade) {
      case FadeType.none:
        return 'No Fade';
      case FadeType.low:
        return 'Low Fade';
      case FadeType.high:
        return 'High Fade';
      case FadeType.taper:
        return 'Taper';
    }
  }

  String _colorLabel(Color color) {
    if (color.value == const Color(0xFF2F2A28).value) return 'Dark Brown';
    if (color.value == const Color(0xFF6D4C41).value) return 'Brown';
    if (color.value == const Color(0xFF212121).value) return 'Black';
    if (color.value == const Color(0xFFB08968).value) return 'Light Brown';
    return 'Custom Color';
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewTag extends StatelessWidget {
  final String label;

  const _PreviewTag({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD6A62C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}