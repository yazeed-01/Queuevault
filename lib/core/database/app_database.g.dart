// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VaultItemsTable extends VaultItems
    with TableInfo<$VaultItemsTable, VaultItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('want'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterUrlMeta = const VerificationMeta(
    'posterUrl',
  );
  @override
  late final GeneratedColumn<String> posterUrl = GeneratedColumn<String>(
    'poster_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backdropUrlMeta = const VerificationMeta(
    'backdropUrl',
  );
  @override
  late final GeneratedColumn<String> backdropUrl = GeneratedColumn<String>(
    'backdrop_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalUrlMeta = const VerificationMeta(
    'externalUrl',
  );
  @override
  late final GeneratedColumn<String> externalUrl = GeneratedColumn<String>(
    'external_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderAtMeta = const VerificationMeta(
    'reminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> reminderAt = GeneratedColumn<DateTime>(
    'reminder_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _runtimeMinutesMeta = const VerificationMeta(
    'runtimeMinutes',
  );
  @override
  late final GeneratedColumn<int> runtimeMinutes = GeneratedColumn<int>(
    'runtime_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta(
    'releaseYear',
  );
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalSeasonsMeta = const VerificationMeta(
    'totalSeasons',
  );
  @override
  late final GeneratedColumn<int> totalSeasons = GeneratedColumn<int>(
    'total_seasons',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentSeasonMeta = const VerificationMeta(
    'currentSeason',
  );
  @override
  late final GeneratedColumn<int> currentSeason = GeneratedColumn<int>(
    'current_season',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentEpisodeMeta = const VerificationMeta(
    'currentEpisode',
  );
  @override
  late final GeneratedColumn<int> currentEpisode = GeneratedColumn<int>(
    'current_episode',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalEpisodesMeta = const VerificationMeta(
    'totalEpisodes',
  );
  @override
  late final GeneratedColumn<int> totalEpisodes = GeneratedColumn<int>(
    'total_episodes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalEpisodesAnimeMeta =
      const VerificationMeta('totalEpisodesAnime');
  @override
  late final GeneratedColumn<int> totalEpisodesAnime = GeneratedColumn<int>(
    'total_episodes_anime',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentEpisodeAnimeMeta =
      const VerificationMeta('currentEpisodeAnime');
  @override
  late final GeneratedColumn<int> currentEpisodeAnime = GeneratedColumn<int>(
    'current_episode_anime',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _airingStatusMeta = const VerificationMeta(
    'airingStatus',
  );
  @override
  late final GeneratedColumn<String> airingStatus = GeneratedColumn<String>(
    'airing_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _animeFormatMeta = const VerificationMeta(
    'animeFormat',
  );
  @override
  late final GeneratedColumn<String> animeFormat = GeneratedColumn<String>(
    'anime_format',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _anilistIdMeta = const VerificationMeta(
    'anilistId',
  );
  @override
  late final GeneratedColumn<int> anilistId = GeneratedColumn<int>(
    'anilist_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextAiringEpisodeMeta = const VerificationMeta(
    'nextAiringEpisode',
  );
  @override
  late final GeneratedColumn<int> nextAiringEpisode = GeneratedColumn<int>(
    'next_airing_episode',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextAiringAtMeta = const VerificationMeta(
    'nextAiringAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAiringAt = GeneratedColumn<DateTime>(
    'next_airing_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completionPercentMeta = const VerificationMeta(
    'completionPercent',
  );
  @override
  late final GeneratedColumn<int> completionPercent = GeneratedColumn<int>(
    'completion_percent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metacriticScoreMeta = const VerificationMeta(
    'metacriticScore',
  );
  @override
  late final GeneratedColumn<int> metacriticScore = GeneratedColumn<int>(
    'metacritic_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedPlaytimeHoursMeta =
      const VerificationMeta('estimatedPlaytimeHours');
  @override
  late final GeneratedColumn<int> estimatedPlaytimeHours = GeneratedColumn<int>(
    'estimated_playtime_hours',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hoursPlayedMeta = const VerificationMeta(
    'hoursPlayed',
  );
  @override
  late final GeneratedColumn<int> hoursPlayed = GeneratedColumn<int>(
    'hours_played',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetPriceMeta = const VerificationMeta(
    'targetPrice',
  );
  @override
  late final GeneratedColumn<double> targetPrice = GeneratedColumn<double>(
    'target_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeUrlMeta = const VerificationMeta(
    'storeUrl',
  );
  @override
  late final GeneratedColumn<String> storeUrl = GeneratedColumn<String>(
    'store_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasedMeta = const VerificationMeta(
    'purchased',
  );
  @override
  late final GeneratedColumn<bool> purchased = GeneratedColumn<bool>(
    'purchased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("purchased" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _productCategoryMeta = const VerificationMeta(
    'productCategory',
  );
  @override
  late final GeneratedColumn<String> productCategory = GeneratedColumn<String>(
    'product_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _userRatingMeta = const VerificationMeta(
    'userRating',
  );
  @override
  late final GeneratedColumn<int> userRating = GeneratedColumn<int>(
    'user_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _useLocalImageMeta = const VerificationMeta(
    'useLocalImage',
  );
  @override
  late final GeneratedColumn<bool> useLocalImage = GeneratedColumn<bool>(
    'use_local_image',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_local_image" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _localImagePathMeta = const VerificationMeta(
    'localImagePath',
  );
  @override
  late final GeneratedColumn<String> localImagePath = GeneratedColumn<String>(
    'local_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemType,
    status,
    title,
    posterUrl,
    backdropUrl,
    overview,
    externalId,
    externalUrl,
    reminderAt,
    reminderEnabled,
    addedAt,
    updatedAt,
    runtimeMinutes,
    releaseYear,
    genre,
    totalSeasons,
    currentSeason,
    currentEpisode,
    totalEpisodes,
    totalEpisodesAnime,
    currentEpisodeAnime,
    airingStatus,
    animeFormat,
    anilistId,
    nextAiringEpisode,
    nextAiringAt,
    completionPercent,
    metacriticScore,
    estimatedPlaytimeHours,
    hoursPlayed,
    platform,
    targetPrice,
    currency,
    storeUrl,
    purchased,
    productCategory,
    tags,
    userRating,
    notes,
    useLocalImage,
    localImagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vault_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaultItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_url')) {
      context.handle(
        _posterUrlMeta,
        posterUrl.isAcceptableOrUnknown(data['poster_url']!, _posterUrlMeta),
      );
    }
    if (data.containsKey('backdrop_url')) {
      context.handle(
        _backdropUrlMeta,
        backdropUrl.isAcceptableOrUnknown(
          data['backdrop_url']!,
          _backdropUrlMeta,
        ),
      );
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('external_url')) {
      context.handle(
        _externalUrlMeta,
        externalUrl.isAcceptableOrUnknown(
          data['external_url']!,
          _externalUrlMeta,
        ),
      );
    }
    if (data.containsKey('reminder_at')) {
      context.handle(
        _reminderAtMeta,
        reminderAt.isAcceptableOrUnknown(data['reminder_at']!, _reminderAtMeta),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('runtime_minutes')) {
      context.handle(
        _runtimeMinutesMeta,
        runtimeMinutes.isAcceptableOrUnknown(
          data['runtime_minutes']!,
          _runtimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('release_year')) {
      context.handle(
        _releaseYearMeta,
        releaseYear.isAcceptableOrUnknown(
          data['release_year']!,
          _releaseYearMeta,
        ),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('total_seasons')) {
      context.handle(
        _totalSeasonsMeta,
        totalSeasons.isAcceptableOrUnknown(
          data['total_seasons']!,
          _totalSeasonsMeta,
        ),
      );
    }
    if (data.containsKey('current_season')) {
      context.handle(
        _currentSeasonMeta,
        currentSeason.isAcceptableOrUnknown(
          data['current_season']!,
          _currentSeasonMeta,
        ),
      );
    }
    if (data.containsKey('current_episode')) {
      context.handle(
        _currentEpisodeMeta,
        currentEpisode.isAcceptableOrUnknown(
          data['current_episode']!,
          _currentEpisodeMeta,
        ),
      );
    }
    if (data.containsKey('total_episodes')) {
      context.handle(
        _totalEpisodesMeta,
        totalEpisodes.isAcceptableOrUnknown(
          data['total_episodes']!,
          _totalEpisodesMeta,
        ),
      );
    }
    if (data.containsKey('total_episodes_anime')) {
      context.handle(
        _totalEpisodesAnimeMeta,
        totalEpisodesAnime.isAcceptableOrUnknown(
          data['total_episodes_anime']!,
          _totalEpisodesAnimeMeta,
        ),
      );
    }
    if (data.containsKey('current_episode_anime')) {
      context.handle(
        _currentEpisodeAnimeMeta,
        currentEpisodeAnime.isAcceptableOrUnknown(
          data['current_episode_anime']!,
          _currentEpisodeAnimeMeta,
        ),
      );
    }
    if (data.containsKey('airing_status')) {
      context.handle(
        _airingStatusMeta,
        airingStatus.isAcceptableOrUnknown(
          data['airing_status']!,
          _airingStatusMeta,
        ),
      );
    }
    if (data.containsKey('anime_format')) {
      context.handle(
        _animeFormatMeta,
        animeFormat.isAcceptableOrUnknown(
          data['anime_format']!,
          _animeFormatMeta,
        ),
      );
    }
    if (data.containsKey('anilist_id')) {
      context.handle(
        _anilistIdMeta,
        anilistId.isAcceptableOrUnknown(data['anilist_id']!, _anilistIdMeta),
      );
    }
    if (data.containsKey('next_airing_episode')) {
      context.handle(
        _nextAiringEpisodeMeta,
        nextAiringEpisode.isAcceptableOrUnknown(
          data['next_airing_episode']!,
          _nextAiringEpisodeMeta,
        ),
      );
    }
    if (data.containsKey('next_airing_at')) {
      context.handle(
        _nextAiringAtMeta,
        nextAiringAt.isAcceptableOrUnknown(
          data['next_airing_at']!,
          _nextAiringAtMeta,
        ),
      );
    }
    if (data.containsKey('completion_percent')) {
      context.handle(
        _completionPercentMeta,
        completionPercent.isAcceptableOrUnknown(
          data['completion_percent']!,
          _completionPercentMeta,
        ),
      );
    }
    if (data.containsKey('metacritic_score')) {
      context.handle(
        _metacriticScoreMeta,
        metacriticScore.isAcceptableOrUnknown(
          data['metacritic_score']!,
          _metacriticScoreMeta,
        ),
      );
    }
    if (data.containsKey('estimated_playtime_hours')) {
      context.handle(
        _estimatedPlaytimeHoursMeta,
        estimatedPlaytimeHours.isAcceptableOrUnknown(
          data['estimated_playtime_hours']!,
          _estimatedPlaytimeHoursMeta,
        ),
      );
    }
    if (data.containsKey('hours_played')) {
      context.handle(
        _hoursPlayedMeta,
        hoursPlayed.isAcceptableOrUnknown(
          data['hours_played']!,
          _hoursPlayedMeta,
        ),
      );
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    }
    if (data.containsKey('target_price')) {
      context.handle(
        _targetPriceMeta,
        targetPrice.isAcceptableOrUnknown(
          data['target_price']!,
          _targetPriceMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('store_url')) {
      context.handle(
        _storeUrlMeta,
        storeUrl.isAcceptableOrUnknown(data['store_url']!, _storeUrlMeta),
      );
    }
    if (data.containsKey('purchased')) {
      context.handle(
        _purchasedMeta,
        purchased.isAcceptableOrUnknown(data['purchased']!, _purchasedMeta),
      );
    }
    if (data.containsKey('product_category')) {
      context.handle(
        _productCategoryMeta,
        productCategory.isAcceptableOrUnknown(
          data['product_category']!,
          _productCategoryMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('user_rating')) {
      context.handle(
        _userRatingMeta,
        userRating.isAcceptableOrUnknown(data['user_rating']!, _userRatingMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('use_local_image')) {
      context.handle(
        _useLocalImageMeta,
        useLocalImage.isAcceptableOrUnknown(
          data['use_local_image']!,
          _useLocalImageMeta,
        ),
      );
    }
    if (data.containsKey('local_image_path')) {
      context.handle(
        _localImagePathMeta,
        localImagePath.isAcceptableOrUnknown(
          data['local_image_path']!,
          _localImagePathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaultItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaultItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_url'],
      ),
      backdropUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backdrop_url'],
      ),
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      ),
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      externalUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_url'],
      ),
      reminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_at'],
      ),
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      runtimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}runtime_minutes'],
      ),
      releaseYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}release_year'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      ),
      totalSeasons: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_seasons'],
      ),
      currentSeason: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_season'],
      ),
      currentEpisode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_episode'],
      ),
      totalEpisodes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_episodes'],
      ),
      totalEpisodesAnime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_episodes_anime'],
      ),
      currentEpisodeAnime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_episode_anime'],
      ),
      airingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}airing_status'],
      ),
      animeFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anime_format'],
      ),
      anilistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anilist_id'],
      ),
      nextAiringEpisode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_airing_episode'],
      ),
      nextAiringAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_airing_at'],
      ),
      completionPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completion_percent'],
      ),
      metacriticScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}metacritic_score'],
      ),
      estimatedPlaytimeHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_playtime_hours'],
      ),
      hoursPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hours_played'],
      ),
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      ),
      targetPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_price'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      ),
      storeUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_url'],
      ),
      purchased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}purchased'],
      )!,
      productCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_category'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      userRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_rating'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      useLocalImage: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}use_local_image'],
      )!,
      localImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_image_path'],
      ),
    );
  }

  @override
  $VaultItemsTable createAlias(String alias) {
    return $VaultItemsTable(attachedDatabase, alias);
  }
}

class VaultItem extends DataClass implements Insertable<VaultItem> {
  final int id;
  final String itemType;
  final String status;
  final String title;
  final String? posterUrl;
  final String? backdropUrl;
  final String? overview;
  final String? externalId;
  final String? externalUrl;
  final DateTime? reminderAt;
  final bool reminderEnabled;
  final DateTime addedAt;
  final DateTime? updatedAt;
  final int? runtimeMinutes;
  final int? releaseYear;
  final String? genre;
  final int? totalSeasons;
  final int? currentSeason;
  final int? currentEpisode;
  final int? totalEpisodes;
  final int? totalEpisodesAnime;
  final int? currentEpisodeAnime;
  final String? airingStatus;
  final String? animeFormat;
  final int? anilistId;
  final int? nextAiringEpisode;
  final DateTime? nextAiringAt;
  final int? completionPercent;
  final int? metacriticScore;
  final int? estimatedPlaytimeHours;
  final int? hoursPlayed;
  final String? platform;
  final double? targetPrice;
  final String? currency;
  final String? storeUrl;
  final bool purchased;
  final String? productCategory;
  final String tags;
  final int? userRating;
  final String? notes;
  final bool useLocalImage;
  final String? localImagePath;
  const VaultItem({
    required this.id,
    required this.itemType,
    required this.status,
    required this.title,
    this.posterUrl,
    this.backdropUrl,
    this.overview,
    this.externalId,
    this.externalUrl,
    this.reminderAt,
    required this.reminderEnabled,
    required this.addedAt,
    this.updatedAt,
    this.runtimeMinutes,
    this.releaseYear,
    this.genre,
    this.totalSeasons,
    this.currentSeason,
    this.currentEpisode,
    this.totalEpisodes,
    this.totalEpisodesAnime,
    this.currentEpisodeAnime,
    this.airingStatus,
    this.animeFormat,
    this.anilistId,
    this.nextAiringEpisode,
    this.nextAiringAt,
    this.completionPercent,
    this.metacriticScore,
    this.estimatedPlaytimeHours,
    this.hoursPlayed,
    this.platform,
    this.targetPrice,
    this.currency,
    this.storeUrl,
    required this.purchased,
    this.productCategory,
    required this.tags,
    this.userRating,
    this.notes,
    required this.useLocalImage,
    this.localImagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_type'] = Variable<String>(itemType);
    map['status'] = Variable<String>(status);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterUrl != null) {
      map['poster_url'] = Variable<String>(posterUrl);
    }
    if (!nullToAbsent || backdropUrl != null) {
      map['backdrop_url'] = Variable<String>(backdropUrl);
    }
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    if (!nullToAbsent || externalUrl != null) {
      map['external_url'] = Variable<String>(externalUrl);
    }
    if (!nullToAbsent || reminderAt != null) {
      map['reminder_at'] = Variable<DateTime>(reminderAt);
    }
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || runtimeMinutes != null) {
      map['runtime_minutes'] = Variable<int>(runtimeMinutes);
    }
    if (!nullToAbsent || releaseYear != null) {
      map['release_year'] = Variable<int>(releaseYear);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || totalSeasons != null) {
      map['total_seasons'] = Variable<int>(totalSeasons);
    }
    if (!nullToAbsent || currentSeason != null) {
      map['current_season'] = Variable<int>(currentSeason);
    }
    if (!nullToAbsent || currentEpisode != null) {
      map['current_episode'] = Variable<int>(currentEpisode);
    }
    if (!nullToAbsent || totalEpisodes != null) {
      map['total_episodes'] = Variable<int>(totalEpisodes);
    }
    if (!nullToAbsent || totalEpisodesAnime != null) {
      map['total_episodes_anime'] = Variable<int>(totalEpisodesAnime);
    }
    if (!nullToAbsent || currentEpisodeAnime != null) {
      map['current_episode_anime'] = Variable<int>(currentEpisodeAnime);
    }
    if (!nullToAbsent || airingStatus != null) {
      map['airing_status'] = Variable<String>(airingStatus);
    }
    if (!nullToAbsent || animeFormat != null) {
      map['anime_format'] = Variable<String>(animeFormat);
    }
    if (!nullToAbsent || anilistId != null) {
      map['anilist_id'] = Variable<int>(anilistId);
    }
    if (!nullToAbsent || nextAiringEpisode != null) {
      map['next_airing_episode'] = Variable<int>(nextAiringEpisode);
    }
    if (!nullToAbsent || nextAiringAt != null) {
      map['next_airing_at'] = Variable<DateTime>(nextAiringAt);
    }
    if (!nullToAbsent || completionPercent != null) {
      map['completion_percent'] = Variable<int>(completionPercent);
    }
    if (!nullToAbsent || metacriticScore != null) {
      map['metacritic_score'] = Variable<int>(metacriticScore);
    }
    if (!nullToAbsent || estimatedPlaytimeHours != null) {
      map['estimated_playtime_hours'] = Variable<int>(estimatedPlaytimeHours);
    }
    if (!nullToAbsent || hoursPlayed != null) {
      map['hours_played'] = Variable<int>(hoursPlayed);
    }
    if (!nullToAbsent || platform != null) {
      map['platform'] = Variable<String>(platform);
    }
    if (!nullToAbsent || targetPrice != null) {
      map['target_price'] = Variable<double>(targetPrice);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || storeUrl != null) {
      map['store_url'] = Variable<String>(storeUrl);
    }
    map['purchased'] = Variable<bool>(purchased);
    if (!nullToAbsent || productCategory != null) {
      map['product_category'] = Variable<String>(productCategory);
    }
    map['tags'] = Variable<String>(tags);
    if (!nullToAbsent || userRating != null) {
      map['user_rating'] = Variable<int>(userRating);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['use_local_image'] = Variable<bool>(useLocalImage);
    if (!nullToAbsent || localImagePath != null) {
      map['local_image_path'] = Variable<String>(localImagePath);
    }
    return map;
  }

  VaultItemsCompanion toCompanion(bool nullToAbsent) {
    return VaultItemsCompanion(
      id: Value(id),
      itemType: Value(itemType),
      status: Value(status),
      title: Value(title),
      posterUrl: posterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(posterUrl),
      backdropUrl: backdropUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropUrl),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      externalUrl: externalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(externalUrl),
      reminderAt: reminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderAt),
      reminderEnabled: Value(reminderEnabled),
      addedAt: Value(addedAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      runtimeMinutes: runtimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(runtimeMinutes),
      releaseYear: releaseYear == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseYear),
      genre: genre == null && nullToAbsent
          ? const Value.absent()
          : Value(genre),
      totalSeasons: totalSeasons == null && nullToAbsent
          ? const Value.absent()
          : Value(totalSeasons),
      currentSeason: currentSeason == null && nullToAbsent
          ? const Value.absent()
          : Value(currentSeason),
      currentEpisode: currentEpisode == null && nullToAbsent
          ? const Value.absent()
          : Value(currentEpisode),
      totalEpisodes: totalEpisodes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalEpisodes),
      totalEpisodesAnime: totalEpisodesAnime == null && nullToAbsent
          ? const Value.absent()
          : Value(totalEpisodesAnime),
      currentEpisodeAnime: currentEpisodeAnime == null && nullToAbsent
          ? const Value.absent()
          : Value(currentEpisodeAnime),
      airingStatus: airingStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(airingStatus),
      animeFormat: animeFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(animeFormat),
      anilistId: anilistId == null && nullToAbsent
          ? const Value.absent()
          : Value(anilistId),
      nextAiringEpisode: nextAiringEpisode == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAiringEpisode),
      nextAiringAt: nextAiringAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAiringAt),
      completionPercent: completionPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(completionPercent),
      metacriticScore: metacriticScore == null && nullToAbsent
          ? const Value.absent()
          : Value(metacriticScore),
      estimatedPlaytimeHours: estimatedPlaytimeHours == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedPlaytimeHours),
      hoursPlayed: hoursPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(hoursPlayed),
      platform: platform == null && nullToAbsent
          ? const Value.absent()
          : Value(platform),
      targetPrice: targetPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(targetPrice),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      storeUrl: storeUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(storeUrl),
      purchased: Value(purchased),
      productCategory: productCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(productCategory),
      tags: Value(tags),
      userRating: userRating == null && nullToAbsent
          ? const Value.absent()
          : Value(userRating),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      useLocalImage: Value(useLocalImage),
      localImagePath: localImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(localImagePath),
    );
  }

  factory VaultItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaultItem(
      id: serializer.fromJson<int>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      status: serializer.fromJson<String>(json['status']),
      title: serializer.fromJson<String>(json['title']),
      posterUrl: serializer.fromJson<String?>(json['posterUrl']),
      backdropUrl: serializer.fromJson<String?>(json['backdropUrl']),
      overview: serializer.fromJson<String?>(json['overview']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      externalUrl: serializer.fromJson<String?>(json['externalUrl']),
      reminderAt: serializer.fromJson<DateTime?>(json['reminderAt']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      runtimeMinutes: serializer.fromJson<int?>(json['runtimeMinutes']),
      releaseYear: serializer.fromJson<int?>(json['releaseYear']),
      genre: serializer.fromJson<String?>(json['genre']),
      totalSeasons: serializer.fromJson<int?>(json['totalSeasons']),
      currentSeason: serializer.fromJson<int?>(json['currentSeason']),
      currentEpisode: serializer.fromJson<int?>(json['currentEpisode']),
      totalEpisodes: serializer.fromJson<int?>(json['totalEpisodes']),
      totalEpisodesAnime: serializer.fromJson<int?>(json['totalEpisodesAnime']),
      currentEpisodeAnime: serializer.fromJson<int?>(
        json['currentEpisodeAnime'],
      ),
      airingStatus: serializer.fromJson<String?>(json['airingStatus']),
      animeFormat: serializer.fromJson<String?>(json['animeFormat']),
      anilistId: serializer.fromJson<int?>(json['anilistId']),
      nextAiringEpisode: serializer.fromJson<int?>(json['nextAiringEpisode']),
      nextAiringAt: serializer.fromJson<DateTime?>(json['nextAiringAt']),
      completionPercent: serializer.fromJson<int?>(json['completionPercent']),
      metacriticScore: serializer.fromJson<int?>(json['metacriticScore']),
      estimatedPlaytimeHours: serializer.fromJson<int?>(
        json['estimatedPlaytimeHours'],
      ),
      hoursPlayed: serializer.fromJson<int?>(json['hoursPlayed']),
      platform: serializer.fromJson<String?>(json['platform']),
      targetPrice: serializer.fromJson<double?>(json['targetPrice']),
      currency: serializer.fromJson<String?>(json['currency']),
      storeUrl: serializer.fromJson<String?>(json['storeUrl']),
      purchased: serializer.fromJson<bool>(json['purchased']),
      productCategory: serializer.fromJson<String?>(json['productCategory']),
      tags: serializer.fromJson<String>(json['tags']),
      userRating: serializer.fromJson<int?>(json['userRating']),
      notes: serializer.fromJson<String?>(json['notes']),
      useLocalImage: serializer.fromJson<bool>(json['useLocalImage']),
      localImagePath: serializer.fromJson<String?>(json['localImagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemType': serializer.toJson<String>(itemType),
      'status': serializer.toJson<String>(status),
      'title': serializer.toJson<String>(title),
      'posterUrl': serializer.toJson<String?>(posterUrl),
      'backdropUrl': serializer.toJson<String?>(backdropUrl),
      'overview': serializer.toJson<String?>(overview),
      'externalId': serializer.toJson<String?>(externalId),
      'externalUrl': serializer.toJson<String?>(externalUrl),
      'reminderAt': serializer.toJson<DateTime?>(reminderAt),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'runtimeMinutes': serializer.toJson<int?>(runtimeMinutes),
      'releaseYear': serializer.toJson<int?>(releaseYear),
      'genre': serializer.toJson<String?>(genre),
      'totalSeasons': serializer.toJson<int?>(totalSeasons),
      'currentSeason': serializer.toJson<int?>(currentSeason),
      'currentEpisode': serializer.toJson<int?>(currentEpisode),
      'totalEpisodes': serializer.toJson<int?>(totalEpisodes),
      'totalEpisodesAnime': serializer.toJson<int?>(totalEpisodesAnime),
      'currentEpisodeAnime': serializer.toJson<int?>(currentEpisodeAnime),
      'airingStatus': serializer.toJson<String?>(airingStatus),
      'animeFormat': serializer.toJson<String?>(animeFormat),
      'anilistId': serializer.toJson<int?>(anilistId),
      'nextAiringEpisode': serializer.toJson<int?>(nextAiringEpisode),
      'nextAiringAt': serializer.toJson<DateTime?>(nextAiringAt),
      'completionPercent': serializer.toJson<int?>(completionPercent),
      'metacriticScore': serializer.toJson<int?>(metacriticScore),
      'estimatedPlaytimeHours': serializer.toJson<int?>(estimatedPlaytimeHours),
      'hoursPlayed': serializer.toJson<int?>(hoursPlayed),
      'platform': serializer.toJson<String?>(platform),
      'targetPrice': serializer.toJson<double?>(targetPrice),
      'currency': serializer.toJson<String?>(currency),
      'storeUrl': serializer.toJson<String?>(storeUrl),
      'purchased': serializer.toJson<bool>(purchased),
      'productCategory': serializer.toJson<String?>(productCategory),
      'tags': serializer.toJson<String>(tags),
      'userRating': serializer.toJson<int?>(userRating),
      'notes': serializer.toJson<String?>(notes),
      'useLocalImage': serializer.toJson<bool>(useLocalImage),
      'localImagePath': serializer.toJson<String?>(localImagePath),
    };
  }

  VaultItem copyWith({
    int? id,
    String? itemType,
    String? status,
    String? title,
    Value<String?> posterUrl = const Value.absent(),
    Value<String?> backdropUrl = const Value.absent(),
    Value<String?> overview = const Value.absent(),
    Value<String?> externalId = const Value.absent(),
    Value<String?> externalUrl = const Value.absent(),
    Value<DateTime?> reminderAt = const Value.absent(),
    bool? reminderEnabled,
    DateTime? addedAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<int?> runtimeMinutes = const Value.absent(),
    Value<int?> releaseYear = const Value.absent(),
    Value<String?> genre = const Value.absent(),
    Value<int?> totalSeasons = const Value.absent(),
    Value<int?> currentSeason = const Value.absent(),
    Value<int?> currentEpisode = const Value.absent(),
    Value<int?> totalEpisodes = const Value.absent(),
    Value<int?> totalEpisodesAnime = const Value.absent(),
    Value<int?> currentEpisodeAnime = const Value.absent(),
    Value<String?> airingStatus = const Value.absent(),
    Value<String?> animeFormat = const Value.absent(),
    Value<int?> anilistId = const Value.absent(),
    Value<int?> nextAiringEpisode = const Value.absent(),
    Value<DateTime?> nextAiringAt = const Value.absent(),
    Value<int?> completionPercent = const Value.absent(),
    Value<int?> metacriticScore = const Value.absent(),
    Value<int?> estimatedPlaytimeHours = const Value.absent(),
    Value<int?> hoursPlayed = const Value.absent(),
    Value<String?> platform = const Value.absent(),
    Value<double?> targetPrice = const Value.absent(),
    Value<String?> currency = const Value.absent(),
    Value<String?> storeUrl = const Value.absent(),
    bool? purchased,
    Value<String?> productCategory = const Value.absent(),
    String? tags,
    Value<int?> userRating = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? useLocalImage,
    Value<String?> localImagePath = const Value.absent(),
  }) => VaultItem(
    id: id ?? this.id,
    itemType: itemType ?? this.itemType,
    status: status ?? this.status,
    title: title ?? this.title,
    posterUrl: posterUrl.present ? posterUrl.value : this.posterUrl,
    backdropUrl: backdropUrl.present ? backdropUrl.value : this.backdropUrl,
    overview: overview.present ? overview.value : this.overview,
    externalId: externalId.present ? externalId.value : this.externalId,
    externalUrl: externalUrl.present ? externalUrl.value : this.externalUrl,
    reminderAt: reminderAt.present ? reminderAt.value : this.reminderAt,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    addedAt: addedAt ?? this.addedAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    runtimeMinutes: runtimeMinutes.present
        ? runtimeMinutes.value
        : this.runtimeMinutes,
    releaseYear: releaseYear.present ? releaseYear.value : this.releaseYear,
    genre: genre.present ? genre.value : this.genre,
    totalSeasons: totalSeasons.present ? totalSeasons.value : this.totalSeasons,
    currentSeason: currentSeason.present
        ? currentSeason.value
        : this.currentSeason,
    currentEpisode: currentEpisode.present
        ? currentEpisode.value
        : this.currentEpisode,
    totalEpisodes: totalEpisodes.present
        ? totalEpisodes.value
        : this.totalEpisodes,
    totalEpisodesAnime: totalEpisodesAnime.present
        ? totalEpisodesAnime.value
        : this.totalEpisodesAnime,
    currentEpisodeAnime: currentEpisodeAnime.present
        ? currentEpisodeAnime.value
        : this.currentEpisodeAnime,
    airingStatus: airingStatus.present ? airingStatus.value : this.airingStatus,
    animeFormat: animeFormat.present ? animeFormat.value : this.animeFormat,
    anilistId: anilistId.present ? anilistId.value : this.anilistId,
    nextAiringEpisode: nextAiringEpisode.present
        ? nextAiringEpisode.value
        : this.nextAiringEpisode,
    nextAiringAt: nextAiringAt.present ? nextAiringAt.value : this.nextAiringAt,
    completionPercent: completionPercent.present
        ? completionPercent.value
        : this.completionPercent,
    metacriticScore: metacriticScore.present
        ? metacriticScore.value
        : this.metacriticScore,
    estimatedPlaytimeHours: estimatedPlaytimeHours.present
        ? estimatedPlaytimeHours.value
        : this.estimatedPlaytimeHours,
    hoursPlayed: hoursPlayed.present ? hoursPlayed.value : this.hoursPlayed,
    platform: platform.present ? platform.value : this.platform,
    targetPrice: targetPrice.present ? targetPrice.value : this.targetPrice,
    currency: currency.present ? currency.value : this.currency,
    storeUrl: storeUrl.present ? storeUrl.value : this.storeUrl,
    purchased: purchased ?? this.purchased,
    productCategory: productCategory.present
        ? productCategory.value
        : this.productCategory,
    tags: tags ?? this.tags,
    userRating: userRating.present ? userRating.value : this.userRating,
    notes: notes.present ? notes.value : this.notes,
    useLocalImage: useLocalImage ?? this.useLocalImage,
    localImagePath: localImagePath.present
        ? localImagePath.value
        : this.localImagePath,
  );
  VaultItem copyWithCompanion(VaultItemsCompanion data) {
    return VaultItem(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      status: data.status.present ? data.status.value : this.status,
      title: data.title.present ? data.title.value : this.title,
      posterUrl: data.posterUrl.present ? data.posterUrl.value : this.posterUrl,
      backdropUrl: data.backdropUrl.present
          ? data.backdropUrl.value
          : this.backdropUrl,
      overview: data.overview.present ? data.overview.value : this.overview,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      externalUrl: data.externalUrl.present
          ? data.externalUrl.value
          : this.externalUrl,
      reminderAt: data.reminderAt.present
          ? data.reminderAt.value
          : this.reminderAt,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      runtimeMinutes: data.runtimeMinutes.present
          ? data.runtimeMinutes.value
          : this.runtimeMinutes,
      releaseYear: data.releaseYear.present
          ? data.releaseYear.value
          : this.releaseYear,
      genre: data.genre.present ? data.genre.value : this.genre,
      totalSeasons: data.totalSeasons.present
          ? data.totalSeasons.value
          : this.totalSeasons,
      currentSeason: data.currentSeason.present
          ? data.currentSeason.value
          : this.currentSeason,
      currentEpisode: data.currentEpisode.present
          ? data.currentEpisode.value
          : this.currentEpisode,
      totalEpisodes: data.totalEpisodes.present
          ? data.totalEpisodes.value
          : this.totalEpisodes,
      totalEpisodesAnime: data.totalEpisodesAnime.present
          ? data.totalEpisodesAnime.value
          : this.totalEpisodesAnime,
      currentEpisodeAnime: data.currentEpisodeAnime.present
          ? data.currentEpisodeAnime.value
          : this.currentEpisodeAnime,
      airingStatus: data.airingStatus.present
          ? data.airingStatus.value
          : this.airingStatus,
      animeFormat: data.animeFormat.present
          ? data.animeFormat.value
          : this.animeFormat,
      anilistId: data.anilistId.present ? data.anilistId.value : this.anilistId,
      nextAiringEpisode: data.nextAiringEpisode.present
          ? data.nextAiringEpisode.value
          : this.nextAiringEpisode,
      nextAiringAt: data.nextAiringAt.present
          ? data.nextAiringAt.value
          : this.nextAiringAt,
      completionPercent: data.completionPercent.present
          ? data.completionPercent.value
          : this.completionPercent,
      metacriticScore: data.metacriticScore.present
          ? data.metacriticScore.value
          : this.metacriticScore,
      estimatedPlaytimeHours: data.estimatedPlaytimeHours.present
          ? data.estimatedPlaytimeHours.value
          : this.estimatedPlaytimeHours,
      hoursPlayed: data.hoursPlayed.present
          ? data.hoursPlayed.value
          : this.hoursPlayed,
      platform: data.platform.present ? data.platform.value : this.platform,
      targetPrice: data.targetPrice.present
          ? data.targetPrice.value
          : this.targetPrice,
      currency: data.currency.present ? data.currency.value : this.currency,
      storeUrl: data.storeUrl.present ? data.storeUrl.value : this.storeUrl,
      purchased: data.purchased.present ? data.purchased.value : this.purchased,
      productCategory: data.productCategory.present
          ? data.productCategory.value
          : this.productCategory,
      tags: data.tags.present ? data.tags.value : this.tags,
      userRating: data.userRating.present
          ? data.userRating.value
          : this.userRating,
      notes: data.notes.present ? data.notes.value : this.notes,
      useLocalImage: data.useLocalImage.present
          ? data.useLocalImage.value
          : this.useLocalImage,
      localImagePath: data.localImagePath.present
          ? data.localImagePath.value
          : this.localImagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaultItem(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('backdropUrl: $backdropUrl, ')
          ..write('overview: $overview, ')
          ..write('externalId: $externalId, ')
          ..write('externalUrl: $externalUrl, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('runtimeMinutes: $runtimeMinutes, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('genre: $genre, ')
          ..write('totalSeasons: $totalSeasons, ')
          ..write('currentSeason: $currentSeason, ')
          ..write('currentEpisode: $currentEpisode, ')
          ..write('totalEpisodes: $totalEpisodes, ')
          ..write('totalEpisodesAnime: $totalEpisodesAnime, ')
          ..write('currentEpisodeAnime: $currentEpisodeAnime, ')
          ..write('airingStatus: $airingStatus, ')
          ..write('animeFormat: $animeFormat, ')
          ..write('anilistId: $anilistId, ')
          ..write('nextAiringEpisode: $nextAiringEpisode, ')
          ..write('nextAiringAt: $nextAiringAt, ')
          ..write('completionPercent: $completionPercent, ')
          ..write('metacriticScore: $metacriticScore, ')
          ..write('estimatedPlaytimeHours: $estimatedPlaytimeHours, ')
          ..write('hoursPlayed: $hoursPlayed, ')
          ..write('platform: $platform, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('currency: $currency, ')
          ..write('storeUrl: $storeUrl, ')
          ..write('purchased: $purchased, ')
          ..write('productCategory: $productCategory, ')
          ..write('tags: $tags, ')
          ..write('userRating: $userRating, ')
          ..write('notes: $notes, ')
          ..write('useLocalImage: $useLocalImage, ')
          ..write('localImagePath: $localImagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    itemType,
    status,
    title,
    posterUrl,
    backdropUrl,
    overview,
    externalId,
    externalUrl,
    reminderAt,
    reminderEnabled,
    addedAt,
    updatedAt,
    runtimeMinutes,
    releaseYear,
    genre,
    totalSeasons,
    currentSeason,
    currentEpisode,
    totalEpisodes,
    totalEpisodesAnime,
    currentEpisodeAnime,
    airingStatus,
    animeFormat,
    anilistId,
    nextAiringEpisode,
    nextAiringAt,
    completionPercent,
    metacriticScore,
    estimatedPlaytimeHours,
    hoursPlayed,
    platform,
    targetPrice,
    currency,
    storeUrl,
    purchased,
    productCategory,
    tags,
    userRating,
    notes,
    useLocalImage,
    localImagePath,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaultItem &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.status == this.status &&
          other.title == this.title &&
          other.posterUrl == this.posterUrl &&
          other.backdropUrl == this.backdropUrl &&
          other.overview == this.overview &&
          other.externalId == this.externalId &&
          other.externalUrl == this.externalUrl &&
          other.reminderAt == this.reminderAt &&
          other.reminderEnabled == this.reminderEnabled &&
          other.addedAt == this.addedAt &&
          other.updatedAt == this.updatedAt &&
          other.runtimeMinutes == this.runtimeMinutes &&
          other.releaseYear == this.releaseYear &&
          other.genre == this.genre &&
          other.totalSeasons == this.totalSeasons &&
          other.currentSeason == this.currentSeason &&
          other.currentEpisode == this.currentEpisode &&
          other.totalEpisodes == this.totalEpisodes &&
          other.totalEpisodesAnime == this.totalEpisodesAnime &&
          other.currentEpisodeAnime == this.currentEpisodeAnime &&
          other.airingStatus == this.airingStatus &&
          other.animeFormat == this.animeFormat &&
          other.anilistId == this.anilistId &&
          other.nextAiringEpisode == this.nextAiringEpisode &&
          other.nextAiringAt == this.nextAiringAt &&
          other.completionPercent == this.completionPercent &&
          other.metacriticScore == this.metacriticScore &&
          other.estimatedPlaytimeHours == this.estimatedPlaytimeHours &&
          other.hoursPlayed == this.hoursPlayed &&
          other.platform == this.platform &&
          other.targetPrice == this.targetPrice &&
          other.currency == this.currency &&
          other.storeUrl == this.storeUrl &&
          other.purchased == this.purchased &&
          other.productCategory == this.productCategory &&
          other.tags == this.tags &&
          other.userRating == this.userRating &&
          other.notes == this.notes &&
          other.useLocalImage == this.useLocalImage &&
          other.localImagePath == this.localImagePath);
}

class VaultItemsCompanion extends UpdateCompanion<VaultItem> {
  final Value<int> id;
  final Value<String> itemType;
  final Value<String> status;
  final Value<String> title;
  final Value<String?> posterUrl;
  final Value<String?> backdropUrl;
  final Value<String?> overview;
  final Value<String?> externalId;
  final Value<String?> externalUrl;
  final Value<DateTime?> reminderAt;
  final Value<bool> reminderEnabled;
  final Value<DateTime> addedAt;
  final Value<DateTime?> updatedAt;
  final Value<int?> runtimeMinutes;
  final Value<int?> releaseYear;
  final Value<String?> genre;
  final Value<int?> totalSeasons;
  final Value<int?> currentSeason;
  final Value<int?> currentEpisode;
  final Value<int?> totalEpisodes;
  final Value<int?> totalEpisodesAnime;
  final Value<int?> currentEpisodeAnime;
  final Value<String?> airingStatus;
  final Value<String?> animeFormat;
  final Value<int?> anilistId;
  final Value<int?> nextAiringEpisode;
  final Value<DateTime?> nextAiringAt;
  final Value<int?> completionPercent;
  final Value<int?> metacriticScore;
  final Value<int?> estimatedPlaytimeHours;
  final Value<int?> hoursPlayed;
  final Value<String?> platform;
  final Value<double?> targetPrice;
  final Value<String?> currency;
  final Value<String?> storeUrl;
  final Value<bool> purchased;
  final Value<String?> productCategory;
  final Value<String> tags;
  final Value<int?> userRating;
  final Value<String?> notes;
  final Value<bool> useLocalImage;
  final Value<String?> localImagePath;
  const VaultItemsCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.status = const Value.absent(),
    this.title = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.backdropUrl = const Value.absent(),
    this.overview = const Value.absent(),
    this.externalId = const Value.absent(),
    this.externalUrl = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.runtimeMinutes = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.genre = const Value.absent(),
    this.totalSeasons = const Value.absent(),
    this.currentSeason = const Value.absent(),
    this.currentEpisode = const Value.absent(),
    this.totalEpisodes = const Value.absent(),
    this.totalEpisodesAnime = const Value.absent(),
    this.currentEpisodeAnime = const Value.absent(),
    this.airingStatus = const Value.absent(),
    this.animeFormat = const Value.absent(),
    this.anilistId = const Value.absent(),
    this.nextAiringEpisode = const Value.absent(),
    this.nextAiringAt = const Value.absent(),
    this.completionPercent = const Value.absent(),
    this.metacriticScore = const Value.absent(),
    this.estimatedPlaytimeHours = const Value.absent(),
    this.hoursPlayed = const Value.absent(),
    this.platform = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.storeUrl = const Value.absent(),
    this.purchased = const Value.absent(),
    this.productCategory = const Value.absent(),
    this.tags = const Value.absent(),
    this.userRating = const Value.absent(),
    this.notes = const Value.absent(),
    this.useLocalImage = const Value.absent(),
    this.localImagePath = const Value.absent(),
  });
  VaultItemsCompanion.insert({
    this.id = const Value.absent(),
    required String itemType,
    this.status = const Value.absent(),
    required String title,
    this.posterUrl = const Value.absent(),
    this.backdropUrl = const Value.absent(),
    this.overview = const Value.absent(),
    this.externalId = const Value.absent(),
    this.externalUrl = const Value.absent(),
    this.reminderAt = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.runtimeMinutes = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.genre = const Value.absent(),
    this.totalSeasons = const Value.absent(),
    this.currentSeason = const Value.absent(),
    this.currentEpisode = const Value.absent(),
    this.totalEpisodes = const Value.absent(),
    this.totalEpisodesAnime = const Value.absent(),
    this.currentEpisodeAnime = const Value.absent(),
    this.airingStatus = const Value.absent(),
    this.animeFormat = const Value.absent(),
    this.anilistId = const Value.absent(),
    this.nextAiringEpisode = const Value.absent(),
    this.nextAiringAt = const Value.absent(),
    this.completionPercent = const Value.absent(),
    this.metacriticScore = const Value.absent(),
    this.estimatedPlaytimeHours = const Value.absent(),
    this.hoursPlayed = const Value.absent(),
    this.platform = const Value.absent(),
    this.targetPrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.storeUrl = const Value.absent(),
    this.purchased = const Value.absent(),
    this.productCategory = const Value.absent(),
    this.tags = const Value.absent(),
    this.userRating = const Value.absent(),
    this.notes = const Value.absent(),
    this.useLocalImage = const Value.absent(),
    this.localImagePath = const Value.absent(),
  }) : itemType = Value(itemType),
       title = Value(title);
  static Insertable<VaultItem> custom({
    Expression<int>? id,
    Expression<String>? itemType,
    Expression<String>? status,
    Expression<String>? title,
    Expression<String>? posterUrl,
    Expression<String>? backdropUrl,
    Expression<String>? overview,
    Expression<String>? externalId,
    Expression<String>? externalUrl,
    Expression<DateTime>? reminderAt,
    Expression<bool>? reminderEnabled,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? runtimeMinutes,
    Expression<int>? releaseYear,
    Expression<String>? genre,
    Expression<int>? totalSeasons,
    Expression<int>? currentSeason,
    Expression<int>? currentEpisode,
    Expression<int>? totalEpisodes,
    Expression<int>? totalEpisodesAnime,
    Expression<int>? currentEpisodeAnime,
    Expression<String>? airingStatus,
    Expression<String>? animeFormat,
    Expression<int>? anilistId,
    Expression<int>? nextAiringEpisode,
    Expression<DateTime>? nextAiringAt,
    Expression<int>? completionPercent,
    Expression<int>? metacriticScore,
    Expression<int>? estimatedPlaytimeHours,
    Expression<int>? hoursPlayed,
    Expression<String>? platform,
    Expression<double>? targetPrice,
    Expression<String>? currency,
    Expression<String>? storeUrl,
    Expression<bool>? purchased,
    Expression<String>? productCategory,
    Expression<String>? tags,
    Expression<int>? userRating,
    Expression<String>? notes,
    Expression<bool>? useLocalImage,
    Expression<String>? localImagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'item_type': itemType,
      if (status != null) 'status': status,
      if (title != null) 'title': title,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (backdropUrl != null) 'backdrop_url': backdropUrl,
      if (overview != null) 'overview': overview,
      if (externalId != null) 'external_id': externalId,
      if (externalUrl != null) 'external_url': externalUrl,
      if (reminderAt != null) 'reminder_at': reminderAt,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (addedAt != null) 'added_at': addedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (runtimeMinutes != null) 'runtime_minutes': runtimeMinutes,
      if (releaseYear != null) 'release_year': releaseYear,
      if (genre != null) 'genre': genre,
      if (totalSeasons != null) 'total_seasons': totalSeasons,
      if (currentSeason != null) 'current_season': currentSeason,
      if (currentEpisode != null) 'current_episode': currentEpisode,
      if (totalEpisodes != null) 'total_episodes': totalEpisodes,
      if (totalEpisodesAnime != null)
        'total_episodes_anime': totalEpisodesAnime,
      if (currentEpisodeAnime != null)
        'current_episode_anime': currentEpisodeAnime,
      if (airingStatus != null) 'airing_status': airingStatus,
      if (animeFormat != null) 'anime_format': animeFormat,
      if (anilistId != null) 'anilist_id': anilistId,
      if (nextAiringEpisode != null) 'next_airing_episode': nextAiringEpisode,
      if (nextAiringAt != null) 'next_airing_at': nextAiringAt,
      if (completionPercent != null) 'completion_percent': completionPercent,
      if (metacriticScore != null) 'metacritic_score': metacriticScore,
      if (estimatedPlaytimeHours != null)
        'estimated_playtime_hours': estimatedPlaytimeHours,
      if (hoursPlayed != null) 'hours_played': hoursPlayed,
      if (platform != null) 'platform': platform,
      if (targetPrice != null) 'target_price': targetPrice,
      if (currency != null) 'currency': currency,
      if (storeUrl != null) 'store_url': storeUrl,
      if (purchased != null) 'purchased': purchased,
      if (productCategory != null) 'product_category': productCategory,
      if (tags != null) 'tags': tags,
      if (userRating != null) 'user_rating': userRating,
      if (notes != null) 'notes': notes,
      if (useLocalImage != null) 'use_local_image': useLocalImage,
      if (localImagePath != null) 'local_image_path': localImagePath,
    });
  }

  VaultItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? itemType,
    Value<String>? status,
    Value<String>? title,
    Value<String?>? posterUrl,
    Value<String?>? backdropUrl,
    Value<String?>? overview,
    Value<String?>? externalId,
    Value<String?>? externalUrl,
    Value<DateTime?>? reminderAt,
    Value<bool>? reminderEnabled,
    Value<DateTime>? addedAt,
    Value<DateTime?>? updatedAt,
    Value<int?>? runtimeMinutes,
    Value<int?>? releaseYear,
    Value<String?>? genre,
    Value<int?>? totalSeasons,
    Value<int?>? currentSeason,
    Value<int?>? currentEpisode,
    Value<int?>? totalEpisodes,
    Value<int?>? totalEpisodesAnime,
    Value<int?>? currentEpisodeAnime,
    Value<String?>? airingStatus,
    Value<String?>? animeFormat,
    Value<int?>? anilistId,
    Value<int?>? nextAiringEpisode,
    Value<DateTime?>? nextAiringAt,
    Value<int?>? completionPercent,
    Value<int?>? metacriticScore,
    Value<int?>? estimatedPlaytimeHours,
    Value<int?>? hoursPlayed,
    Value<String?>? platform,
    Value<double?>? targetPrice,
    Value<String?>? currency,
    Value<String?>? storeUrl,
    Value<bool>? purchased,
    Value<String?>? productCategory,
    Value<String>? tags,
    Value<int?>? userRating,
    Value<String?>? notes,
    Value<bool>? useLocalImage,
    Value<String?>? localImagePath,
  }) {
    return VaultItemsCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      status: status ?? this.status,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      overview: overview ?? this.overview,
      externalId: externalId ?? this.externalId,
      externalUrl: externalUrl ?? this.externalUrl,
      reminderAt: reminderAt ?? this.reminderAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      runtimeMinutes: runtimeMinutes ?? this.runtimeMinutes,
      releaseYear: releaseYear ?? this.releaseYear,
      genre: genre ?? this.genre,
      totalSeasons: totalSeasons ?? this.totalSeasons,
      currentSeason: currentSeason ?? this.currentSeason,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      totalEpisodesAnime: totalEpisodesAnime ?? this.totalEpisodesAnime,
      currentEpisodeAnime: currentEpisodeAnime ?? this.currentEpisodeAnime,
      airingStatus: airingStatus ?? this.airingStatus,
      animeFormat: animeFormat ?? this.animeFormat,
      anilistId: anilistId ?? this.anilistId,
      nextAiringEpisode: nextAiringEpisode ?? this.nextAiringEpisode,
      nextAiringAt: nextAiringAt ?? this.nextAiringAt,
      completionPercent: completionPercent ?? this.completionPercent,
      metacriticScore: metacriticScore ?? this.metacriticScore,
      estimatedPlaytimeHours:
          estimatedPlaytimeHours ?? this.estimatedPlaytimeHours,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      platform: platform ?? this.platform,
      targetPrice: targetPrice ?? this.targetPrice,
      currency: currency ?? this.currency,
      storeUrl: storeUrl ?? this.storeUrl,
      purchased: purchased ?? this.purchased,
      productCategory: productCategory ?? this.productCategory,
      tags: tags ?? this.tags,
      userRating: userRating ?? this.userRating,
      notes: notes ?? this.notes,
      useLocalImage: useLocalImage ?? this.useLocalImage,
      localImagePath: localImagePath ?? this.localImagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterUrl.present) {
      map['poster_url'] = Variable<String>(posterUrl.value);
    }
    if (backdropUrl.present) {
      map['backdrop_url'] = Variable<String>(backdropUrl.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (externalUrl.present) {
      map['external_url'] = Variable<String>(externalUrl.value);
    }
    if (reminderAt.present) {
      map['reminder_at'] = Variable<DateTime>(reminderAt.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (runtimeMinutes.present) {
      map['runtime_minutes'] = Variable<int>(runtimeMinutes.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (totalSeasons.present) {
      map['total_seasons'] = Variable<int>(totalSeasons.value);
    }
    if (currentSeason.present) {
      map['current_season'] = Variable<int>(currentSeason.value);
    }
    if (currentEpisode.present) {
      map['current_episode'] = Variable<int>(currentEpisode.value);
    }
    if (totalEpisodes.present) {
      map['total_episodes'] = Variable<int>(totalEpisodes.value);
    }
    if (totalEpisodesAnime.present) {
      map['total_episodes_anime'] = Variable<int>(totalEpisodesAnime.value);
    }
    if (currentEpisodeAnime.present) {
      map['current_episode_anime'] = Variable<int>(currentEpisodeAnime.value);
    }
    if (airingStatus.present) {
      map['airing_status'] = Variable<String>(airingStatus.value);
    }
    if (animeFormat.present) {
      map['anime_format'] = Variable<String>(animeFormat.value);
    }
    if (anilistId.present) {
      map['anilist_id'] = Variable<int>(anilistId.value);
    }
    if (nextAiringEpisode.present) {
      map['next_airing_episode'] = Variable<int>(nextAiringEpisode.value);
    }
    if (nextAiringAt.present) {
      map['next_airing_at'] = Variable<DateTime>(nextAiringAt.value);
    }
    if (completionPercent.present) {
      map['completion_percent'] = Variable<int>(completionPercent.value);
    }
    if (metacriticScore.present) {
      map['metacritic_score'] = Variable<int>(metacriticScore.value);
    }
    if (estimatedPlaytimeHours.present) {
      map['estimated_playtime_hours'] = Variable<int>(
        estimatedPlaytimeHours.value,
      );
    }
    if (hoursPlayed.present) {
      map['hours_played'] = Variable<int>(hoursPlayed.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (targetPrice.present) {
      map['target_price'] = Variable<double>(targetPrice.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (storeUrl.present) {
      map['store_url'] = Variable<String>(storeUrl.value);
    }
    if (purchased.present) {
      map['purchased'] = Variable<bool>(purchased.value);
    }
    if (productCategory.present) {
      map['product_category'] = Variable<String>(productCategory.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (userRating.present) {
      map['user_rating'] = Variable<int>(userRating.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (useLocalImage.present) {
      map['use_local_image'] = Variable<bool>(useLocalImage.value);
    }
    if (localImagePath.present) {
      map['local_image_path'] = Variable<String>(localImagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultItemsCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('backdropUrl: $backdropUrl, ')
          ..write('overview: $overview, ')
          ..write('externalId: $externalId, ')
          ..write('externalUrl: $externalUrl, ')
          ..write('reminderAt: $reminderAt, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('runtimeMinutes: $runtimeMinutes, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('genre: $genre, ')
          ..write('totalSeasons: $totalSeasons, ')
          ..write('currentSeason: $currentSeason, ')
          ..write('currentEpisode: $currentEpisode, ')
          ..write('totalEpisodes: $totalEpisodes, ')
          ..write('totalEpisodesAnime: $totalEpisodesAnime, ')
          ..write('currentEpisodeAnime: $currentEpisodeAnime, ')
          ..write('airingStatus: $airingStatus, ')
          ..write('animeFormat: $animeFormat, ')
          ..write('anilistId: $anilistId, ')
          ..write('nextAiringEpisode: $nextAiringEpisode, ')
          ..write('nextAiringAt: $nextAiringAt, ')
          ..write('completionPercent: $completionPercent, ')
          ..write('metacriticScore: $metacriticScore, ')
          ..write('estimatedPlaytimeHours: $estimatedPlaytimeHours, ')
          ..write('hoursPlayed: $hoursPlayed, ')
          ..write('platform: $platform, ')
          ..write('targetPrice: $targetPrice, ')
          ..write('currency: $currency, ')
          ..write('storeUrl: $storeUrl, ')
          ..write('purchased: $purchased, ')
          ..write('productCategory: $productCategory, ')
          ..write('tags: $tags, ')
          ..write('userRating: $userRating, ')
          ..write('notes: $notes, ')
          ..write('useLocalImage: $useLocalImage, ')
          ..write('localImagePath: $localImagePath')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeKeyMeta = const VerificationMeta(
    'typeKey',
  );
  @override
  late final GeneratedColumn<String> typeKey = GeneratedColumn<String>(
    'type_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    typeKey,
    name,
    iconName,
    colorHex,
    isDefault,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type_key')) {
      context.handle(
        _typeKeyMeta,
        typeKey.isAcceptableOrUnknown(data['type_key']!, _typeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_typeKeyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      typeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String typeKey;
  final String name;
  final String iconName;
  final String colorHex;
  final bool isDefault;
  final int sortOrder;
  const Category({
    required this.id,
    required this.typeKey,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.isDefault,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type_key'] = Variable<String>(typeKey);
    map['name'] = Variable<String>(name);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_default'] = Variable<bool>(isDefault);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      typeKey: Value(typeKey),
      name: Value(name),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      isDefault: Value(isDefault),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      typeKey: serializer.fromJson<String>(json['typeKey']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'typeKey': serializer.toJson<String>(typeKey),
      'name': serializer.toJson<String>(name),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'isDefault': serializer.toJson<bool>(isDefault),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    int? id,
    String? typeKey,
    String? name,
    String? iconName,
    String? colorHex,
    bool? isDefault,
    int? sortOrder,
  }) => Category(
    id: id ?? this.id,
    typeKey: typeKey ?? this.typeKey,
    name: name ?? this.name,
    iconName: iconName ?? this.iconName,
    colorHex: colorHex ?? this.colorHex,
    isDefault: isDefault ?? this.isDefault,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      typeKey: data.typeKey.present ? data.typeKey.value : this.typeKey,
      name: data.name.present ? data.name.value : this.name,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('typeKey: $typeKey, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, typeKey, name, iconName, colorHex, isDefault, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.typeKey == this.typeKey &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.isDefault == this.isDefault &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> typeKey;
  final Value<String> name;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<bool> isDefault;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.typeKey = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String typeKey,
    required String name,
    required String iconName,
    required String colorHex,
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : typeKey = Value(typeKey),
       name = Value(name),
       iconName = Value(iconName),
       colorHex = Value(colorHex);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? typeKey,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<bool>? isDefault,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (typeKey != null) 'type_key': typeKey,
      if (name != null) 'name': name,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (isDefault != null) 'is_default': isDefault,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? typeKey,
    Value<String>? name,
    Value<String>? iconName,
    Value<String>? colorHex,
    Value<bool>? isDefault,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      typeKey: typeKey ?? this.typeKey,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (typeKey.present) {
      map['type_key'] = Variable<String>(typeKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('typeKey: $typeKey, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VaultItemsTable vaultItems = $VaultItemsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vaultItems, categories];
}

typedef $$VaultItemsTableCreateCompanionBuilder =
    VaultItemsCompanion Function({
      Value<int> id,
      required String itemType,
      Value<String> status,
      required String title,
      Value<String?> posterUrl,
      Value<String?> backdropUrl,
      Value<String?> overview,
      Value<String?> externalId,
      Value<String?> externalUrl,
      Value<DateTime?> reminderAt,
      Value<bool> reminderEnabled,
      Value<DateTime> addedAt,
      Value<DateTime?> updatedAt,
      Value<int?> runtimeMinutes,
      Value<int?> releaseYear,
      Value<String?> genre,
      Value<int?> totalSeasons,
      Value<int?> currentSeason,
      Value<int?> currentEpisode,
      Value<int?> totalEpisodes,
      Value<int?> totalEpisodesAnime,
      Value<int?> currentEpisodeAnime,
      Value<String?> airingStatus,
      Value<String?> animeFormat,
      Value<int?> anilistId,
      Value<int?> nextAiringEpisode,
      Value<DateTime?> nextAiringAt,
      Value<int?> completionPercent,
      Value<int?> metacriticScore,
      Value<int?> estimatedPlaytimeHours,
      Value<int?> hoursPlayed,
      Value<String?> platform,
      Value<double?> targetPrice,
      Value<String?> currency,
      Value<String?> storeUrl,
      Value<bool> purchased,
      Value<String?> productCategory,
      Value<String> tags,
      Value<int?> userRating,
      Value<String?> notes,
      Value<bool> useLocalImage,
      Value<String?> localImagePath,
    });
typedef $$VaultItemsTableUpdateCompanionBuilder =
    VaultItemsCompanion Function({
      Value<int> id,
      Value<String> itemType,
      Value<String> status,
      Value<String> title,
      Value<String?> posterUrl,
      Value<String?> backdropUrl,
      Value<String?> overview,
      Value<String?> externalId,
      Value<String?> externalUrl,
      Value<DateTime?> reminderAt,
      Value<bool> reminderEnabled,
      Value<DateTime> addedAt,
      Value<DateTime?> updatedAt,
      Value<int?> runtimeMinutes,
      Value<int?> releaseYear,
      Value<String?> genre,
      Value<int?> totalSeasons,
      Value<int?> currentSeason,
      Value<int?> currentEpisode,
      Value<int?> totalEpisodes,
      Value<int?> totalEpisodesAnime,
      Value<int?> currentEpisodeAnime,
      Value<String?> airingStatus,
      Value<String?> animeFormat,
      Value<int?> anilistId,
      Value<int?> nextAiringEpisode,
      Value<DateTime?> nextAiringAt,
      Value<int?> completionPercent,
      Value<int?> metacriticScore,
      Value<int?> estimatedPlaytimeHours,
      Value<int?> hoursPlayed,
      Value<String?> platform,
      Value<double?> targetPrice,
      Value<String?> currency,
      Value<String?> storeUrl,
      Value<bool> purchased,
      Value<String?> productCategory,
      Value<String> tags,
      Value<int?> userRating,
      Value<String?> notes,
      Value<bool> useLocalImage,
      Value<String?> localImagePath,
    });

class $$VaultItemsTableFilterComposer
    extends Composer<_$AppDatabase, $VaultItemsTable> {
  $$VaultItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backdropUrl => $composableBuilder(
    column: $table.backdropUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalUrl => $composableBuilder(
    column: $table.externalUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get runtimeMinutes => $composableBuilder(
    column: $table.runtimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSeasons => $composableBuilder(
    column: $table.totalSeasons,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentSeason => $composableBuilder(
    column: $table.currentSeason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentEpisode => $composableBuilder(
    column: $table.currentEpisode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalEpisodesAnime => $composableBuilder(
    column: $table.totalEpisodesAnime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentEpisodeAnime => $composableBuilder(
    column: $table.currentEpisodeAnime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get airingStatus => $composableBuilder(
    column: $table.airingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animeFormat => $composableBuilder(
    column: $table.animeFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anilistId => $composableBuilder(
    column: $table.anilistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextAiringEpisode => $composableBuilder(
    column: $table.nextAiringEpisode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAiringAt => $composableBuilder(
    column: $table.nextAiringAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completionPercent => $composableBuilder(
    column: $table.completionPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get metacriticScore => $composableBuilder(
    column: $table.metacriticScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedPlaytimeHours => $composableBuilder(
    column: $table.estimatedPlaytimeHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hoursPlayed => $composableBuilder(
    column: $table.hoursPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeUrl => $composableBuilder(
    column: $table.storeUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get purchased => $composableBuilder(
    column: $table.purchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userRating => $composableBuilder(
    column: $table.userRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useLocalImage => $composableBuilder(
    column: $table.useLocalImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaultItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaultItemsTable> {
  $$VaultItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backdropUrl => $composableBuilder(
    column: $table.backdropUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalUrl => $composableBuilder(
    column: $table.externalUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get runtimeMinutes => $composableBuilder(
    column: $table.runtimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSeasons => $composableBuilder(
    column: $table.totalSeasons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentSeason => $composableBuilder(
    column: $table.currentSeason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentEpisode => $composableBuilder(
    column: $table.currentEpisode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalEpisodesAnime => $composableBuilder(
    column: $table.totalEpisodesAnime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentEpisodeAnime => $composableBuilder(
    column: $table.currentEpisodeAnime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get airingStatus => $composableBuilder(
    column: $table.airingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animeFormat => $composableBuilder(
    column: $table.animeFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anilistId => $composableBuilder(
    column: $table.anilistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextAiringEpisode => $composableBuilder(
    column: $table.nextAiringEpisode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAiringAt => $composableBuilder(
    column: $table.nextAiringAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completionPercent => $composableBuilder(
    column: $table.completionPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get metacriticScore => $composableBuilder(
    column: $table.metacriticScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedPlaytimeHours => $composableBuilder(
    column: $table.estimatedPlaytimeHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hoursPlayed => $composableBuilder(
    column: $table.hoursPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeUrl => $composableBuilder(
    column: $table.storeUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get purchased => $composableBuilder(
    column: $table.purchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userRating => $composableBuilder(
    column: $table.userRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useLocalImage => $composableBuilder(
    column: $table.useLocalImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaultItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaultItemsTable> {
  $$VaultItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterUrl =>
      $composableBuilder(column: $table.posterUrl, builder: (column) => column);

  GeneratedColumn<String> get backdropUrl => $composableBuilder(
    column: $table.backdropUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalUrl => $composableBuilder(
    column: $table.externalUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reminderAt => $composableBuilder(
    column: $table.reminderAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get runtimeMinutes => $composableBuilder(
    column: $table.runtimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<int> get totalSeasons => $composableBuilder(
    column: $table.totalSeasons,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentSeason => $composableBuilder(
    column: $table.currentSeason,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentEpisode => $composableBuilder(
    column: $table.currentEpisode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalEpisodes => $composableBuilder(
    column: $table.totalEpisodes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalEpisodesAnime => $composableBuilder(
    column: $table.totalEpisodesAnime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentEpisodeAnime => $composableBuilder(
    column: $table.currentEpisodeAnime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get airingStatus => $composableBuilder(
    column: $table.airingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get animeFormat => $composableBuilder(
    column: $table.animeFormat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get anilistId =>
      $composableBuilder(column: $table.anilistId, builder: (column) => column);

  GeneratedColumn<int> get nextAiringEpisode => $composableBuilder(
    column: $table.nextAiringEpisode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextAiringAt => $composableBuilder(
    column: $table.nextAiringAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completionPercent => $composableBuilder(
    column: $table.completionPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get metacriticScore => $composableBuilder(
    column: $table.metacriticScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedPlaytimeHours => $composableBuilder(
    column: $table.estimatedPlaytimeHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hoursPlayed => $composableBuilder(
    column: $table.hoursPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<double> get targetPrice => $composableBuilder(
    column: $table.targetPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get storeUrl =>
      $composableBuilder(column: $table.storeUrl, builder: (column) => column);

  GeneratedColumn<bool> get purchased =>
      $composableBuilder(column: $table.purchased, builder: (column) => column);

  GeneratedColumn<String> get productCategory => $composableBuilder(
    column: $table.productCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get userRating => $composableBuilder(
    column: $table.userRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get useLocalImage => $composableBuilder(
    column: $table.useLocalImage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localImagePath => $composableBuilder(
    column: $table.localImagePath,
    builder: (column) => column,
  );
}

class $$VaultItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaultItemsTable,
          VaultItem,
          $$VaultItemsTableFilterComposer,
          $$VaultItemsTableOrderingComposer,
          $$VaultItemsTableAnnotationComposer,
          $$VaultItemsTableCreateCompanionBuilder,
          $$VaultItemsTableUpdateCompanionBuilder,
          (
            VaultItem,
            BaseReferences<_$AppDatabase, $VaultItemsTable, VaultItem>,
          ),
          VaultItem,
          PrefetchHooks Function()
        > {
  $$VaultItemsTableTableManager(_$AppDatabase db, $VaultItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaultItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaultItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaultItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> posterUrl = const Value.absent(),
                Value<String?> backdropUrl = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String?> externalUrl = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int?> runtimeMinutes = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> totalSeasons = const Value.absent(),
                Value<int?> currentSeason = const Value.absent(),
                Value<int?> currentEpisode = const Value.absent(),
                Value<int?> totalEpisodes = const Value.absent(),
                Value<int?> totalEpisodesAnime = const Value.absent(),
                Value<int?> currentEpisodeAnime = const Value.absent(),
                Value<String?> airingStatus = const Value.absent(),
                Value<String?> animeFormat = const Value.absent(),
                Value<int?> anilistId = const Value.absent(),
                Value<int?> nextAiringEpisode = const Value.absent(),
                Value<DateTime?> nextAiringAt = const Value.absent(),
                Value<int?> completionPercent = const Value.absent(),
                Value<int?> metacriticScore = const Value.absent(),
                Value<int?> estimatedPlaytimeHours = const Value.absent(),
                Value<int?> hoursPlayed = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<double?> targetPrice = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> storeUrl = const Value.absent(),
                Value<bool> purchased = const Value.absent(),
                Value<String?> productCategory = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<int?> userRating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> useLocalImage = const Value.absent(),
                Value<String?> localImagePath = const Value.absent(),
              }) => VaultItemsCompanion(
                id: id,
                itemType: itemType,
                status: status,
                title: title,
                posterUrl: posterUrl,
                backdropUrl: backdropUrl,
                overview: overview,
                externalId: externalId,
                externalUrl: externalUrl,
                reminderAt: reminderAt,
                reminderEnabled: reminderEnabled,
                addedAt: addedAt,
                updatedAt: updatedAt,
                runtimeMinutes: runtimeMinutes,
                releaseYear: releaseYear,
                genre: genre,
                totalSeasons: totalSeasons,
                currentSeason: currentSeason,
                currentEpisode: currentEpisode,
                totalEpisodes: totalEpisodes,
                totalEpisodesAnime: totalEpisodesAnime,
                currentEpisodeAnime: currentEpisodeAnime,
                airingStatus: airingStatus,
                animeFormat: animeFormat,
                anilistId: anilistId,
                nextAiringEpisode: nextAiringEpisode,
                nextAiringAt: nextAiringAt,
                completionPercent: completionPercent,
                metacriticScore: metacriticScore,
                estimatedPlaytimeHours: estimatedPlaytimeHours,
                hoursPlayed: hoursPlayed,
                platform: platform,
                targetPrice: targetPrice,
                currency: currency,
                storeUrl: storeUrl,
                purchased: purchased,
                productCategory: productCategory,
                tags: tags,
                userRating: userRating,
                notes: notes,
                useLocalImage: useLocalImage,
                localImagePath: localImagePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String itemType,
                Value<String> status = const Value.absent(),
                required String title,
                Value<String?> posterUrl = const Value.absent(),
                Value<String?> backdropUrl = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String?> externalUrl = const Value.absent(),
                Value<DateTime?> reminderAt = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int?> runtimeMinutes = const Value.absent(),
                Value<int?> releaseYear = const Value.absent(),
                Value<String?> genre = const Value.absent(),
                Value<int?> totalSeasons = const Value.absent(),
                Value<int?> currentSeason = const Value.absent(),
                Value<int?> currentEpisode = const Value.absent(),
                Value<int?> totalEpisodes = const Value.absent(),
                Value<int?> totalEpisodesAnime = const Value.absent(),
                Value<int?> currentEpisodeAnime = const Value.absent(),
                Value<String?> airingStatus = const Value.absent(),
                Value<String?> animeFormat = const Value.absent(),
                Value<int?> anilistId = const Value.absent(),
                Value<int?> nextAiringEpisode = const Value.absent(),
                Value<DateTime?> nextAiringAt = const Value.absent(),
                Value<int?> completionPercent = const Value.absent(),
                Value<int?> metacriticScore = const Value.absent(),
                Value<int?> estimatedPlaytimeHours = const Value.absent(),
                Value<int?> hoursPlayed = const Value.absent(),
                Value<String?> platform = const Value.absent(),
                Value<double?> targetPrice = const Value.absent(),
                Value<String?> currency = const Value.absent(),
                Value<String?> storeUrl = const Value.absent(),
                Value<bool> purchased = const Value.absent(),
                Value<String?> productCategory = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<int?> userRating = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> useLocalImage = const Value.absent(),
                Value<String?> localImagePath = const Value.absent(),
              }) => VaultItemsCompanion.insert(
                id: id,
                itemType: itemType,
                status: status,
                title: title,
                posterUrl: posterUrl,
                backdropUrl: backdropUrl,
                overview: overview,
                externalId: externalId,
                externalUrl: externalUrl,
                reminderAt: reminderAt,
                reminderEnabled: reminderEnabled,
                addedAt: addedAt,
                updatedAt: updatedAt,
                runtimeMinutes: runtimeMinutes,
                releaseYear: releaseYear,
                genre: genre,
                totalSeasons: totalSeasons,
                currentSeason: currentSeason,
                currentEpisode: currentEpisode,
                totalEpisodes: totalEpisodes,
                totalEpisodesAnime: totalEpisodesAnime,
                currentEpisodeAnime: currentEpisodeAnime,
                airingStatus: airingStatus,
                animeFormat: animeFormat,
                anilistId: anilistId,
                nextAiringEpisode: nextAiringEpisode,
                nextAiringAt: nextAiringAt,
                completionPercent: completionPercent,
                metacriticScore: metacriticScore,
                estimatedPlaytimeHours: estimatedPlaytimeHours,
                hoursPlayed: hoursPlayed,
                platform: platform,
                targetPrice: targetPrice,
                currency: currency,
                storeUrl: storeUrl,
                purchased: purchased,
                productCategory: productCategory,
                tags: tags,
                userRating: userRating,
                notes: notes,
                useLocalImage: useLocalImage,
                localImagePath: localImagePath,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaultItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaultItemsTable,
      VaultItem,
      $$VaultItemsTableFilterComposer,
      $$VaultItemsTableOrderingComposer,
      $$VaultItemsTableAnnotationComposer,
      $$VaultItemsTableCreateCompanionBuilder,
      $$VaultItemsTableUpdateCompanionBuilder,
      (VaultItem, BaseReferences<_$AppDatabase, $VaultItemsTable, VaultItem>),
      VaultItem,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String typeKey,
      required String name,
      required String iconName,
      required String colorHex,
      Value<bool> isDefault,
      Value<int> sortOrder,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> typeKey,
      Value<String> name,
      Value<String> iconName,
      Value<String> colorHex,
      Value<bool> isDefault,
      Value<int> sortOrder,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeKey => $composableBuilder(
    column: $table.typeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeKey => $composableBuilder(
    column: $table.typeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get typeKey =>
      $composableBuilder(column: $table.typeKey, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> typeKey = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                typeKey: typeKey,
                name: name,
                iconName: iconName,
                colorHex: colorHex,
                isDefault: isDefault,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String typeKey,
                required String name,
                required String iconName,
                required String colorHex,
                Value<bool> isDefault = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                typeKey: typeKey,
                name: name,
                iconName: iconName,
                colorHex: colorHex,
                isDefault: isDefault,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VaultItemsTableTableManager get vaultItems =>
      $$VaultItemsTableTableManager(_db, _db.vaultItems);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
}
