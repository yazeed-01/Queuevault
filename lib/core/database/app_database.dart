import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get typeKey => text()();
  TextColumn get name => text()();
  TextColumn get iconName => text()(); // key into CategoryIcons.iconMap
  TextColumn get colorHex => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class VaultItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemType => text()();
  TextColumn get status => text().withDefault(const Constant('want'))();
  TextColumn get title => text()();
  TextColumn get posterUrl => text().nullable()();
  TextColumn get backdropUrl => text().nullable()();
  TextColumn get overview => text().nullable()();
  TextColumn get externalId => text().nullable()();
  TextColumn get externalUrl => text().nullable()();

  DateTimeColumn get reminderAt => dateTime().nullable()();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();

  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  IntColumn get runtimeMinutes => integer().nullable()();
  IntColumn get releaseYear => integer().nullable()();
  TextColumn get genre => text().nullable()();

  IntColumn get totalSeasons => integer().nullable()();
  IntColumn get currentSeason => integer().nullable()();
  IntColumn get currentEpisode => integer().nullable()();
  IntColumn get totalEpisodes => integer().nullable()();

  IntColumn get totalEpisodesAnime => integer().nullable()();
  IntColumn get currentEpisodeAnime => integer().nullable()();
  TextColumn get airingStatus => text().nullable()();
  TextColumn get animeFormat => text().nullable()();
  IntColumn get anilistId => integer().nullable()();
  IntColumn get nextAiringEpisode => integer().nullable()();
  DateTimeColumn get nextAiringAt => dateTime().nullable()();

  IntColumn get completionPercent => integer().nullable()();
  IntColumn get metacriticScore => integer().nullable()();
  IntColumn get estimatedPlaytimeHours => integer().nullable()();
  IntColumn get hoursPlayed => integer().nullable()();
  TextColumn get platform => text().nullable()();

  RealColumn get targetPrice => real().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get storeUrl => text().nullable()();
  BoolColumn get purchased => boolean().withDefault(const Constant(false))();
  TextColumn get productCategory => text().nullable()();

  TextColumn get tags => text().withDefault(const Constant(''))();
  IntColumn get userRating => integer().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get useLocalImage => boolean().withDefault(const Constant(true))();
  TextColumn get localImagePath => text().nullable()();
}

@DriftDatabase(tables: [VaultItems, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultCategories();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(categories);
            await _seedDefaultCategories();
          }
          if (from < 3) {
            await m.addColumn(vaultItems, vaultItems.localImagePath);
          }
          if (from < 4) {
            await m.addColumn(vaultItems, vaultItems.useLocalImage);
          }
        },
      );

  static const _defaultCategories = [
    (typeKey: 'movie',   name: 'Movies',   iconName: 'movie',          colorHex: 'FF00F0FF', order: 0),
    (typeKey: 'series',  name: 'Series',   iconName: 'tv',             colorHex: 'FF9C27B0', order: 1),
    (typeKey: 'anime',   name: 'Anime',    iconName: 'auto_awesome',   colorHex: 'FFFF0055', order: 2),
    (typeKey: 'game',    name: 'Games',    iconName: 'sports_esports', colorHex: 'FF00FF41', order: 3),
    (typeKey: 'product', name: 'Products', iconName: 'shopping_bag',   colorHex: 'FFFFD600', order: 4),
  ];

  Future<void> _seedDefaultCategories() async {
    await batch((b) => b.insertAll(
      categories,
      _defaultCategories.map((d) => CategoriesCompanion.insert(
        typeKey: d.typeKey,
        name: d.name,
        iconName: d.iconName,
        colorHex: d.colorHex,
        isDefault: const Value(true),
        sortOrder: Value(d.order),
      )).toList(),
    ));
  }

  // Categories CRUD
  Stream<List<Category>> watchCategories() =>
      (select(categories)..orderBy([(c) => OrderingTerm(expression: c.sortOrder)])).watch();

  Future<List<Category>> getAllCategories() =>
      (select(categories)..orderBy([(c) => OrderingTerm(expression: c.sortOrder)])).get();

  Future<int> insertCategory(CategoriesCompanion cat) =>
      into(categories).insert(cat);

  Future<bool> updateCategory(Category cat) =>
      update(categories).replace(cat);

  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Future<void> resetToDefaults() async {
    await transaction(() async {
      await delete(vaultItems).go();
      await delete(categories).go();
      await _seedDefaultCategories();
    });
  }

  // Vault CRUD
  Future<List<VaultItem>> getAllItems() => select(vaultItems).get();

  Stream<List<VaultItem>> watchAllItems() => select(vaultItems).watch();

  Stream<List<VaultItem>> watchItemsByType(String type) =>
      (select(vaultItems)..where((t) => t.itemType.equals(type))).watch();

  Future<VaultItem?> getItemById(int id) =>
      (select(vaultItems)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertItem(VaultItemsCompanion item) =>
      into(vaultItems).insert(item);

  Future<bool> updateItem(VaultItem item) => update(vaultItems).replace(item);

  Future<int> deleteItem(int id) =>
      (delete(vaultItems)..where((t) => t.id.equals(id))).go();

  Future<List<VaultItem>> getItemsDueForReminder(DateTime before) {
    return (select(vaultItems)
          ..where((t) =>
              t.reminderEnabled.equals(true) &
              t.reminderAt.isSmallerThanValue(before)))
        .get();
  }

  Future<void> replaceAll(List<VaultItemsCompanion> items) async {
    await transaction(() async {
      await delete(vaultItems).go();
      await batch((b) => b.insertAll(vaultItems, items));
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'queuevault.db'));
    return NativeDatabase.createInBackground(file);
  });
}
