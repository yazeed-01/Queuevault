import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../../core/notifications/notification_service.dart';

class ReminderSheet extends ConsumerStatefulWidget {
  const ReminderSheet({super.key, required this.item, required this.onSave});
  final VaultItem item;
  final void Function(VaultItem) onSave;

  @override
  ConsumerState<ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends ConsumerState<ReminderSheet> {
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.item.reminderAt != null) {
      _selectedDate = widget.item.reminderAt!;
      _enabled = widget.item.reminderEnabled;
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (d != null) {
      setState(() => _selectedDate = DateTime(
            d.year, d.month, d.day,
            _selectedDate.hour, _selectedDate.minute,
          ));
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (t != null) {
      setState(() => _selectedDate = DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day,
            t.hour, t.minute,
          ));
    }
  }

  Future<void> _save() async {
    final updated = widget.item.copyWith(
      reminderAt: Value(_selectedDate),
      reminderEnabled: _enabled,
    );
    widget.onSave(updated);

    if (_enabled) {
      await ref.read(notificationServiceProvider).scheduleReminder(
            id: widget.item.id,
            title: widget.item.title,
            body: 'Time to check "${widget.item.title}"!',
            scheduledAt: _selectedDate,
            posterUrl: widget.item.posterUrl,
          );
    } else {
      await ref.read(notificationServiceProvider).cancel(widget.item.id);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, ctrl) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 20),
            Text('Set Reminder', style: AppTextStyles.titleLarge),
            const SizedBox(height: 6),
            Text('Get notified about "${widget.item.title}"',
                style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _DateTimeTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTimeTile(
                    icon: Icons.access_time_rounded,
                    label: 'Time',
                    value: '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Enable reminder', style: AppTextStyles.bodyMedium),
                const Spacer(),
                Switch(value: _enabled, onChanged: (v) => setState(() => _enabled = v)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.accent),
                const SizedBox(width: 6),
                Text(label, style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 6),
            Text(value,
                style: AppTextStyles.titleSmall
                    .copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
