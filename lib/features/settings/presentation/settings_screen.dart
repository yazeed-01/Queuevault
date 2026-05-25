import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../sync/presentation/sync_section.dart';
import '../../vault/domain/layout_preferences_provider.dart';
import '../../vault/domain/vault_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader('Appearance'),
          const _AppearanceSection(),
          const SizedBox(height: 24),
          _SectionHeader('API Keys'),
          _ActionTile(
            label: 'Manage API Keys',
            icon: Icons.key_rounded,
            onTap: () => context.push('/api-keys'),
          ),
          const SizedBox(height: 24),
          _SectionHeader('Google Drive Backup'),
          const SyncSection(),
          const SizedBox(height: 24),
          _SectionHeader('Categories'),
          _ActionTile(
            label: 'Manage Categories',
            icon: Icons.category_rounded,
            onTap: () => context.push('/categories'),
          ),
          const SizedBox(height: 24),
          _SectionHeader('Danger Zone'),
          _ResetTile(),
          const SizedBox(height: 24),
          _SectionHeader('About'),
          _InfoTile(label: 'Version', value: '1.0.0'),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary,
            letterSpacing: 1.5,
          ),
        ),
      );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ResetTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Icon(Icons.restore_rounded, color: AppColors.error),
        title: Text('Reset to Default', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
        subtitle: Text('Deletes all vault data & restores default categories', style: AppTextStyles.bodySmall),
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text('Reset Everything?', style: AppTextStyles.titleMedium),
              content: Text(
                'This will permanently delete all vault items and restore default categories. This cannot be undone.',
                style: AppTextStyles.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text('Reset', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          );
          if (confirm == true) {
            await ref.read(appDatabaseProvider).resetToDefaults();
            await googleSignIn.signOut();
            ref.read(authStateProvider.notifier).state = null;
            ref.read(selectedFilterProvider.notifier).state = null;
            if (context.mounted) context.go('/vault');
          }
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value,
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// ─── Appearance section — nav tile to Design Presets page ────────────────────

class _AppearanceSection extends ConsumerWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(layoutPrefsProvider).preset;
    final color = preset.accentColor;

    return GestureDetector(
      onTap: () => context.push('/design-presets'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.10),
              blurRadius: 14,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Icon(preset.icon, size: 22, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Design Presets',
                      style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('Active: ',
                          style: AppTextStyles.bodySmall),
                      Text(preset.label,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: color)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.7), size: 22),
          ],
        ),
      ),
    );
  }
}
