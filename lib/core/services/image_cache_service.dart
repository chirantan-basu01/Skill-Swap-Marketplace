import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Custom cache manager for app images
class AppImageCacheManager {
  static const String key = 'skillSwapImageCache';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      // Cache images for 7 days
      stalePeriod: const Duration(days: 7),
      // Maximum 200 files in cache
      maxNrOfCacheObjects: 200,
      // Download timeout
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  /// Clear all cached images
  static Future<void> clearCache() async {
    await instance.emptyCache();
  }

  /// Remove a specific URL from cache
  static Future<void> removeFromCache(String url) async {
    await instance.removeFile(url);
  }

  /// Get cache size info (for debug/settings)
  /// Note: Exact count not easily accessible, returns 0
  static Future<int> getCacheFileCount() async {
    // Cache file count not easily accessible via API
    return 0;
  }
}

/// Image size configurations for different contexts
class ImageSizeConfig {
  /// Avatar images - smaller for lists, larger for profile
  static const int avatarSmall = 80;
  static const int avatarMedium = 150;
  static const int avatarLarge = 300;

  /// Card images
  static const int cardThumbnail = 200;
  static const int cardFull = 400;

  /// Get appropriate cache dimension based on display size
  static int getCacheDimension(double displaySize) {
    if (displaySize <= 40) return avatarSmall;
    if (displaySize <= 80) return avatarMedium;
    return avatarLarge;
  }
}
