import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:gech/School/Nursery/English/Quarter 1/lesson.dart';
import 'lesson_screen.dart';
import '../School/Nursery/English/Quarter 1/quiz_screen.dart';
import '../School/Nursery/English/Quarter 1/services.dart';
import 'progress.dart';
import 'progress_track.dart';
import 'quiz_progress.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonGridPage extends StatefulWidget {
  final String level;
  final String language;

  const LessonGridPage({
    super.key,
    required this.level,
    required this.language,
  });

  @override
  State<LessonGridPage> createState() => _LessonGridPageState();
}

class _LessonGridPageState extends State<LessonGridPage>
    with SingleTickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  final Map<String, int> _quizScores = {};
  List<Lesson> _items = [];
  List<bool> _isCompleted = [];
  int _currentIndex = 0;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;
  final List<double> _quarterProgress = [0.0, 0.0, 0.0, 0.0];
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
      // Load all quarters for this level and language
      final quarters = await DataService.loadAllQuarters(
        widget.level,
        widget.language,
      );

      // Combine all lessons from all quarters
      final allItems = quarters.values.expand((x) => x).toList();

      final completedIds = await _progressService.getCompletedLessons();
      final currentIndex = await _progressService.getCurrentLessonIndex();

      setState(() {
        _items = allItems;
        _isCompleted =
            allItems.map((item) => completedIds.contains(item.id)).toList();
        _currentIndex = currentIndex;

        // Calculate progress for each quarter
        quarters.forEach((quarter, items) {
          final completedCount =
              items.where((item) => completedIds.contains(item.id)).length;
          _quarterProgress[quarter - 1] =
              items.isEmpty ? 0.0 : completedCount / items.length;
        });
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
                IconButton(
                  icon: const Icon(Icons.leaderboard),
                  onPressed: _showCategoryProgress,
                ),
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
                    final quarterNumber = quarterIndex + 1;
                    final quarterItems = _items
                        .where((item) => item.quarter == quarterNumber)
                        .toList();
                    final quarterCompleted = quarterItems
                        .map((item) => _isCompleted[_items.indexOf(item)])
                        .toList();
                    final isQuarterUnlocked = quarterIndex == 0 ||
                        _quarterProgress[quarterIndex - 1] == 1.0;

                    return Stack(
                      children: [
                        // Background image (applies to both locked and unlocked states)
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/home/grid_background.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Lessons grid (always visible)
                        GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: quarterItems.length,
                          itemBuilder: (context, index) {
                            final globalIndex =
                                _items.indexOf(quarterItems[index]);
                            return _buildItemCard(
                              quarterItems[index],
                              quarterCompleted[index],
                              isQuarterUnlocked &&
                                  (globalIndex <= _currentIndex),
                              globalIndex,
                              isQuarterUnlocked, // Pass the quarter unlocked state
                            );
                          },
                        ),

                        // Lock overlay (only for locked quarters)
                        if (!isQuarterUnlocked)
                          Container(
                            color: Colors.black
                                .withOpacity(0.3), // Semi-transparent overlay
                            child: Center(
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
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }

  Widget _buildItemCard(Lesson item, bool isCompleted, bool isAvailable,
      int globalIndex, bool isQuarterUnlocked) {
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

  Widget _buildLockableItemCard(
    Lesson item,
    bool isCompleted,
    bool isAvailable,
    int index,
    bool isQuarterUnlocked,
  ) {
    return Stack(
      children: [
        // Lesson card
        Container(
          decoration: BoxDecoration(
            color: isQuarterUnlocked
                ? item.secondaryColor.withOpacity(0.8)
                : Colors.grey[300]!.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isQuarterUnlocked ? item.primaryColor : Colors.grey,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.type == 'lesson')
                _buildLessonBadge(
                    index + 1, item.primaryColor, isQuarterUnlocked)
              else
                _buildQuizBadge(isQuarterUnlocked),
              const SizedBox(height: 10),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isQuarterUnlocked ? Colors.black : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),

        // Semi-transparent overlay if quarter is locked
        if (!isQuarterUnlocked)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
      ],
    );
  }

  Future<void> _startItem(Lesson item, int index) async {
    // Find the actual item from the full list to ensure consistency
    final actualItem = _items.firstWhere(
      (i) => i.id == item.id && i.quarter == item.quarter,
      orElse: () => item, // Fallback to the passed item if not found
    );

    if (actualItem.type == 'quiz') {
      // Convert item.id to String once at the start for consistency
      final itemId = actualItem.id.toString();

      // Initialize with default 0 using string ID
      _quizScores[itemId] = 0;

      final score = await Navigator.push<int>(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            quiz: actualItem, // Use actualItem instead of item
            onComplete: () => _completeItem(index),
          ),
        ),
      );

      debugPrint('Quiz returned score: $score');

      if (score != null) {
        setState(() {
          _quizScores[itemId] = score; // Update using string ID
        });

        // Save and verify immediately
        await _completeItem(index);

        // Immediate save verification using string ID
        final prefs = await SharedPreferences.getInstance();
        final savedScore = prefs.getInt('quiz_score_$itemId');
        debugPrint('Saved score verification: $savedScore (expected: $score)');

        if (savedScore != score) {
          debugPrint('❌ Score mismatch! Performing emergency save...');
          await prefs.setInt('quiz_score_$itemId', score);
          debugPrint('Emergency save completed');
        }
      } else {
        debugPrint('⚠️ Quiz returned null score');
      }
    } else if (actualItem.type == 'lesson') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowLesson(
            lesson: actualItem, // Use actualItem instead of item
            onLessonComplete: () => _completeItem(index),
          ),
        ),
      );
    }
    await _loadData();
  }

  Future<void> _completeItem(int index) async {
    final item = _items[index];

    if (item.type == 'quiz') {
      try {
        // Convert ID to string explicitly
        final quizId = item.id.toString();
        final score = _quizScores[item.id] ?? 0;

        debugPrint('Saving quiz $quizId with score: $score');

        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();

        // Save all data with proper string IDs
        await Future.wait([
          prefs.setInt('quiz_score_$quizId', score),
          prefs.setInt('total_questions_$quizId', item.questions?.length ?? 0),
          prefs.setString('quiz_title_$quizId', item.title),
          prefs.setString('quiz_category_$quizId', item.category),
          prefs.setBool('quiz_completed_$quizId', true),
        ]);

        // Verification
        final savedScore = prefs.getInt('quiz_score_$quizId');
        debugPrint('Saved score verification: $savedScore (expected: $score)');

        setState(() {
          _isCompleted[index] = true;
        });
      } catch (e) {
        debugPrint('❌ Error saving quiz results: $e');
      }
    }
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

  void _showCategoryProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryProgressPage(),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reset All Progress',
          style: GoogleFonts.comicNeue(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'This will reset ALL progress including lessons AND quiz scores.',
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
              // Reset both lessons and quizzes
              await _progressService
                  .resetProgress(); // Your existing lesson reset
              // await ProgressServices.resetQuizProgress(); // New quiz reset

              if (mounted) {
                // Clear in-memory quiz scores
                _quizScores.clear();

                // Reload data and update UI
                await _loadData();
                Navigator.pop(context);

                // Show confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('All progress and quiz scores have been reset'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Debug verification
                // await _debugPrintQuizStatus();
              }
            },
            child: Text(
              'Reset All',
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
