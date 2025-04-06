import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetDialog extends StatelessWidget {
  const ResetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.yellow[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.orange,
            width: 4,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Start New Adventure?',
                style: GoogleFonts.luckiestGuy(
                  // Verified cartoon font
                  fontSize: 28,
                  color: Colors.purple[800],
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(3, 3),
                    ),
                  ],
                )),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoundedButton(
                  text: 'YES!',
                  color: Colors.pink[300]!,
                  textStyle: GoogleFonts.chewy(
                    // Verified kid-friendly font
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  onTap: () => Navigator.pop(context, true),
                ),
                const SizedBox(width: 20),
                _buildRoundedButton(
                  text: 'NO',
                  color: Colors.purple[300]!,
                  textStyle: GoogleFonts.chewy(
                    fontSize: 22,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                  onTap: () => Navigator.pop(context, false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedButton({
    required String text,
    required Color color,
    required TextStyle textStyle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
