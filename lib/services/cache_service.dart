import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class CacheService {
  static const String cacheDirName = 'quran_cache';
  static const String cacheMetaFile = 'cache_meta.json';
  static const int totalSurah = 114;

  static Future<Directory> _getCacheDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDocDir.path}/$cacheDirName');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  static Future<void> cacheSurah(
    int surahNumber,
    Map<String, dynamic> data,
  ) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final file = File('${cacheDir.path}/surah_$surahNumber.json');
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error caching surah: $e');
    }
  }

  static Future<Map<String, dynamic>?> getCachedSurah(int surahNumber) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final file = File('${cacheDir.path}/surah_$surahNumber.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        return jsonDecode(contents) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error reading cached surah: $e');
    }
    return null;
  }

  static Future<bool> isSurahCached(int surahNumber) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final file = File('${cacheDir.path}/surah_$surahNumber.json');
      return await file.exists();
    } catch (e) {
      print('Error checking cache: $e');
      return false;
    }
  }

  static Future<bool> hasCompleteCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final metaFile = File('${cacheDir.path}/$cacheMetaFile');

      if (!await metaFile.exists()) {
        return false;
      }

      final contents = await metaFile.readAsString();
      final meta = jsonDecode(contents) as Map<String, dynamic>;
      return meta['complete'] == true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> preCacheAllSurah({
    required Function(int, int) onProgress,
  }) async {
    try {
      final dio = Dio();
      int cached = 0;

      for (int i = 1; i <= totalSurah; i++) {
        try {
          print('Caching surah $i/$totalSurah...');
          final response = await dio.get(
            'https://equran.id/api/surat/$i',
            options: Options(
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
            ),
          );

          final data = response.data as Map<String, dynamic>;
          await cacheSurah(i, data);
          cached++;

          onProgress(i, totalSurah);
        } catch (e) {
          print('Error caching surah $i: $e');
          // Continue to next surah
        }
      }

      // Save completion meta
      if (cached == totalSurah) {
        await _saveCompleteMeta();
        print('✓ Pre-cache semua surah selesai!');
      }
    } catch (e) {
      print('Error in preCacheAllSurah: $e');
    }
  }

  static Future<void> _saveCompleteMeta() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final metaFile = File('${cacheDir.path}/$cacheMetaFile');
      final meta = {'complete': true, 'timestamp': DateTime.now().toString()};
      await metaFile.writeAsString(jsonEncode(meta));
    } catch (e) {
      print('Error saving meta: $e');
    }
  }

  static Future<void> clearCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}
