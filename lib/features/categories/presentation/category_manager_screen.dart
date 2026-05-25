import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/category_icons.dart';
import '../../vault/domain/vault_providers.dart';

class CategoryManagerScreen extends ConsumerWidget {
  const CategoryManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Categories', style: AppTextStyles.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => _showAddSheet(context, ref),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryGlow,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: Text('Add', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
            ),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (cats) => cats.isEmpty
            ? Center(child: Text('No categories', style: AppTextStyles.bodyMedium))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _CategoryTile(
                  category: cats[i],
                  index: i,
                  onEdit: () => _showEditSheet(context, ref, cats[i]),
                  onDelete: () => _confirmDelete(context, ref, cats[i]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CategorySheet(
        onSave: (name, iconName, colorHex) async {
          final db = ref.read(appDatabaseProvider);
          final cats = await db.getAllCategories();
          final typeKey = name.toLowerCase().replaceAll(' ', '_');
          await db.insertCategory(CategoriesCompanion.insert(
            typeKey: typeKey,
            name: name,
            iconName: iconName,
            colorHex: colorHex,
            sortOrder: Value(cats.length),
          ));
        },
      ),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, Category cat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CategorySheet(
        initial: cat,
        onSave: (name, iconName, colorHex) async {
          final db = ref.read(appDatabaseProvider);
          await db.updateCategory(cat.copyWith(
            name: name,
            iconName: iconName,
            colorHex: colorHex,
          ));
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Category cat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete "${cat.name}"?', style: AppTextStyles.titleMedium),
        content: Text(
          cat.isDefault
              ? 'This is a default category. Vault items with this type will still exist but won\'t appear in the filter bar.'
              : 'Vault items with this category will still exist.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete',
                  style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(appDatabaseProvider).deleteCategory(cat.id);
    }
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });
  final Category category;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = _hexToColor(category.colorHex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Icon(CategoryIcons.resolve(category.iconName), color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: AppTextStyles.titleSmall),
                const SizedBox(height: 2),
                Text(
                  category.isDefault ? 'Default' : 'Custom',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: category.isDefault
                        ? AppColors.primary.withOpacity(0.7)
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, size: 20, color: AppColors.error.withOpacity(0.7)),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: index * 40))
        .fadeIn(duration: 250.ms)
        .slideX(begin: 0.05, end: 0);
  }
}

class _CategorySheet extends StatefulWidget {
  const _CategorySheet({this.initial, required this.onSave});
  final Category? initial;
  final Future<void> Function(String name, String iconName, String colorHex) onSave;

  @override
  State<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<_CategorySheet> {
  final _nameCtrl = TextEditingController();
  String _selectedIcon = 'category';
  String _selectedColor = 'FF00F0FF';
  bool _saving = false;

  static const _colorOptions = [
    ('FF00F0FF', 'Cyan'),
    ('FF00FF41', 'Green'),
    ('FFFF0055', 'Pink'),
    ('FFFFD600', 'Yellow'),
    ('FF9C27B0', 'Purple'),
    ('FFFF6B35', 'Orange'),
    ('FF2196F3', 'Blue'),
    ('FFFF5252', 'Red'),
    ('FF4CAF50', 'Mint'),
    ('FFFF80AB', 'Rose'),
  ];

  static final _iconOptions = CategoryIcons.iconMap.keys.toList();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _nameCtrl.text = widget.initial!.name;
      _selectedIcon = widget.initial!.iconName;
      _selectedColor = widget.initial!.colorHex;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    await widget.onSave(name, _selectedIcon, _selectedColor);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final color = _hexToColor(_selectedColor);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.initial == null ? 'New Category' : 'Edit Category',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 20),

          // Name field
          TextField(
            controller: _nameCtrl,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Category name',
              labelStyle: AppTextStyles.bodySmall,
              filled: true,
              fillColor: AppColors.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Color picker
          Text('Color', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _colorOptions.map((opt) {
              final (hex, label) = opt;
              final c = _hexToColor(hex);
              final selected = _selectedColor == hex;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = hex),
                child: AnimatedContainer(
                  duration: 150.ms,
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.white : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: selected
                        ? [BoxShadow(color: c.withOpacity(0.6), blurRadius: 8)]
                        : null,
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 18, color: Colors.black)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Icon picker
          Text('Icon', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _iconOptions.map((iconName) {
              final selected = _selectedIcon == iconName;
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = iconName),
                child: AnimatedContainer(
                  duration: 150.ms,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected ? color.withOpacity(0.2) : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? color : AppColors.cardBorder,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Icon(
                    CategoryIcons.resolve(iconName),
                    size: 22,
                    color: selected ? color : AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _saving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : Text('Save', style: AppTextStyles.titleSmall.copyWith(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}

Color _hexToColor(String hex) {
  final clean = hex.replaceAll('#', '');
  return Color(int.parse(clean.length == 6 ? 'FF$clean' : clean, radix: 16));
}
