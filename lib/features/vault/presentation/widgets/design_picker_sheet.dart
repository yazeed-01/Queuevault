import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/layout_preferences_provider.dart';

// ─── Entry point ─────────────────────────────────────────────────────────────

void showDesignPickerSheet(BuildContext context) {
  HapticFeedback.mediumImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _DesignPickerSheet(),
  );
}

// ─── Sheet ───────────────────────────────────────────────────────────────────

class _DesignPickerSheet extends ConsumerStatefulWidget {
  const _DesignPickerSheet();

  @override
  ConsumerState<_DesignPickerSheet> createState() =>
      _DesignPickerSheetState();
}

class _DesignPickerSheetState extends ConsumerState<_DesignPickerSheet>
    with SingleTickerProviderStateMixin {
  late FixedExtentScrollController _wheelCtrl;
  late AnimationController _glowCtrl;
  int _centeredIndex = 0;

  @override
  void initState() {
    super.initState();
    _centeredIndex = ref.read(layoutPrefsProvider).preset.index;
    _wheelCtrl = FixedExtentScrollController(initialItem: _centeredIndex);
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _wheelCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  VaultPreset get _current => VaultPreset.values[_centeredIndex];

  void _onItemChanged(int i) {
    HapticFeedback.selectionClick();
    setState(() => _centeredIndex = i);
  }

  void _apply() {
    HapticFeedback.mediumImpact();
    ref.read(layoutPrefsProvider.notifier).applyPreset(_current);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final activePreset = ref.watch(layoutPrefsProvider).preset;
    final color = _current.accentColor;
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      height: screenH * 0.68,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 40,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ambient glow behind wheel
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (_, __) => Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withValues(
                            alpha: 0.12 + _glowCtrl.value * 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 280),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: color.withValues(alpha: 0.4)),
                      ),
                      child: Icon(Icons.style_rounded,
                          size: 18, color: color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Design',
                              style: AppTextStyles.titleMedium),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              _current.label,
                              key: ValueKey(_centeredIndex),
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: color),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: const Icon(Icons.close_rounded,
                            size: 16, color: AppColors.textMuted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Preset description strip
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  child: Container(
                    key: ValueKey(_centeredIndex),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: color.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(_current.icon, size: 14, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _current.description,
                            style: AppTextStyles.bodySmall
                                .copyWith(fontSize: 11),
                          ),
                        ),
                        if (activePreset == _current)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text('ACTIVE',
                                style: AppTextStyles.labelSmall
                                    .copyWith(
                                        color: color, fontSize: 9)),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Revolver wheel ─────────────────────────────────────
              Expanded(
                child: DesignCylinderWheel(
                  centeredIndex: _centeredIndex,
                  controller: _wheelCtrl,
                  glowAnim: _glowCtrl,
                  onItemChanged: _onItemChanged,
                ),
              ),

              const SizedBox(height: 12),

              // ── Apply button ────────────────────────────────────────
              _ApplyButton(
                preset: _current,
                isApplied: activePreset == _current,
                onApply: _apply,
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0),

              SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared cylinder wheel (used in both sheet and full page) ─────────────────

class DesignCylinderWheel extends StatelessWidget {
  const DesignCylinderWheel({
    super.key,
    required this.centeredIndex,
    required this.controller,
    required this.glowAnim,
    required this.onItemChanged,
  });

  final int centeredIndex;
  final FixedExtentScrollController controller;
  final Animation<double> glowAnim;
  final ValueChanged<int> onItemChanged;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 190,
        diameterRatio: 2.2,
        perspective: 0.0025,
        squeeze: 0.9,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: VaultPreset.values.length,
          builder: (context, i) {
            final preset = VaultPreset.values[i];
            final isCentered = i == centeredIndex;
            return RotatedBox(
              quarterTurns: -1,
              child: AnimatedBuilder(
                animation: glowAnim,
                builder: (_, __) => DesignWheelCard(
                  preset: preset,
                  isCentered: isCentered,
                  glowPulse: isCentered ? glowAnim.value : 0.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Single wheel card (shared) ───────────────────────────────────────────────

class DesignWheelCard extends StatelessWidget {
  const DesignWheelCard({
    super.key,
    required this.preset,
    required this.isCentered,
    required this.glowPulse,
  });

  final VaultPreset preset;
  final bool isCentered;
  final double glowPulse;

  @override
  Widget build(BuildContext context) {
    final color = preset.accentColor;
    final glowRadius = 18 + glowPulse * 14;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isCentered
            ? color.withValues(alpha: 0.12)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCentered
              ? color.withValues(alpha: 0.6)
              : AppColors.cardBorder,
          width: isCentered ? 1.5 : 1,
        ),
        boxShadow: isCentered
            ? [
                BoxShadow(
                  color: color
                      .withValues(alpha: 0.22 + glowPulse * 0.15),
                  blurRadius: glowRadius,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: isCentered ? 56 : 44,
            height: isCentered ? 56 : 44,
            decoration: BoxDecoration(
              color: isCentered
                  ? color.withValues(alpha: 0.2)
                  : AppColors.background,
              borderRadius:
                  BorderRadius.circular(isCentered ? 16 : 12),
              border: Border.all(
                color: isCentered
                    ? color.withValues(alpha: 0.5)
                    : AppColors.cardBorder,
              ),
            ),
            child: Icon(
              preset.icon,
              size: isCentered ? 28 : 20,
              color: isCentered ? color : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            preset.label,
            style: AppTextStyles.titleSmall.copyWith(
              color:
                  isCentered ? color : AppColors.textSecondary,
              fontSize: isCentered ? 13 : 11,
            ),
            textAlign: TextAlign.center,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            child: isCentered
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                    child: Text(
                      preset.description,
                      style: AppTextStyles.bodySmall
                          .copyWith(fontSize: 9),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─── Apply button (shared) ────────────────────────────────────────────────────

class _ApplyButton extends StatelessWidget {
  const _ApplyButton({
    required this.preset,
    required this.isApplied,
    required this.onApply,
  });

  final VaultPreset preset;
  final bool isApplied;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final color = preset.accentColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: isApplied
              ? null
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 18,
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: isApplied ? null : onApply,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isApplied ? AppColors.surfaceLight : color,
            disabledBackgroundColor: AppColors.surfaceLight,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isApplied
                    ? color.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isApplied
                    ? Icons.check_circle_rounded
                    : Icons.bolt_rounded,
                color: isApplied ? color : Colors.black,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isApplied
                    ? 'Already applied'
                    : 'Apply  ${preset.label}',
                style: AppTextStyles.titleSmall.copyWith(
                  color: isApplied ? color : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
