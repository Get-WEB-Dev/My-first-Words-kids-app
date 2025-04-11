import 'package:flutter/material.dart';
import 'package:gech/School/Nursery/English/Quarter%201/lesson.dart';
import '../School/Nursery/English/Quarter 1/services.dart';
import '../profile/profile_service.dart';
import '../profile/profile_setup.dart';
import '../profile/profile_panel.dart';
import 'profile_header.dart';
import 'reset_dialog.dart';
import 'bottom_navigation.dart';
import 'middle_space.dart';
import 'school.dart';
import 'progress_track.dart';
import 'game.dart';
import 'translate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Lesson> allItems;
  String userName = "User";
  String fullName = "ggggggg";
  String age = '5';
  String currentLevel = "Nursary";
  bool isLoading = true;
  int _currentBottomIndex = 1; // Default to Home active
  String profileImagePath = 'assets/avatars/avatar1.png';
  bool _showProfilePanel = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
    );
    setState(() => _showProfilePanel = false);
  }

  void _toggleProfilePanel() {
    setState(() {
      _showProfilePanel = !_showProfilePanel;
    });
  }

  Future<void> _loadProfile() async {
    try {
      final profileData = await ProfileService.loadProfile();
      setState(() {
        userName = profileData['name'] ?? "Guest";
        fullName = profileData['fullName'] ?? "Guest";
        age = profileData['age'] ?? '5';
        currentLevel = profileData['level'] ?? "Nursary";
        profileImagePath =
            profileData['profileImagePath'] ?? 'assets/home/c3.png';
        isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _resetProfile() async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => const ResetDialog(),
    );

    if (confirm == true && mounted) {
      await ProfileService.resetProfile();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
      );
    }
  }

  void _handleProfileUpdate(Map<String, dynamic> updatedData) {
    setState(() {
      userName = updatedData['name'] ?? userName;
      profileImagePath = updatedData['profileImagePath'] ?? profileImagePath;
      // Add these lines to update the other fields
      fullName = updatedData['fullName'] ?? fullName;
      age = updatedData['age'] ?? age;
      currentLevel = updatedData['level'] ?? currentLevel;
    });
  }

  List<String> _getUniqueCategories(List<Lesson> items) {
    final categories = <String>{};
    for (final item in items) {
      if (item.type == 'quiz') {
        categories.add(item.category);
      }
    }
    return categories.toList();
  }

  Future<void> _navigateToProgress() async {
    final items = await DataService.loadAllItems();
    final categories = items
        .where((item) => item.type == 'quiz')
        .map((quiz) => quiz.category)
        .toSet()
        .toList();
  }

  void _showCategoryProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryProgressPage(),
      ),
    );
  }

// Update the _handleTabChange method
  void _handleTabChange(int index) async {
    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CategoryProgressPage(),
          ),
        );
        break;
      case 1: // Home
        print('Home tapped');
        break;
      case 2: // Calendar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SchoolLevelsPage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blue[400]),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/home/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ProfileHeader(
            userName: userName,
            profileImagePath: profileImagePath,
            onResetPressed: _resetProfile,
            onProfileTap: _toggleProfilePanel,
          ),
          EducationalButtons(
            onSchoolPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SchoolLevelsPage()),
              );
            },
            onGamePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WordPuzzleGame()),
              );
            },
            onTranslatePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TranslationPage()),
              );
            },
            onAchievementPressed: () => print('Rewards pressed'),
          ),
          BottomNavigationButtons(
            initialIndex: _currentBottomIndex,
            onTabChanged: _handleTabChange,
          ),

          // Profile Panel Overlay
          if (_showProfilePanel)
            GestureDetector(
              onTap: _toggleProfilePanel,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

          // Profile Panel
          AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: _showProfilePanel
                  ? 0
                  : -MediaQuery.of(context).size.width * 0.7,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.7,
              child: ProfilePanel(
                onClose: _toggleProfilePanel,
                onEditProfile: _handleProfileUpdate,
                onResetProfile: _resetProfile,
                profileImagePath: profileImagePath,
                userName: userName,
                fullName: fullName, // Now using the state variable
                age: age, // Now using the state variable
                currentLevel: currentLevel, // No
              ))
        ],
      ),
    );
  }
}
