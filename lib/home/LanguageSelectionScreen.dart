import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'showgrid.dart';
import 'navbar.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final String level;

  const LanguageSelectionScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0FF),
      body: Column(
        children: [
          // Custom Navbar (same as in SchoolLevelsPage)
          CustomNavbar(
            onBackPressed: () => Navigator.pop(context),
            onSettingsPressed: () {}, // Add your settings logic
            backButtonImage: const AssetImage('assets/home/back3.png'),
            settingsButtonImage: const AssetImage('assets/home/c8.png'),
          ),

          // Title
          Container(
            margin: const EdgeInsets.only(bottom: 20, top: 10),
            child: Text(
              'Select Language',
              style: GoogleFonts.chewy(
                fontSize: 48,
                color: const Color.fromARGB(255, 255, 196, 0),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),

          // Language Selection Grid
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _buildLanguageCard(
                  context: context,
                  language: 'English',
                  image: 'assets/home/english.png',
                  color: Colors.blue,
                ),
                _buildLanguageCard(
                  context: context,
                  language: 'Amharic',
                  image: 'assets/home/amharic.png',
                  color: Colors.green,
                ),
                _buildLanguageCard(
                  context: context,
                  language: 'Afaan Oromo',
                  image: 'assets/home/oromo.png',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String language,
    required String image,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonGridPage(
              level: level,
              language: language,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 80),
            const SizedBox(height: 10),
            Text(
              language,
              style: GoogleFonts.comicNeue(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
