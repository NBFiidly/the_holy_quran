import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

/// Script untuk generate semua surah JSON files
/// Jalankan dengan: dart run bin/generate_quran_data.dart

Future<void> main() async {
  print('🚀 Mulai download data Al-Qur\'an...');

  final dio = Dio();
  final assetsDir = Directory('assets/datas');

  // Create directory jika belum ada
  if (!await assetsDir.exists()) {
    await assetsDir.create(recursive: true);
  }

  int success = 0;
  int failed = 0;

  for (int i = 1; i <= 114; i++) {
    try {
      print('Downloading surah $i/114...');
      final response = await dio.get(
        'https://equran.id/api/surat/$i',
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final nama = data['nama_latin'];

      // Save ke file
      final file = File('${assetsDir.path}/surah_$i.json');
      await file.writeAsString(jsonEncode(data));

      print(
        '✓ Surah $i ($nama) - ${(data['ayat'] as List?)?.length ?? 0} ayat',
      );
      success++;
    } catch (e) {
      print('✗ Error downloading surah $i: $e');
      failed++;
    }

    // Delay untuk menghindari rate limiting
    await Future.delayed(const Duration(milliseconds: 200));
  }

  print('\n' + '=' * 50);
  print('📊 SELESAI!');
  print('Berhasil: $success');
  print('Gagal: $failed');
  print('=' * 50);

  if (success == 114) {
    print('\n✅ Semua data berhasil didownload!');
    print('Semua surah JSON files sudah simpan di assets/datas/');
  }
}
