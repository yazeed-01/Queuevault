import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../data/vault_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final vaultRepositoryProvider = Provider<VaultRepository>((ref) {
  return VaultRepository(ref.watch(appDatabaseProvider));
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(appDatabaseProvider).watchCategories();
});

final selectedFilterProvider = StateProvider<String?>((ref) => null);

final vaultStreamProvider = StreamProvider<List<VaultItem>>((ref) {
  final repo = ref.watch(vaultRepositoryProvider);
  final filter = ref.watch(selectedFilterProvider);
  return filter == null ? repo.watchAll() : repo.watchByTypeKey(filter);
});

final allVaultStreamProvider = StreamProvider<List<VaultItem>>((ref) {
  return ref.watch(vaultRepositoryProvider).watchAll();
});
