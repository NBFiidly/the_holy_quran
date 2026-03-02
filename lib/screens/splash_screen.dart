import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_holy_quran/global.dart';
import 'package:the_holy_quran/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                SvgPicture.asset(
                  'assets/svgs/app-logo.svg',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 24),
                // App Name
                Text(
                  "Aplikasi Al-Qur'an",
                  style: GoogleFonts.poppins(
                    color: primary,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Tagline
                Text(
                  "Belajar Al-Quran dan\nTerjemahan bahasa Indonesia",
                  style: GoogleFonts.poppins(fontSize: 16, color: text),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, .6, 1],
                          colors: [
                            // ignore: deprecated_member_use
                            primary.withOpacity(0.8),
                            // ignore: deprecated_member_use
                            primary.withOpacity(0.6),
                            const Color(0xFF1B7B4D),
                          ],
                        ),
                      ),
                      child: SvgPicture.asset('assets/svgs/splash.svg'),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -23,
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            ),
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: primary.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'Baca Al-Qur\'an',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
