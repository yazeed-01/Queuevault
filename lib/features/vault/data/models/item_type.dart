enum ItemType { movie, series, anime, game, product }

enum ItemStatus { want, inProgress, completed, dropped }

extension ItemTypeExt on ItemType {
  String get value => name;
  static ItemType fromString(String s) =>
      ItemType.values.firstWhere((e) => e.name == s);
}

extension ItemStatusExt on ItemStatus {
  String get value => name;
  static ItemStatus fromString(String s) =>
      ItemStatus.values.firstWhere((e) => e.name == s);

  String get label => switch (this) {
        ItemStatus.want => 'Want',
        ItemStatus.inProgress => 'In Progress',
        ItemStatus.completed => 'Completed',
        ItemStatus.dropped => 'Dropped',
      };
}
