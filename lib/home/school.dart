import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SchoolLevelsPage extends StatelessWidget {
  const SchoolLevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF), // Light blue background
      body: Column(
        children: [
          // Header with yellow title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 35),
            decoration: const BoxDecoration(
              color: Color(0xFF1E88E5), // Dark blue background
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFFFA726), // Orange underline
                  width: 4,
                ),
              ),
            ),
            child: Center(
              child: Text(
                'School Levels',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 36,
                  color: const Color(0xFFFFFF00), // Yellow text
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Levels List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(30),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildLevelCard(
                  levelName: 'UKG',
                  imagePath: 'assets/letter.png',
                  locked: false,
                  context: context,
                ),
                const SizedBox(height: 120),
                _buildLevelCard(
                  levelName: 'LKG',
                  imagePath: 'assets/home/sentence.png',
                  locked: false,
                  context: context,
                ),
                const SizedBox(height: 60),
                _buildLevelCard(
                  levelName: 'Nursery',
                  imagePath: 'assets/letter.png',
                  locked: true,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required String levelName,
    required String imagePath,
    required bool locked,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: locked ? Colors.grey[400]! : const Color(0xFFFFA726),
          width: 6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Background Image
            ColorFiltered(
              colorFilter: locked
                  ? const ColorFilter.matrix([
                      0.33,
                      0.33,
                      0.33,
                      0,
                      0,
                      0.33,
                      0.33,
                      0.33,
                      0,
                      0,
                      0.33,
                      0.33,
                      0.33,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ])
                  : const ColorFilter.mode(
                      Colors.transparent, BlendMode.multiply),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            // Ribbon-style Label
            Positioned(
              top: -18,
              right: -18,
              child: Transform.rotate(
                angle: 0.7854, // 45 degrees
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: locked ? Colors.grey[600] : const Color(0xFFE53935),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    levelName,
                    style: GoogleFonts.luckiestGuy(
                      color: Colors.white,
                      fontSize: 20,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Lock Icon (center if locked)
            if (locked)
              const Center(
                child: Icon(
                  Icons.lock,
                  size: 60,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
