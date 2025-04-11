import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'navbar.dart';
import 'showgrid.dart';
import 'progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LanguageSelectionScreen.dart';

class SchoolLevelsPage extends StatefulWidget {
  const SchoolLevelsPage({super.key});

  @override
  State<SchoolLevelsPage> createState() => _SchoolLevelsPageState();
}

class _SchoolLevelsPageState extends State<SchoolLevelsPage> {
  Map<String, bool> levelStatus = {
    'Nursery': true, // Nursery unlocked by default
    'LKG': false,
    'UKG': false,
  };

  @override
  void initState() {
    super.initState();
    _loadLevelProgress();
  }

  Future<void> _loadLevelProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      levelStatus = {
        'Nursery': true, // Always unlocked
        'LKG': prefs.getBool('LKG_unlocked') ?? false,
        'UKG': prefs.getBool('UKG_unlocked') ?? false,
      };
    });
  }

  Future<void> _resetAllProgress() async {
    // Reset level progress
    setState(() {
      levelStatus = {
        'Nursery': true, // Only Nursery unlocked
        'LKG': false,
        'UKG': false,
      };
    });

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('LKG_unlocked');
    await prefs.remove('UKG_unlocked');

    // Clear lesson progress
    final progressService = ProgressService();
    await progressService.resetProgress();

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All progress has been reset',
          style: GoogleFonts.comicNeue(fontSize: 18),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showResetConfirmationDialog() async {
    final shouldReset = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Reset Progress?',
              style: GoogleFonts.comicNeue(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'This will reset all levels and lessons to the beginning.',
              style: GoogleFonts.comicNeue(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.comicNeue(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Reset',
                  style: GoogleFonts.comicNeue(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldReset) {
      await _resetAllProgress();
    }
  }

  Future<void> _saveLevelProgress() async {
    final file = await _getLevelsFile();
    await file.writeAsString(jsonEncode(levelStatus));

    // Also save to SharedPreferences for persistence
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('LKG_unlocked', levelStatus['LKG']!);
    await prefs.setBool('UKG_unlocked', levelStatus['UKG']!);
  }

  Future<File> _getLevelsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/level_progress.json');
  }

  // In your SchoolLevelsPage where you navigate to LessonGridPage:
  void _navigateToLessons(String level) async {
    final levelCompleted = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => LanguageSelectionScreen(level: level),
          ),
        ) ??
        false;

    if (levelCompleted && mounted) {
      // Force reload the school page
      setState(() {
        levelStatus = {
          'Nursery': true,
          'LKG': level == 'Nursery' ? true : levelStatus['LKG']!,
          'UKG': level == 'LKG' ? true : levelStatus['UKG']!,
        };
      });

      await _saveLevelProgress();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${level == 'Nursery' ? 'LKG' : 'UKG'} level unlocked! 🎉',
            style: GoogleFonts.comicNeue(fontSize: 18),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLockedMessage(String levelName) {
    String message = 'Complete Nursery Class to unlock!';
    if (levelName == 'UKG') {
      message = 'Complete LKG Class to unlock!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Lottie.asset(
                'assets/home/Lock.json',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Text(
                message,
                style: GoogleFonts.comicNeue(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F0FF),
      body: Column(
        children: [
          // Custom Navbar
          CustomNavbar(
            onBackPressed: () => Navigator.pop(context),
            onSettingsPressed: _showResetConfirmationDialog,
            backButtonImage: const AssetImage('assets/home/back3.png'),
            settingsButtonImage: const AssetImage('assets/home/c8.png'),
          ),

          // Title Banner
          Container(
            margin: const EdgeInsets.only(bottom: 0, top: 10),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              // gradient: const LinearGradient(
              //   colors: [Colors.purple, Colors.blue],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
              borderRadius: BorderRadius.circular(30),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.purple.withOpacity(0.3),
              //     blurRadius: 10,
              //     offset: const Offset(0, 5),
              //   ),
              // ],
            ),
            child: Text(
              'School Levels',
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
              textAlign: TextAlign.center,
            ),
          ),

          // Levels List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildLevelCard(
                  levelName: 'Nursery',
                  imagePath: 'assets/home/nursary.png',
                  locked: false,
                  context: context,
                  color: Colors.pink,
                  characterAnimation: 'assets/home/ABC.json',
                ),
                const SizedBox(height: 30),
                _buildLevelCard(
                  levelName: 'LKG',
                  imagePath: 'assets/home/LKG.png',
                  locked: !levelStatus['LKG']!,
                  context: context,
                  color: Colors.blue,
                  characterAnimation: 'assets/home/ABC.json',
                ),
                const SizedBox(height: 30),
                _buildLevelCard(
                  levelName: 'UKG',
                  imagePath: 'assets/home/UKG.png',
                  locked: !levelStatus['UKG']!,
                  context: context,
                  color: Colors.green,
                  characterAnimation: 'assets/home/ABC.json',
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
    required Color color,
    required String characterAnimation,
  }) {
    return GestureDetector(
      onTap: () {
        if (!locked) {
          _navigateToLessons(levelName); // Pass the level name
        } else {
          _showLockedMessage(levelName);
        }
      },
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: locked ? Colors.grey[100] : color.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: (locked ? Colors.grey : color).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: locked ? Colors.grey : color,
            width: 4,
          ),
        ),
        child: Stack(
          children: [
            if (!locked && levelStatus[levelName] == true)
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.star, color: Colors.yellow),
              ),
            // Full background image (not greyed out)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Character animation in circle (right side)
            Positioned(
              right: 20,
              top: 20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                  border: Border.all(
                    color: locked ? Colors.grey : color,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Lottie.asset(
                    characterAnimation,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Level Name badge (left side) - always visible
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: locked ? color.withOpacity(0.7) : color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      levelName,
                      style: GoogleFonts.luckiestGuy(
                        fontSize: 24,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    if (!locked)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Lock overlay if locked (semi-transparent)
            if (locked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Lottie.asset(
                      'assets/home/Lock.json',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
