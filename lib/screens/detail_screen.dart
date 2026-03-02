import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/global.dart';
import 'package:the_holy_quran/models/ayat.dart';
import 'package:the_holy_quran/models/surah.dart';

class DetailScreen extends StatelessWidget {
  final noSurat;

  const DetailScreen({super.key, required this.noSurat});

  Future<Surah> _getDetailSurah() async {
    try {
      // Load data dari assets local JSON file
      String jsonString = await rootBundle.loadString(
        'assets/datas/surah_$noSurat.json',
      );
      Map<String, dynamic> data = json.decode(jsonString);
      print('✓ Data dimuat dari assets: ${data['nama_latin']}');
      return Surah.fromJson(data);
    } catch (e) {
      print('✗ Error loading surah: $e');
      throw Exception('Gagal memuat data surah $noSurat');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Surah>(
      future: _getDetailSurah(),
      initialData: null,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Scaffold(
            backgroundColor: background,
            body: Center(child: CircularProgressIndicator(color: primary)),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off_outlined, size: 60, color: primary),
                    SizedBox(height: 16),
                    Text(
                      'Tidak Ada Data',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      snapshot.error.toString().replaceFirst('Exception: ', ''),
                      style: GoogleFonts.poppins(color: text, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      child: Text(
                        'Kembali',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(backgroundColor: background);
        }

        Surah surah = snapshot.data!;
        return Scaffold(
          backgroundColor: background,
          appBar: _appBar(context: context, surah: surah),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _details(surah: surah)),
            ],
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView.separated(
                itemBuilder: (context, index) => _ayatItem(
                  ayat: surah.ayat!.elementAt(index + (noSurat == 1 ? 1 : 0)),
                ),
                itemCount: surah.jumlahAyat + (noSurat == 1 ? -1 : 0),
                separatorBuilder: (context, index) => Container(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _ayatItem({required Ayat ayat}) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(27 / 2),
                ),
                child: Center(
                  child: Text(
                    '${ayat.nomor}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.share_outlined, color: primary, size: 24),
              ),
              SizedBox(width: 16),
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.play_arrow_outlined, color: primary, size: 24),
              ),
              SizedBox(width: 16),
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.bookmark_outline, color: primary, size: 24),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Text(
          ayat.ar,
          style: GoogleFonts.amiri(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 16),
        Text(ayat.idn, style: GoogleFonts.poppins(color: text, fontSize: 15)),
      ],
    ),
  );

  Widget _details({required Surah surah}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Stack(
      children: [
        Container(
          height: 257,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, .6, 1],
              colors: [Color(0xFF1B7B4D), Color(0xFF27AE60), Color(0xFF2ECC71)],
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Opacity(
            opacity: .2,
            child: SvgPicture.asset("assets/svgs/quran.svg", width: 270),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Text(
                surah.namaLatin,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                surah.arti,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Divider(color: Colors.white38, thickness: 2, height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    surah.tempatTurun.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "${surah.jumlahAyat} Ayat",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SvgPicture.asset('assets/svgs/bismillah.svg'),
            ],
          ),
        ),
      ],
    ),
  );

  AppBar _appBar({required BuildContext context, required Surah surah}) =>
      AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: (() => {Navigator.of(context).pop()}),
              icon: SvgPicture.asset('assets/svgs/back-icon.svg'),
            ),
            const SizedBox(width: 24),
            Text(
              surah.namaLatin,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: (() => {}),
              icon: SvgPicture.asset('assets/svgs/search-icon.svg'),
            ),
          ],
        ),
      );
}
