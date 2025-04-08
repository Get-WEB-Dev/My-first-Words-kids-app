import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:gech/School/Nursery/English/Quarter 1/lesson.dart';
import 'lesson_screen.dart';
import '../School/Nursery/English/Quarter 1/quiz_screen.dart';
import '../School/Nursery/English/Quarter 1/services.dart';
import 'progress.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonGridPage extends StatefulWidget {
  final String level;
  const LessonGridPage({
    super.key,
    required this.level,
  });

  @override
  State<LessonGridPage> createState() => _LessonGridPageState();
}

class _LessonGridPageState extends State<LessonGridPage>
    with SingleTickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  List<Lesson> _items = [];
  List<bool> _isCompleted = [];
  int _currentIndex = 0;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;
  List<double> _quarterProgress = [0.0, 0.0, 0.0, 0.0];
  int _currentQuarter = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadData();

    // Button pulse animation
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final items = await DataService.loadAllItems();
      final completedIds = await _progressService.getCompletedLessons();
      final currentIndex = await _progressService.getCurrentLessonIndex();

      setState(() {
        _items = items;
        _isCompleted =
            items.map((item) => completedIds.contains(item.id)).toList();
        _currentIndex = currentIndex;

        // Calculate progress for each quarter (10 items per quarter)
        for (int i = 0; i < 4; i++) {
          final start = i * 10;
          final end = (i + 1) * 10;
          final quarterItems = _items.sublist(
            start.clamp(0, _items.length),
            end.clamp(0, _items.length),
          );
          final completedCount = quarterItems
              .where((item) => completedIds.contains(item.id))
              .length;
          _quarterProgress[i] =
              quarterItems.isEmpty ? 0.0 : completedCount / quarterItems.length;
        }
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E8C7),
      body: Column(
        children: [
          CustomNavbar(
            onBackPressed: () => Navigator.pop(context),
            onSettingsPressed: () => _showResetDialog(context),
            backButtonImage: const AssetImage('assets/home/back3.png'),
            settingsButtonImage: const AssetImage('assets/home/c8.png'),
          ),

          // Quarter name
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Quarter ${_currentQuarter + 1}',
              style: GoogleFonts.luckiestGuy(
                fontSize: 24,
                color: Colors.purple,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),

          // Progress bar with four segments
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        // Quarter 1 progress
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _quarterProgress[0] == 1.0
                                  ? Colors.green
                                  : Colors.purple.withOpacity(0.6),
                              border: Border.all(
                                color: Colors.purple,
                                width: 1,
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _quarterProgress[0],
                              child: Container(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                        // Quarter 2 progress
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _quarterProgress[1] == 1.0
                                  ? Colors.green
                                  : Colors.blue.withOpacity(0.6),
                              border: Border.all(
                                color: Colors.blue,
                                width: 1,
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _quarterProgress[1],
                              child: Container(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        // Quarter 3 progress
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _quarterProgress[2] == 1.0
                                  ? Colors.green
                                  : Colors.orange.withOpacity(0.6),
                              border: Border.all(
                                color: Colors.orange,
                                width: 1,
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _quarterProgress[2],
                              child: Container(
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                        // Quarter 4 progress
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _quarterProgress[3] == 1.0
                                  ? Colors.green
                                  : Colors.red.withOpacity(0.6),
                              border: Border.all(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _quarterProgress[3],
                              child: Container(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: 4,
              onPageChanged: (index) {
                setState(() {
                  _currentQuarter = index;
                });
              },
              itemBuilder: (context, quarterIndex) {
                // Get 10 items for this quarter
                final start = quarterIndex * 10;
                final end = (quarterIndex + 1) * 10;
                final quarterItems = _items.sublist(
                  start.clamp(0, _items.length),
                  end.clamp(0, _items.length),
                );
                final quarterCompleted = _isCompleted.sublist(
                  start.clamp(0, _isCompleted.length),
                  end.clamp(0, _isCompleted.length),
                );

                return Stack(
                  children: [
                    // Main content grid with fun background
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/home/grid_background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: quarterIndex == 0 ||
                              _quarterProgress[quarterIndex - 1] == 1.0
                          ? GridView.builder(
                              padding: const EdgeInsets.all(20),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: quarterItems.length,
                              itemBuilder: (context, index) => _buildItemCard(
                                  quarterItems[index],
                                  quarterCompleted[index],
                                  index <= _currentIndex - start ||
                                      (quarterIndex > 0 &&
                                          _quarterProgress[quarterIndex - 1] ==
                                              1.0),
                                  index + start),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    'assets/home/Lock.json',
                                    width: 150,
                                    height: 150,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Complete Quarter $quarterIndex to unlock',
                                    style: GoogleFonts.comicNeue(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      Lesson item, bool isCompleted, bool isAvailable, int globalIndex) {
    return GestureDetector(
      onTap: isAvailable ? () => _startItem(item, globalIndex) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isAvailable
              ? item.secondaryColor.withOpacity(0.8)
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAvailable ? item.primaryColor : Colors.grey,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon or badge
            if (item.type == 'lesson')
              _buildLessonBadge(globalIndex + 1, item.primaryColor, isAvailable)
            else
              _buildQuizBadge(isAvailable),

            const SizedBox(height: 10),

            // Title with fun font
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isAvailable ? Colors.black : Colors.grey[700],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Status indicator or button
            if (isCompleted)
              Lottie.asset(
                'assets/home/complete.json',
                width: 100,
                height: 100,
              )
            else if (isAvailable)
              ScaleTransition(
                scale: _buttonAnimation,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    elevation: 5,
                  ),
                  onPressed: () => _startItem(item, globalIndex),
                  child: Text(
                    item.type == 'lesson' ? 'START' : 'START QUIZ',
                    style: GoogleFonts.luckiestGuy(
                      color: Colors.white,
                      fontSize: 16,
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
              )
            else
              Lottie.asset(
                'assets/home/Lock.json',
                width: 40,
                height: 40,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonBadge(int number, Color color, bool isUnlocked) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked ? color : Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: GoogleFonts.luckiestGuy(
            color: Colors.white,
            fontSize: 24,
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
    );
  }

  Widget _buildQuizBadge(bool isUnlocked) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked ? Colors.orange : Colors.grey,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.quiz,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Future<void> _startItem(Lesson item, int index) async {
    if (item.type == 'lesson') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowLesson(
            lesson: item,
            onLessonComplete: () => _completeItem(index),
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            quiz: item,
            onComplete: () => _completeItem(index),
          ),
        ),
      );
    }
    await _loadData();
  }

  Future<void> _completeItem(int index) async {
    await _progressService.completeLesson(_items[index].id);

    final allCompleted = await _checkAllItemsCompleted();
    if (allCompleted) {
      // Directly unlock the next level
      final prefs = await SharedPreferences.getInstance();
      if (widget.level == 'Nursery') {
        await prefs.setBool('LKG_unlocked', true);
      } else if (widget.level == 'LKG') {
        await prefs.setBool('UKG_unlocked', true);
      }

      // Show completion dialog
      await _showLevelCompleteDialog();

      // Return to school page
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == _currentIndex && index < _items.length - 1) {
      await _progressService.setCurrentLessonIndex(index + 1);
    }

    if (mounted) await _loadData();
  }

  Future<bool> _checkAllItemsCompleted() async {
    final completedIds = await _progressService.getCompletedLessons();
    return _items.every((item) => completedIds.contains(item.id));
  }

  Future<void> _showLevelCompleteDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/home/sparkle.json',
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              'Level Completed!',
              style: GoogleFonts.luckiestGuy(
                fontSize: 28,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You unlocked ${widget.level == 'Nursery' ? 'LKG' : 'UKG'} level!',
              style: GoogleFonts.comicNeue(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Continue',
                style: GoogleFonts.comicNeue(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context) async {
    return showDialog(
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
          'This will reset all your progress in this level.',
          style: GoogleFonts.comicNeue(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.comicNeue(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await _progressService.resetProgress();
              if (mounted) {
                await _loadData();
                Navigator.pop(context);
              }
            },
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
    );
  }
}
