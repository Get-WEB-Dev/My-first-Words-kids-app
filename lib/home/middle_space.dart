import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EducationalButtons extends StatelessWidget {
  final VoidCallback onSchoolPressed;
  final VoidCallback onGamePressed;
  final VoidCallback onTranslatePressed;
  final VoidCallback onAchievementPressed;

  const EducationalButtons({
    super.key,
    required this.onSchoolPressed,
    required this.onGamePressed,
    required this.onTranslatePressed,
    required this.onAchievementPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEducationalButton(
                icon: Icons.school,
                label: 'School',
                color: Colors.blue[400]!,
                onTap: onSchoolPressed,
              ),
              _buildEducationalButton(
                icon: Icons.videogame_asset,
                label: 'Games',
                color: Colors.green[400]!,
                onTap: onGamePressed,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEducationalButton(
                icon: Icons.translate,
                label: 'Translate',
                color: Colors.orange[400]!,
                onTap: onTranslatePressed,
              ),
              _buildEducationalButton(
                icon: Icons.emoji_events,
                label: 'Rewards',
                color: Colors.purple[400]!,
                onTap: onAchievementPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEducationalButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.comicNeue(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
