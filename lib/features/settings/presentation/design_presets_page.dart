import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../vault/domain/layout_preferences_provider.dart';
import '../../vault/presentation/widgets/design_picker_sheet.dart';

class DesignPresetsPage extends ConsumerStatefulWidget {
  const DesignPresetsPage({super.key});

  @override
  ConsumerState<DesignPresetsPage> createState() => _DesignPresetsPageState();
}

class _DesignPresetsPageState extends ConsumerState<DesignPresetsPage>
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
      duration: const Duration(milliseconds: 1800),
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
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient background glow
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (_, __) => Positioned(
              top: -80,
              left: screenW / 2 - 160,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(
                          alpha: 0.18 + _glowCtrl.value * 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: AppColors.textPrimary, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child:
                            Text('Design Presets', style: AppTextStyles.titleLarge),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Active preset banner
                _ActivePresetBanner(
                  preset: _current,
                  isApplied: activePreset == _current,
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 28),

                // Cylinder wheel — reuses shared widget
                Expanded(
                  child: DesignCylinderWheel(
                    centeredIndex: _centeredIndex,
                    controller: _wheelCtrl,
                    glowAnim: _glowCtrl,
                    onItemChanged: _onItemChanged,
                  ),
                ),

                const SizedBox(height: 20),

                // Apply button — reuses shared widget via local wrapper
                _PageApplyButton(
                  preset: _current,
                  isApplied: activePreset == _current,
                  onApply: _apply,
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 150.ms)
                    .slideY(begin: 0.12, end: 0),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Active preset info banner ────────────────────────────────────────────────

class _ActivePresetBanner extends StatelessWidget {
  const _ActivePresetBanner({required this.preset, required this.isApplied});

  final VaultPreset preset;
  final bool isApplied;

  @override
  Widget build(BuildContext context) {
    final color = preset.accentColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: Container(
          key: ValueKey(preset),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Icon(preset.icon, size: 24, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(preset.label,
                            style:
                                AppTextStyles.titleMedium.copyWith(color: color)),
                        if (isApplied) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('ACTIVE',
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: color, fontSize: 9)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(preset.description, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 5,
                      children: preset.tags.toSet().map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: color.withValues(alpha: 0.25)),
                            ),
                            child: Text(t,
                                style: AppTextStyles.labelSmall
                                    .copyWith(color: color, fontSize: 9)),
                          )).toList(),
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
}

// ─── Apply button (full-page variant with larger shadow) ─────────────────────

class _PageApplyButton extends StatelessWidget {
  const _PageApplyButton({
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
              : [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 24)],
        ),
        child: ElevatedButton(
          onPressed: isApplied ? null : onApply,
          style: ElevatedButton.styleFrom(
            backgroundColor: isApplied ? AppColors.surfaceLight : color,
            disabledBackgroundColor: AppColors.surfaceLight,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isApplied ? color.withValues(alpha: 0.3) : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isApplied ? Icons.check_circle_rounded : Icons.bolt_rounded,
                color: isApplied ? color : Colors.black,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isApplied ? 'Already applied' : 'Apply  ${preset.label}',
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
