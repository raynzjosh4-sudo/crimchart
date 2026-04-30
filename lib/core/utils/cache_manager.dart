import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../db/chart_native_db.dart';

/// 🧹 CACHE MANAGER: The centralized control center for spring cleaning.
class CacheManager {
  CacheManager._();

  /// 🧺 CLEAR PHYSICAL CACHE: Deletes temporary files and clears RAM image cache.
  static Future<void> clearPhysicalCache() async {
    try {
      // 1. Clear the Temporary Directory (where videos and optimistics live)
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        // Recursive delete wipes everything inside
        tempDir.deleteSync(recursive: true);
        debugPrint('🧹 [CacheManager] Temporary directory wiped.');
      }

      // 2. Clear Flutter's internal Image Cache (RAM)
      // This forces the app to re-fetch images from R2 or Local docs on next rebuild.
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      debugPrint('🎨 [CacheManager] Image cache (RAM) cleared.');
    } catch (e) {
      debugPrint('⚠️ [CacheManager] Error during physical wipe: $e');
    }
  }

  /// 🧨 PERFORM FULL SYSTEM CLEAN: The "Nuke" button.
  /// Wipes all database tables AND deletes all cached media files.
  static Future<void> performFullSystemClean() async {
    debugPrint('🧨 [CacheManager] Starting Full System Clean...');

    // 1. Wipe the SQLite Database
    await ChartNativeDB.instance.nukeLocalData();

    // 2. Wipe physical files and RAM cache
    await clearPhysicalCache();

    debugPrint('🏁 [CacheManager] System Clean COMPLETE.');
  }
}
