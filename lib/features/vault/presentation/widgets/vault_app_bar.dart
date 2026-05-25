import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/layout_preferences_provider.dart';
import 'design_picker_sheet.dart';

/// Shared SliverAppBar used by every vault layout.
/// Includes the design-picker gun button on the trailing side.
class VaultSliverAppBar extends ConsumerWidget {
  const VaultSliverAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(layoutPrefsProvider).preset.accentColor;

    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background,
      expandedHeight: 80,
      actions: [
        // Design picker trigger
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => showDesignPickerSheet(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 22),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(Icons.style_rounded, size: 17, color: color),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 60, 16),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.video_library,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text('QueueVault', style: AppTextStyles.titleLarge),
          ],
        ),
      ),
    );
  }
}
