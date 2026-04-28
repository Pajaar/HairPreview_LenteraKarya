import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/hair_color_option.dart';
import '../../data/models/hair_style_state.dart';
import '../../providers/hair_style_provider.dart';

class ManualControlsSheet extends ConsumerWidget {
  const ManualControlsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hairState = ref.watch(hairStyleProvider);
    final notifier = ref.read(hairStyleProvider.notifier);
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F5EF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 52,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Manual Adjustments',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Change color, top length, top style, and side fade for the live preview.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6E6A66),
                ),
              ),
              const SizedBox(height: 24),

              _SectionTitle(title: 'Hair Color'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: HairColorOption.values.map((option) {
                  final isSelected = hairState.colorOption == option;
                  return _ColorChip(
                    label: option.label,
                    color: option.color,
                    isSelected: isSelected,
                    onTap: () => notifier.setHairColor(option),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              _SectionTitle(title: 'Top Length'),
              const SizedBox(height: 8),
              _ValueRow(
                leftLabel: 'Buzz',
                valueLabel: _lengthLabel(hairState.top.length),
                rightLabel: 'Long',
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFE0B325),
                  inactiveTrackColor: const Color(0xFFE5DDD0),
                  thumbColor: const Color(0xFFE0B325),
                  overlayColor: const Color(0xFFE0B325).withOpacity(0.18),
                  trackHeight: 5,
                ),
                child: Slider(
                  value: hairState.top.length,
                  min: 0,
                  max: 1,
                  onChanged: notifier.setTopLength,
                ),
              ),

              const SizedBox(height: 24),
              _SectionTitle(title: 'Top Style'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: HairStyle.values.map((style) {
                  final isSelected = hairState.top.style == style;
                  return _OptionChip(
                    label: _styleLabel(style),
                    isSelected: isSelected,
                    onTap: () => notifier.setTopStyle(style),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              _SectionTitle(title: 'Sides Fade'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: FadeType.values.map((fade) {
                  final isSelected = hairState.sides.fade == fade;
                  return _OptionChip(
                    label: _fadeLabel(fade),
                    isSelected: isSelected,
                    onTap: () => notifier.setSidesFade(fade),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.72),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.06),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Preview State',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SummaryPill(label: _styleLabel(hairState.top.style)),
                        _SummaryPill(label: _fadeLabel(hairState.sides.fade)),
                        _SummaryPill(label: hairState.colorOption.label),
                        _SummaryPill(label: _lengthLabel(hairState.top.length)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _styleLabel(HairStyle style) {
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

  String _lengthLabel(double value) {
    if (value < 0.2) return 'Buzz';
    if (value < 0.4) return 'Short';
    if (value < 0.7) return 'Medium';
    return 'Long';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E1E1E),
          ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String leftLabel;
  final String valueLabel;
  final String rightLabel;

  const _ValueRow({
    required this.leftLabel,
    required this.valueLabel,
    required this.rightLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          leftLabel,
          style: const TextStyle(
            color: Color(0xFF7B746B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0B325).withOpacity(0.16),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            valueLabel,
            style: const TextStyle(
              color: Color(0xFF8D6A00),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        Text(
          rightLabel,
          style: const TextStyle(
            color: Color(0xFF7B746B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFE0B325) : Colors.white,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFE0B325)
                  : Colors.black.withOpacity(0.08),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF2D2A26),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFFFF7DD) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 108,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFE0B325)
                  : Colors.black.withOpacity(0.07),
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF2D2A26),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  final String label;

  const _SummaryPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE0B325),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}