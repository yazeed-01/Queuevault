import 'package:confetti/confetti.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/item_images.dart';
import '../../../core/widgets/category_badge.dart';
import '../../../core/widgets/glass_card.dart';
import '../../vault/data/models/item_type.dart';
import '../../vault/domain/vault_providers.dart';
import '../../recommendations/presentation/recommendations_screen.dart';
import 'reminder_sheet.dart';

final _itemDetailProvider =
    FutureProvider.autoDispose.family<VaultItem?, int>((ref, id) async {
  return ref.watch(vaultRepositoryProvider).getById(id);
});

class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(_itemDetailProvider(itemId));

    return itemAsync.when(
      data: (item) => item == null
          ? const Scaffold(body: Center(child: Text('Item not found')))
          : _DetailBody(item: item),
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (_, __) => const Scaffold(body: Center(child: Text('Error'))),
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  const _DetailBody({required this.item});
  final VaultItem item;

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
  late VaultItem _item;
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _deleteItem() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete "${_item.title}"?', style: AppTextStyles.titleMedium),
        content: Text('This cannot be undone.', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await ref.read(vaultRepositoryProvider).delete(_item.id);
      if (mounted) context.pop();
    }
  }

  Future<void> _updateItem(VaultItem updated) async {
    final wasCompleted = _item.status == ItemStatus.completed.value;
    final nowCompleted = updated.status == ItemStatus.completed.value;
    await ref.read(vaultRepositoryProvider).update(updated);
    setState(() => _item = updated);
    HapticFeedback.lightImpact();
    if (!wasCompleted && nowCompleted) {
      HapticFeedback.heavyImpact();
      _confetti.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = ItemTypeExt.fromString(_item.itemType);
    final showImageToggle =
        (_item.localImagePath?.isNotEmpty ?? false) &&
        (_item.posterUrl?.isNotEmpty ?? false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
        slivers: [
          _HeroBackdrop(item: _item, type: type, onDelete: _deleteItem),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryBadge(type: type),
                  const SizedBox(height: 10),
                  Text(_item.title, style: AppTextStyles.displayMedium),
                  if (_item.overview != null) ...[
                    const SizedBox(height: 12),
                    Text(_item.overview!,
                        style: AppTextStyles.bodyLarge, maxLines: 4,
                        overflow: TextOverflow.ellipsis),
                  ],
                  if (showImageToggle) ...[
                    const SizedBox(height: 16),
                    _ImagePreferenceTile(item: _item, onUpdate: _updateItem),
                  ],
                  const SizedBox(height: 20),
                  _StatusSelector(item: _item, onUpdate: _updateItem),
                  const SizedBox(height: 20),
                  _ProgressSection(item: _item, onUpdate: _updateItem),
                  const SizedBox(height: 20),
                  _ReminderTile(item: _item, onUpdate: _updateItem),
                  if (_item.notes != null || true) ...[
                    const SizedBox(height: 20),
                    _NotesSection(item: _item, onUpdate: _updateItem),
                  ],
                  const SizedBox(height: 24),
                  _RecommendationsButton(item: _item),
                  const SizedBox(height: 80),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
            ),
          ),
        ],
      ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              maxBlastForce: 30,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              colors: const [
                AppColors.primary,
                AppColors.accent,
                AppColors.success,
                Colors.amber,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => ReminderSheet(item: _item, onSave: _updateItem),
        ),
        icon: const Icon(Icons.alarm_add, color: Colors.white),
        label: Text('Reminder',
            style: AppTextStyles.titleSmall.copyWith(color: Colors.white)),
      ),
    );
  }
}

class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop({required this.item, required this.type, required this.onDelete});
  final VaultItem item;
  final ItemType type;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final backdropProvider = itemBackdropProvider(item);
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: GlassCard(
          borderRadius: 50,
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => context.push('/add/manual', extra: {
            'type': item.itemType,
            'item': item,
          }),
          child: GlassCard(
            borderRadius: 50,
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onDelete,
          child: GlassCard(
            borderRadius: 50,
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.delete_outline,
                color: AppColors.error.withOpacity(0.9), size: 20),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (backdropProvider != null)
              Hero(
                tag: 'vault_poster_${item.id}',
                child: Image(
                  image: backdropProvider,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.surfaceLight),
                ),
              )
            else
              Container(
                color: AppColors.surfaceLight,
                child: const Icon(Icons.movie_rounded,
                    size: 80, color: AppColors.textMuted),
              ),
            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.6),
                    AppColors.background,
                  ],
                  stops: const [0.4, 0.75, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusSelector extends StatelessWidget {
  const _StatusSelector({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final current = ItemStatusExt.fromString(item.status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: AppTextStyles.titleSmall),
        const SizedBox(height: 10),
        Row(
          children: ItemStatus.values.map((s) {
            final isSelected = current == s;
            final color = _statusColor(s);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onUpdate(item.copyWith(status: s.value));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.2)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? color.withValues(alpha: 0.6)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Text(s.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected ? color : AppColors.textMuted,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _statusColor(ItemStatus s) => switch (s) {
        ItemStatus.want => AppColors.primary,
        ItemStatus.inProgress => AppColors.accent,
        ItemStatus.completed => AppColors.success,
        ItemStatus.dropped => AppColors.textMuted,
      };
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final type = ItemTypeExt.fromString(item.itemType);
    return switch (type) {
      ItemType.series => _SeriesProgress(item: item, onUpdate: onUpdate),
      ItemType.anime => _AnimeProgress(item: item, onUpdate: onUpdate),
      ItemType.game => _GameProgress(item: item, onUpdate: onUpdate),
      ItemType.product => _ProductProgress(item: item, onUpdate: onUpdate),
      ItemType.movie => _MovieProgress(item: item, onUpdate: onUpdate),
    };
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title, style: AppTextStyles.titleSmall),
      );
}

class _MovieProgress extends StatelessWidget {
  const _MovieProgress({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final watched = item.status == ItemStatus.completed.value;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onUpdate(item.copyWith(
          status: watched ? ItemStatus.want.value : ItemStatus.completed.value,
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: watched
              ? AppColors.successGlow.withValues(alpha: 0.2)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: watched
                ? AppColors.success.withValues(alpha: 0.5)
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              watched ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: watched ? AppColors.success : AppColors.textMuted,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              watched ? 'Watched!' : 'Mark as watched',
              style: AppTextStyles.titleMedium.copyWith(
                color: watched ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeriesProgress extends StatelessWidget {
  const _SeriesProgress({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final season = item.currentSeason ?? 1;
    final episode = item.currentEpisode ?? 0;
    final totalEp = item.totalEpisodes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Progress'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              _StepRow(
                label: 'Season',
                value: season,
                onDecrement: season > 1
                    ? () => onUpdate(item.copyWith(
                          currentSeason: Value(season - 1),
                        ))
                    : null,
                onIncrement: () => onUpdate(item.copyWith(
                  currentSeason: Value(season + 1),
                  currentEpisode: const Value(0),
                )),
              ),
              const Divider(height: 24),
              _StepRow(
                label: 'Episode',
                value: episode,
                total: totalEp,
                onDecrement: episode > 0
                    ? () => onUpdate(item.copyWith(
                          currentEpisode: Value(episode - 1),
                        ))
                    : null,
                onIncrement: () => onUpdate(item.copyWith(
                  currentEpisode: Value(episode + 1),
                  status: totalEp != null && episode + 1 >= totalEp
                      ? ItemStatus.completed.value
                      : ItemStatus.inProgress.value,
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimeProgress extends StatelessWidget {
  const _AnimeProgress({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final ep = item.currentEpisodeAnime ?? 0;
    final total = item.totalEpisodesAnime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Progress'),
        if (item.nextAiringAt != null &&
            item.nextAiringAt!.isAfter(DateTime.now()))
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accentGlow.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.accent, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Ep ${item.nextAiringEpisode} airs in ${_daysUntil(item.nextAiringAt!)} days',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.accent),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: _StepRow(
            label: 'Episode',
            value: ep,
            total: total,
            onDecrement: ep > 0
                ? () => onUpdate(item.copyWith(
                      currentEpisodeAnime: Value(ep - 1),
                    ))
                : null,
            onIncrement: () => onUpdate(item.copyWith(
              currentEpisodeAnime: Value(ep + 1),
              status: total != null && ep + 1 >= total
                  ? ItemStatus.completed.value
                  : ItemStatus.inProgress.value,
            )),
          ),
        ),
      ],
    );
  }

  int _daysUntil(DateTime dt) =>
      dt.difference(DateTime.now()).inDays.clamp(0, 999);
}

class _GameProgress extends StatefulWidget {
  const _GameProgress({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  State<_GameProgress> createState() => _GameProgressState();
}

class _GameProgressState extends State<_GameProgress> {
  late double _pct;

  @override
  void initState() {
    super.initState();
    _pct = (widget.item.completionPercent ?? 0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Completion'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress', style: AppTextStyles.bodyMedium),
                  Text('${_pct.round()}%',
                      style: AppTextStyles.titleMedium
                          .copyWith(color: AppColors.accent)),
                ],
              ),
              const SizedBox(height: 12),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.accent,
                  inactiveTrackColor: AppColors.cardBorder,
                  thumbColor: AppColors.accent,
                  overlayColor: AppColors.accentGlow,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _pct,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (v) => setState(() => _pct = v),
                  onChangeEnd: (v) => widget.onUpdate(widget.item.copyWith(
                    completionPercent: Value(v.round()),
                    status: v >= 100
                        ? ItemStatus.completed.value
                        : ItemStatus.inProgress.value,
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductProgress extends StatelessWidget {
  const _ProductProgress({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final purchased = item.purchased;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Purchase Status'),
        if (item.targetPrice != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.attach_money,
                    color: AppColors.buyColor, size: 18),
                Text(
                  'Target: \$${item.targetPrice!.toStringAsFixed(2)}',
                  style: AppTextStyles.titleSmall
                      .copyWith(color: AppColors.buyColor),
                ),
              ],
            ),
          ),
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            onUpdate(item.copyWith(
              purchased: !purchased,
              status: !purchased
                  ? ItemStatus.completed.value
                  : ItemStatus.want.value,
            ));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: purchased
                  ? AppColors.buyColor.withValues(alpha: 0.15)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: purchased
                    ? AppColors.buyColor.withValues(alpha: 0.5)
                    : AppColors.cardBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  purchased
                      ? Icons.check_circle_rounded
                      : Icons.shopping_cart_outlined,
                  color: purchased ? AppColors.buyColor : AppColors.textMuted,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  purchased ? 'Purchased!' : 'Mark as purchased',
                  style: AppTextStyles.titleMedium.copyWith(
                    color:
                        purchased ? AppColors.buyColor : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.label,
    required this.value,
    this.total,
    this.onDecrement,
    this.onIncrement,
  });

  final String label;
  final int value;
  final int? total;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Row(
          children: [
            _StepBtn(
              icon: Icons.remove,
              onTap: onDecrement,
            ),
            SizedBox(
              width: 60,
              child: Text(
                total != null ? '$value / $total' : '$value',
                style: AppTextStyles.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            _StepBtn(icon: Icons.add, onTap: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap == null ? null : () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: onTap != null ? AppColors.primaryGlow : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: onTap != null
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : AppColors.cardBorder,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: onTap != null ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      );
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final hasReminder = item.reminderEnabled && item.reminderAt != null;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => ReminderSheet(item: item, onSave: onUpdate),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasReminder
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasReminder
                ? AppColors.accent.withValues(alpha: 0.4)
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasReminder ? Icons.alarm_on : Icons.alarm_add_outlined,
              color: hasReminder ? AppColors.accent : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasReminder ? 'Reminder set' : 'Set a reminder',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: hasReminder
                          ? AppColors.accent
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (hasReminder)
                    Text(
                      _formatDate(item.reminderAt!),
                      style: AppTextStyles.bodySmall,
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = dt.difference(now);
    if (diff.inDays == 0) return 'Today at ${_time(dt)}';
    if (diff.inDays == 1) return 'Tomorrow at ${_time(dt)}';
    return '${dt.day}/${dt.month}/${dt.year} at ${_time(dt)}';
  }

  String _time(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _ImagePreferenceTile extends StatelessWidget {
  const _ImagePreferenceTile({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  Widget build(BuildContext context) {
    final useLocal = item.useLocalImage;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: useLocal
            ? AppColors.primaryGlow.withValues(alpha: 0.12)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: useLocal
              ? AppColors.primary.withValues(alpha: 0.45)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.image_rounded,
              color: useLocal ? AppColors.primary : AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  useLocal ? 'Using custom image' : 'Using default poster',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: useLocal
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  useLocal
                      ? 'Show your uploaded image on home'
                      : 'Show the original poster on home',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: useLocal,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onUpdate(item.copyWith(useLocalImage: v));
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _NotesSection extends StatefulWidget {
  const _NotesSection({required this.item, required this.onUpdate});
  final VaultItem item;
  final void Function(VaultItem) onUpdate;

  @override
  State<_NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<_NotesSection> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.item.notes ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Notes'),
        TextField(
          controller: _ctrl,
          maxLines: 3,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          onChanged: (v) => widget.onUpdate(widget.item.copyWith(
            notes: Value(v.isEmpty ? null : v),
          )),
          decoration: const InputDecoration(
            hintText: 'Add a note...',
          ),
        ),
      ],
    );
  }
}

class _RecommendationsButton extends StatelessWidget {
  const _RecommendationsButton({required this.item});
  final VaultItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RecommendationsScreen(item: item),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryGlow.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('More Like This',
                      style: AppTextStyles.titleSmall
                          .copyWith(color: AppColors.primary)),
                  Text('Get recommendations based on this item',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
