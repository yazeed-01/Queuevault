import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import '../database/app_database.dart';

bool _hasValue(String? value) => value != null && value.isNotEmpty;

ImageProvider? itemPosterProvider(VaultItem item) {
  final localPath = item.localImagePath;
  final hasLocal = _hasValue(localPath);
  final hasPoster = _hasValue(item.posterUrl);

  if (item.useLocalImage && hasLocal) {
    return FileImage(File(localPath!));
  }
  if (hasPoster) {
    return CachedNetworkImageProvider(item.posterUrl!);
  }
  if (hasLocal) {
    return FileImage(File(localPath!));
  }
  return null;
}

ImageProvider? itemBackdropProvider(VaultItem item) {
  final localPath = item.localImagePath;
  final hasLocal = _hasValue(localPath);
  final hasBackdrop = _hasValue(item.backdropUrl);
  final hasPoster = _hasValue(item.posterUrl);

  if (item.useLocalImage && hasLocal) {
    return FileImage(File(localPath!));
  }
  if (hasBackdrop) {
    return CachedNetworkImageProvider(item.backdropUrl!);
  }
  if (hasPoster) {
    return CachedNetworkImageProvider(item.posterUrl!);
  }
  if (hasLocal) {
    return FileImage(File(localPath!));
  }
  return null;
}
