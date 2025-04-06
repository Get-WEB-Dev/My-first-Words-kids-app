import 'package:flutter/material.dart';

class EducationalGrid extends StatelessWidget {
  const EducationalGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 100,
      crossAxisSpacing: 50,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _EducationalButton(
          icon: Icons.school,
          label: 'School',
          color: Colors.blue[400]!,
          imagePath: 'assets/home/Button.png',
        ),
        _EducationalButton(
          icon: Icons.translate,
          label: 'Translate',
          color: Colors.green[400]!,
          imagePath: 'assets/home/Button.png',
        ),
        _EducationalButton(
          icon: Icons.videogame_asset,
          label: 'Game',
          color: Colors.orange[400]!,
          imagePath: 'assets/home/Button.png',
        ),
        _EducationalButton(
          icon: Icons.emoji_events,
          label: 'Achievement',
          color: Colors.purple[400]!,
          imagePath: 'assets/home/Button.png',
        ),
      ],
    );
  }
}

class _EducationalButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String imagePath;

  const _EducationalButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle button tap
        print('$label tapped!');
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
