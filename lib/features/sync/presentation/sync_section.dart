import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift show Value;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_env.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/database/app_database.dart';
import '../../vault/domain/vault_providers.dart';

const _kAutoSync = 'auto_sync_enabled';

final googleSignIn = GoogleSignIn(
  scopes: [drive.DriveApi.driveAppdataScope],
);

final authStateProvider = StateProvider<GoogleSignInAccount?>((ref) => null);
final _syncStatusProvider = StateProvider<String?>((ref) => null);

class SyncSection extends ConsumerStatefulWidget {
  const SyncSection({super.key});

  @override
  ConsumerState<SyncSection> createState() => _SyncSectionState();
}

class _SyncSectionState extends ConsumerState<SyncSection>
    with WidgetsBindingObserver {
  bool _autoSync = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _silentSignIn();
    _loadAutoSync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _autoSync) {
      final account = ref.read(authStateProvider);
      if (account != null) _syncNow();
    }
  }

  Future<void> _loadAutoSync() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => _autoSync = prefs.getBool(_kAutoSync) ?? false);
  }

  Future<void> _setAutoSync(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAutoSync, value);
    if (mounted) setState(() => _autoSync = value);
  }

  Future<void> _silentSignIn() async {
    final account = await googleSignIn.signInSilently();
    if (account != null && mounted) {
      ref.read(authStateProvider.notifier).state = account;
    }
  }

  Future<void> _signIn() async {
    try {
      final account = await googleSignIn.signIn();
      if (account != null) {
        ref.read(authStateProvider.notifier).state = account;
      }
    } catch (e) {
      _showError('Sign-in failed: $e');
    }
  }

  Future<void> _signOut() async {
    await googleSignIn.signOut();
    ref.read(authStateProvider.notifier).state = null;
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final client = await googleSignIn.authenticatedClient();
    if (client == null) return null;
    return drive.DriveApi(client);
  }

  Future<void> _syncNow() async {
    ref.read(_syncStatusProvider.notifier).state = 'Uploading...';
    try {
      final api = await _getDriveApi();
      if (api == null) throw Exception('Not authenticated');

      final items = await ref.read(vaultRepositoryProvider).getAll();
      final json = jsonEncode(items.map(_itemToMap).toList());
      final bytes = utf8.encode(json);

      final media = drive.Media(
        Stream.value(bytes),
        bytes.length,
        contentType: 'application/json',
      );

      final existing = await api.files.list(
        spaces: 'appDataFolder',
        q: "name = 'vault_data.json'",
        $fields: 'files(id)',
      );

      if (existing.files != null && existing.files!.isNotEmpty) {
        await api.files.update(
          drive.File(),
          existing.files!.first.id!,
          uploadMedia: media,
        );
      } else {
        await api.files.create(
          drive.File()
            ..name = 'vault_data.json'
            ..parents = ['appDataFolder'],
          uploadMedia: media,
        );
      }

      // Upload local images
      for (final item in items) {
        if (item.localImagePath != null) {
          await _uploadImageToDrive(api, item.id, item.localImagePath!);
        }
      }

      ref.read(_syncStatusProvider.notifier).state =
          'Synced ${_formatNow()}';
    } catch (e) {
      ref.read(_syncStatusProvider.notifier).state = null;
      _showError('Sync failed: $e');
    }
  }

  Future<void> _uploadImageToDrive(
      drive.DriveApi api, int itemId, String localPath) async {
    final file = File(localPath);
    if (!await file.exists()) return;

    final driveName = 'item_image_$itemId${p.extension(localPath)}';
    final bytes = await file.readAsBytes();
    final media = drive.Media(
      Stream.value(bytes),
      bytes.length,
      contentType: 'image/jpeg',
    );

    final existing = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$driveName'",
      $fields: 'files(id)',
    );

    if (existing.files != null && existing.files!.isNotEmpty) {
      await api.files.update(
        drive.File(),
        existing.files!.first.id!,
        uploadMedia: media,
      );
    } else {
      await api.files.create(
        drive.File()
          ..name = driveName
          ..parents = ['appDataFolder'],
        uploadMedia: media,
      );
    }
  }

  Future<String?> _downloadImageFromDrive(
      drive.DriveApi api, int itemId, String ext) async {
    final driveName = 'item_image_$itemId$ext';

    final existing = await api.files.list(
      spaces: 'appDataFolder',
      q: "name = '$driveName'",
      $fields: 'files(id)',
    );

    if (existing.files == null || existing.files!.isEmpty) return null;

    final media = await api.files.get(
      existing.files!.first.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final bytes = <int>[];
    await for (final chunk in media.stream) {
      bytes.addAll(chunk);
    }

    final dir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(dir.path, 'item_images'));
    if (!await imagesDir.exists()) await imagesDir.create(recursive: true);

    final dest = File(p.join(imagesDir.path, driveName));
    await dest.writeAsBytes(bytes);
    return dest.path;
  }

  Future<void> _importFromDrive() async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (_) => const AlertDialog(
        backgroundColor: AppColors.surface,
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Fetching backup…'),
          ],
        ),
      ),
    );

    try {
      final api = await _getDriveApi();
      if (api == null) throw Exception('Not authenticated');

      final existing = await api.files.list(
        spaces: 'appDataFolder',
        q: "name = 'vault_data.json'",
        $fields: 'files(id)',
      );

      if (existing.files == null || existing.files!.isEmpty) {
        if (mounted) Navigator.of(context, rootNavigator: false).pop();
        _showError('No backup found on Drive');
        return;
      }

      final media = await api.files.get(
        existing.files!.first.id!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = <int>[];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }

      final List<dynamic> json = jsonDecode(utf8.decode(bytes));

      if (!mounted) return;
      Navigator.of(context, rootNavigator: false).pop();

      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Import ${json.length} items?',
              style: AppTextStyles.titleMedium),
          content: Text(
            'Choose how to handle existing data:',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('Replace local',
                    style: TextStyle(color: AppColors.error))),
          ],
        ),
      );

      if (confirm != true) return;

      final companions =
          json.map((m) => _mapToCompanion(m as Map<String, dynamic>)).toList();
      await ref.read(vaultRepositoryProvider).replaceAll(companions);

      // Download images for items that had them
      final allItems = await ref.read(vaultRepositoryProvider).getAll();
      for (final item in allItems) {
        for (final ext in ['.jpg', '.jpeg', '.png', '.webp']) {
          final localPath =
              await _downloadImageFromDrive(api, item.id, ext);
          if (localPath != null) {
            await ref.read(vaultRepositoryProvider).update(
                  item.copyWith(localImagePath: Value(localPath)),
                );
            break;
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imported ${json.length} items')),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: false).pop();
      _showError('Import failed: $e');
    }
  }

  Map<String, dynamic> _itemToMap(VaultItem item) => {
        'itemType': item.itemType,
        'status': item.status,
        'title': item.title,
        'posterUrl': item.posterUrl,
        'backdropUrl': item.backdropUrl,
        'overview': item.overview,
        'externalId': item.externalId,
        'externalUrl': item.externalUrl,
        'reminderAt': item.reminderAt?.toIso8601String(),
        'reminderEnabled': item.reminderEnabled,
        'addedAt': item.addedAt.toIso8601String(),
        'updatedAt': item.updatedAt?.toIso8601String(),
        'runtimeMinutes': item.runtimeMinutes,
        'releaseYear': item.releaseYear,
        'genre': item.genre,
        'totalSeasons': item.totalSeasons,
        'currentSeason': item.currentSeason,
        'currentEpisode': item.currentEpisode,
        'totalEpisodes': item.totalEpisodes,
        'totalEpisodesAnime': item.totalEpisodesAnime,
        'currentEpisodeAnime': item.currentEpisodeAnime,
        'airingStatus': item.airingStatus,
        'animeFormat': item.animeFormat,
        'anilistId': item.anilistId,
        'completionPercent': item.completionPercent,
        'metacriticScore': item.metacriticScore,
        'estimatedPlaytimeHours': item.estimatedPlaytimeHours,
        'hoursPlayed': item.hoursPlayed,
        'platform': item.platform,
        'targetPrice': item.targetPrice,
        'currency': item.currency,
        'storeUrl': item.storeUrl,
        'purchased': item.purchased,
        'productCategory': item.productCategory,
        'tags': item.tags,
        'userRating': item.userRating,
        'notes': item.notes,
        'useLocalImage': item.useLocalImage,
        'localImagePath': item.localImagePath,
      };

  VaultItemsCompanion _mapToCompanion(Map<String, dynamic> m) {
    DateTime? parseDate(String? s) => s != null ? DateTime.parse(s) : null;
    return VaultItemsCompanion(
      itemType: drift.Value(m['itemType'] as String),
      status: drift.Value(m['status'] as String? ?? 'want'),
      title: drift.Value(m['title'] as String),
      posterUrl: drift.Value(m['posterUrl'] as String?),
      backdropUrl: drift.Value(m['backdropUrl'] as String?),
      overview: drift.Value(m['overview'] as String?),
      externalId: drift.Value(m['externalId'] as String?),
      externalUrl: drift.Value(m['externalUrl'] as String?),
      reminderAt: drift.Value(parseDate(m['reminderAt'] as String?)),
      reminderEnabled: drift.Value(m['reminderEnabled'] as bool? ?? false),
      addedAt: drift.Value(parseDate(m['addedAt'] as String?) ?? DateTime.now()),
      updatedAt: drift.Value(parseDate(m['updatedAt'] as String?)),
      runtimeMinutes: drift.Value(m['runtimeMinutes'] as int?),
      releaseYear: drift.Value(m['releaseYear'] as int?),
      genre: drift.Value(m['genre'] as String?),
      totalSeasons: drift.Value(m['totalSeasons'] as int?),
      currentSeason: drift.Value(m['currentSeason'] as int?),
      currentEpisode: drift.Value(m['currentEpisode'] as int?),
      totalEpisodes: drift.Value(m['totalEpisodes'] as int?),
      totalEpisodesAnime: drift.Value(m['totalEpisodesAnime'] as int?),
      currentEpisodeAnime: drift.Value(m['currentEpisodeAnime'] as int?),
      airingStatus: drift.Value(m['airingStatus'] as String?),
      animeFormat: drift.Value(m['animeFormat'] as String?),
      anilistId: drift.Value(m['anilistId'] as int?),
      completionPercent: drift.Value(m['completionPercent'] as int?),
      metacriticScore: drift.Value(m['metacriticScore'] as int?),
      estimatedPlaytimeHours: drift.Value(m['estimatedPlaytimeHours'] as int?),
      hoursPlayed: drift.Value(m['hoursPlayed'] as int?),
      platform: drift.Value(m['platform'] as String?),
      targetPrice: drift.Value((m['targetPrice'] as num?)?.toDouble()),
      currency: drift.Value(m['currency'] as String?),
      storeUrl: drift.Value(m['storeUrl'] as String?),
      purchased: drift.Value(m['purchased'] as bool? ?? false),
      productCategory: drift.Value(m['productCategory'] as String?),
      tags: drift.Value(m['tags'] as String? ?? ''),
      userRating: drift.Value(m['userRating'] as int?),
      notes: drift.Value(m['notes'] as String?),
      useLocalImage: drift.Value(m['useLocalImage'] as bool? ?? true),
      localImagePath: drift.Value(m['localImagePath'] as String?),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  String _formatNow() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(authStateProvider);
    final syncStatus = ref.watch(_syncStatusProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: account == null
          ? _SignedOutView(onSignIn: _signIn)
          : _SignedInView(
              account: account,
              syncStatus: syncStatus,
              autoSync: _autoSync,
              onAutoSyncChanged: _setAutoSync,
              onSignOut: _signOut,
              onSync: _syncNow,
              onImport: _importFromDrive,
            ),
    );
  }
}

class _SignedOutView extends StatelessWidget {
  const _SignedOutView({required this.onSignIn});
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_outlined, color: AppColors.textMuted),
              const SizedBox(width: 10),
              Text('Not connected', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Connect Google to backup your vault to Drive',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSignIn,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.cardBorder),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.account_circle_outlined,
                  color: AppColors.textSecondary),
              label: Text('Connect Google Account',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ),
          ),
        ],
      );
}

class _SignedInView extends StatelessWidget {
  const _SignedInView({
    required this.account,
    required this.syncStatus,
    required this.autoSync,
    required this.onAutoSyncChanged,
    required this.onSignOut,
    required this.onSync,
    required this.onImport,
  });
  final GoogleSignInAccount account;
  final String? syncStatus;
  final bool autoSync;
  final void Function(bool) onAutoSyncChanged;
  final VoidCallback onSignOut;
  final VoidCallback onSync;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_done_outlined, color: AppColors.success),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.email,
                        style: AppTextStyles.titleSmall),
                    if (syncStatus != null)
                      Text('Last synced: $syncStatus',
                          style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              TextButton(
                onPressed: onSignOut,
                child: Text('Sign out',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.error)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSync,
                  icon: const Icon(Icons.cloud_upload_outlined, size: 16),
                  label: const Text('Sync Now'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onImport,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.cardBorder),
                    foregroundColor: AppColors.textSecondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.cloud_download_outlined, size: 16),
                  label: const Text('Import'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text('Auto-sync when app closes',
                    style: AppTextStyles.bodySmall),
              ),
              Switch(
                value: autoSync,
                onChanged: onAutoSyncChanged,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primaryGlow,
              ),
            ],
          ),
        ],
      );
}
