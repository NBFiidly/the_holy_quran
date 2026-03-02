import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/global.dart';
import 'package:the_holy_quran/tabs/para_tab.dart';
import 'package:the_holy_quran/tabs/surah_tab.dart';

import '../tabs/hijb_tab.dart';
import '../tabs/page_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      backgroundColor: background,
      body: DefaultTabController(
        length: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: _greeting()),
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: background,
                automaticallyImplyLeading: false,
                shape: Border(bottom: BorderSide(color: secondary, width: 1)),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: _tab(),
                ),
              ),
            ]),
            body: TabBarView(
              children: [SurahTab(), ParaTab(), PageTab(), HijbTab()],
            ),
          ),
        ),
      ),
    );
  }

  TabBar _tab() {
    return TabBar(
      unselectedLabelColor: text,
      labelColor: Colors.white,
      indicatorColor: primary,
      indicatorWeight: 3,
      tabs: [
        _tabItem(label: "Surah"),
        _tabItem(label: "Para"),
        _tabItem(label: "page"),
        _tabItem(label: "Hijb"),
      ],
    );
  }

  Tab _tabItem({required String label}) {
    return Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Column _greeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Assalamualaikum",
          style: GoogleFonts.poppins(
            color: text,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Nur Bith Fidly",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        _lastRead(),
      ],
    );
  }

  Stack _lastRead() {
    return Stack(
      children: [
        Container(
          height: 131,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, .6, 1],
              colors: [Color(0xFFDF98FA), Color(0xFFB070FD), Color(0xFF9055FF)],
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: SvgPicture.asset("assets/svgs/quran.svg"),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/book.svg'),
                  const SizedBox(width: 8),
                  Text(
                    "Terakhir dibaca",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Al-Fatihah",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Ayat No: 1",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _appBar() => AppBar(
    backgroundColor: background,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(
      children: [
        IconButton(
          onPressed: (() => {}),
          icon: SvgPicture.asset('assets/svgs/menu-icon.svg'),
        ),
        const SizedBox(width: 24),
        Text(
          "Al-Qur'an",
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

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: secondary,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    items: [
      _bottomBarItem(icon: "assets/svgs/quran-icon.svg", label: "Quran"),
      _bottomBarItem(icon: "assets/svgs/lamp-icon.svg", label: "Tips"),
      _bottomBarItem(icon: "assets/svgs/pray-icon.svg", label: "Ibadah"),
      _bottomBarItem(icon: "assets/svgs/doa-icon.svg", label: "Doa"),
      _bottomBarItem(icon: "assets/svgs/bookmark-icon.svg", label: "Quran"),
    ],
  );

  BottomNavigationBarItem _bottomBarItem({
    required String icon,
    required String label,
  }) => BottomNavigationBarItem(
    icon: SvgPicture.asset(icon, color: text),
    activeIcon: SvgPicture.asset(icon, color: primary),
    label: label,
  );
}
