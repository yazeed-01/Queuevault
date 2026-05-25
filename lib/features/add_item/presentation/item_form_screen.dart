import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../vault/data/models/item_type.dart';
import '../../vault/domain/vault_providers.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  const ItemFormScreen({super.key, required this.type, this.existingItem});
  final ItemType type;
  final VaultItem? existingItem;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _posterCtrl;
  late final TextEditingController _overviewCtrl;
  late final TextEditingController _genreCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _storeUrlCtrl;
  late final TextEditingController _platformCtrl;
  late ItemStatus _status;
  late ItemType _selectedType;

  File? _pickedImageFile;
  String? _existingLocalImagePath;

  @override
  void initState() {
    super.initState();
    final e = widget.existingItem;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _posterCtrl = TextEditingController(text: e?.posterUrl ?? '');
    _overviewCtrl = TextEditingController(text: e?.overview ?? '');
    _genreCtrl = TextEditingController(text: e?.genre ?? '');
    _yearCtrl = TextEditingController(text: e?.releaseYear?.toString() ?? '');
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
    _priceCtrl = TextEditingController(text: e?.targetPrice?.toString() ?? '');
    _storeUrlCtrl = TextEditingController(text: e?.storeUrl ?? '');
    _platformCtrl = TextEditingController(text: e?.platform ?? '');
    _status = e != null ? ItemStatusExt.fromString(e.status) : ItemStatus.want;
    _selectedType = e != null ? ItemTypeExt.fromString(e.itemType) : widget.type;
    _existingLocalImagePath = e?.localImagePath;
  }

  @override
  void dispose() {
    for (final c in [_titleCtrl, _posterCtrl, _overviewCtrl, _genreCtrl,
        _yearCtrl, _notesCtrl, _priceCtrl, _storeUrlCtrl, _platformCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (picked != null) {
      setState(() => _pickedImageFile = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
              title: Text('Take photo', style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
              title: Text('Choose from gallery', style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_pickedImageFile != null || _existingLocalImagePath != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.error),
                title: Text('Remove image',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _pickedImageFile = null;
                    _existingLocalImagePath = null;
                  });
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<String?> _saveImageLocally(File tempFile, String title) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'item_images'));
    if (!await imagesDir.exists()) await imagesDir.create(recursive: true);

    final ext = p.extension(tempFile.path).isNotEmpty
        ? p.extension(tempFile.path)
        : '.jpg';
    final fileName =
        '${title.replaceAll(RegExp(r'[^\w]'), '_')}_${DateTime.now().millisecondsSinceEpoch}$ext';
    final dest = File(p.join(imagesDir.path, fileName));
    await tempFile.copy(dest.path);
    return dest.path;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.mediumImpact();

    final repo = ref.read(vaultRepositoryProvider);
    final existing = widget.existingItem;
    final title = _titleCtrl.text.trim();

    String? localImagePath = _existingLocalImagePath;

    if (_pickedImageFile != null) {
      localImagePath = await _saveImageLocally(_pickedImageFile!, title);
    } else if (_existingLocalImagePath == null) {
      localImagePath = null;
    }

    bool useLocalImage = existing?.useLocalImage ?? true;
    if (localImagePath == null) {
      useLocalImage = false;
    } else if (_pickedImageFile != null) {
      useLocalImage = true;
    }

    if (existing != null) {
      await repo.update(existing.copyWith(
        itemType: _selectedType.value,
        title: title,
        posterUrl: Value(_posterCtrl.text.trim().isEmpty ? null : _posterCtrl.text.trim()),
        overview: Value(_overviewCtrl.text.trim().isEmpty ? null : _overviewCtrl.text.trim()),
        genre: Value(_genreCtrl.text.trim().isEmpty ? null : _genreCtrl.text.trim()),
        releaseYear: Value(int.tryParse(_yearCtrl.text.trim())),
        notes: Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        status: _status.value,
        targetPrice: Value(double.tryParse(_priceCtrl.text.trim())),
        storeUrl: Value(_storeUrlCtrl.text.trim().isEmpty ? null : _storeUrlCtrl.text.trim()),
        platform: Value(_platformCtrl.text.trim().isEmpty ? null : _platformCtrl.text.trim()),
        useLocalImage: useLocalImage,
        localImagePath: Value(localImagePath),
      ));
    } else {
      await repo.add(VaultItemsCompanion.insert(
        itemType: widget.type.value,
        title: title,
        status: Value(_status.value),
        posterUrl: Value(_posterCtrl.text.trim().isEmpty ? null : _posterCtrl.text.trim()),
        overview: Value(_overviewCtrl.text.trim().isEmpty ? null : _overviewCtrl.text.trim()),
        genre: Value(_genreCtrl.text.trim().isEmpty ? null : _genreCtrl.text.trim()),
        releaseYear: Value(int.tryParse(_yearCtrl.text.trim())),
        notes: Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        targetPrice: Value(double.tryParse(_priceCtrl.text.trim())),
        storeUrl: Value(_storeUrlCtrl.text.trim().isEmpty ? null : _storeUrlCtrl.text.trim()),
        platform: Value(_platformCtrl.text.trim().isEmpty ? null : _platformCtrl.text.trim()),
        useLocalImage: Value(useLocalImage),
        localImagePath: Value(localImagePath),
      ));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$title" saved to Vault')),
      );
      while (context.canPop()) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;
    final typeColor = _colorForType(widget.type);

    final displayImage = _pickedImageFile != null
        ? FileImage(_pickedImageFile!)
        : (_existingLocalImagePath != null
            ? FileImage(File(_existingLocalImagePath!))
            : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Add ${_labelForType(widget.type)}',
            style: AppTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save',
                style: AppTextStyles.titleSmall.copyWith(color: typeColor)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image picker
            _ImagePickerWidget(
              displayImage: displayImage as ImageProvider<Object>?,
              typeColor: typeColor,
              onTap: _showImageSourceSheet,
            ),
            const SizedBox(height: 16),

            // Category picker (only shown when editing)
            if (widget.existingItem != null) ...[
              _CategoryPicker(
                selected: _selectedType,
                onSelect: (t) => setState(() => _selectedType = t),
              ),
              const SizedBox(height: 12),
            ],

            // Title
            _Field(
              label: 'Title *',
              controller: _titleCtrl,
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),

            // Poster URL
            _Field(
              label: 'Poster URL',
              controller: _posterCtrl,
              hint: 'https://...',
            ),
            const SizedBox(height: 12),

            // Overview
            _Field(
              label: 'Description',
              controller: _overviewCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            // Genre
            _Field(
              label: 'Genre',
              controller: _genreCtrl,
              hint: 'e.g. Action, Drama',
            ),
            const SizedBox(height: 12),

            // Year
            _Field(
              label: 'Year',
              controller: _yearCtrl,
              keyboardType: TextInputType.number,
              hint: '2024',
            ),
            const SizedBox(height: 12),

            // Type-specific fields
            ..._typeSpecificFields(),
            const SizedBox(height: 12),

            // Status
            _StatusPicker(
              selected: _status,
              onSelect: (s) => setState(() => _status = s),
              typeColor: typeColor,
            ),
            const SizedBox(height: 12),

            // Notes
            _Field(
              label: 'Notes',
              controller: _notesCtrl,
              maxLines: 2,
              hint: 'Anything to remember...',
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: typeColor,
                minimumSize: const Size.fromHeight(52),
              ),
              child: Text(isEditing ? 'Save Changes' : 'Add to Vault',
                  style: AppTextStyles.titleMedium.copyWith(color: Colors.white)),
            ),
          ]
              .animate(interval: 40.ms)
              .fadeIn(duration: 250.ms)
              .slideY(begin: 0.08, end: 0),
        ),
      ),
    );
  }

  List<Widget> _typeSpecificFields() {
    return switch (widget.type) {
      ItemType.game => [
          _Field(
            label: 'Platform',
            controller: _platformCtrl,
            hint: 'PC, PS5, Xbox, Switch...',
          ),
        ],
      ItemType.product => [
          _Field(
            label: 'Target Price (\$)',
            controller: _priceCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: '299.99',
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Store URL',
            controller: _storeUrlCtrl,
            hint: 'https://amazon.com/...',
          ),
        ],
      _ => [],
    };
  }

  String _labelForType(ItemType t) => switch (t) {
        ItemType.movie => 'Movie',
        ItemType.series => 'Series',
        ItemType.anime => 'Anime',
        ItemType.game => 'Game',
        ItemType.product => 'Product',
      };

  Color _colorForType(ItemType t) => switch (t) {
        ItemType.movie || ItemType.series => AppColors.watchColor,
        ItemType.anime => AppColors.animeColor,
        ItemType.game => AppColors.playColor,
        ItemType.product => AppColors.buyColor,
      };
}

class _ImagePickerWidget extends StatelessWidget {
  const _ImagePickerWidget({
    required this.displayImage,
    required this.typeColor,
    required this.onTap,
  });

  final ImageProvider<Object>? displayImage;
  final Color typeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surfaceLight,
          border: Border.all(
            color: displayImage != null
                ? typeColor.withValues(alpha: 0.5)
                : AppColors.cardBorder,
          ),
          image: displayImage != null
              ? DecorationImage(image: displayImage!, fit: BoxFit.cover)
              : null,
        ),
        child: displayImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 40, color: typeColor.withValues(alpha: 0.7)),
                  const SizedBox(height: 8),
                  Text('Add image',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Text('Camera or Gallery',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.textMuted)),
                ],
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        size: 16, color: Colors.white),
                  ),
                ),
              ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.validator,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleSmall),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint ?? ''),
        ),
      ],
    );
  }
}

class _StatusPicker extends StatelessWidget {
  const _StatusPicker({
    required this.selected,
    required this.onSelect,
    required this.typeColor,
  });
  final ItemStatus selected;
  final void Function(ItemStatus) onSelect;
  final Color typeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ItemStatus.values.map((s) {
            final isSelected = s == selected;
            return GestureDetector(
              onTap: () => onSelect(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? typeColor.withValues(alpha: 0.2) : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? typeColor.withValues(alpha: 0.6) : AppColors.cardBorder,
                  ),
                ),
                child: Text(s.label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected ? typeColor : AppColors.textMuted,
                    )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.selected,
    required this.onSelect,
  });

  final ItemType selected;
  final void Function(ItemType) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ItemType.values.map((t) {
            final isSelected = t == selected;
            final (label, color, icon) = switch (t) {
              ItemType.movie => ('Movie', AppColors.watchColor, Icons.movie_rounded),
              ItemType.series => ('Series', AppColors.watchColor, Icons.tv_rounded),
              ItemType.anime => ('Anime', AppColors.animeColor, Icons.auto_awesome),
              ItemType.game => ('Game', AppColors.playColor, Icons.sports_esports_rounded),
              ItemType.product => ('Product', AppColors.buyColor, Icons.shopping_bag_rounded),
            };
            return GestureDetector(
              onTap: () => onSelect(t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color.withValues(alpha: 0.18) : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? color.withValues(alpha: 0.6) : AppColors.cardBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon,
                        size: 15,
                        color: isSelected ? color : AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected ? color : AppColors.textMuted,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

