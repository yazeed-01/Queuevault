import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import 'models/item_type.dart';

class VaultRepository {
  VaultRepository(this._db);

  final AppDatabase _db;

  Stream<List<VaultItem>> watchAll() => _db.watchAllItems();

  Stream<List<VaultItem>> watchByType(ItemType type) =>
      _db.watchItemsByType(type.value);

  Stream<List<VaultItem>> watchByTypeKey(String typeKey) =>
      _db.watchItemsByType(typeKey);

  Future<VaultItem?> getById(int id) => _db.getItemById(id);

  Future<int> add(VaultItemsCompanion item) => _db.insertItem(item);

  Future<bool> update(VaultItem item) => _db.updateItem(
        item.copyWith(updatedAt: Value(DateTime.now())),
      );

  Future<int> delete(int id) => _db.deleteItem(id);

  Future<List<VaultItem>> getAll() => _db.getAllItems();

  Future<void> replaceAll(List<VaultItemsCompanion> items) =>
      _db.replaceAll(items);
}
