import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gech/School/Nursery/English/Quarter 1/lesson.dart';
import 'lesson_screen.dart';
import 'package:gech/School/Nursery/English/Quarter 1/quiz_screen.dart';
import 'package:gech/School/Nursery/English/Quarter 1/services.dart';
import 'progress.dart';
import 'navbar.dart';

class LessonGridPage extends StatefulWidget {
  const LessonGridPage({super.key});

  @override
  State<LessonGridPage> createState() => _LessonGridPageState();
}

class _LessonGridPageState extends State<LessonGridPage>
    with SingleTickerProviderStateMixin {
  final ProgressService _progressService = ProgressService();
  List<Lesson> _items = [];
  List<bool> _isCompleted = [];
  int _currentIndex = 0;
  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();

    // Animation setup
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _arrowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: 0.0), weight: 1),
    ]).animate(_arrowController);
  }

  @override
  void dispose() {
    _arrowController.dispose();
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
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  @override
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
            settingsButtonImage: const AssetImage('assets/home/c00.png'),
          ),
          Expanded(
            child: Stack(
              children: [
                // Main content grid
                GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) => _buildItemCard(index),
                ),

                // Arrows between items
                ..._buildAllArrows(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAllArrows() {
    List<Widget> arrows = [];
    for (int i = 0; i < _items.length - 1; i++) {
      // Only add arrow if it's the next item in sequence (either horizontal or vertical)
      if (i + 1 == i ~/ 2 * 2 + 1 || i + 1 == i + 2) {
        arrows.add(_buildArrowBetween(i, i + 1));
      }
    }
    return arrows;
  }

  Widget _buildArrowBetween(int fromIndex, int toIndex) {
    final isFromCompleted =
        fromIndex < _isCompleted.length && _isCompleted[fromIndex];
    final shouldBounce = _currentIndex == toIndex;
    const arrowSize = 36.0;

    // Get screen dimensions from MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate positions based on grid layout
    const padding = 20.0;
    const spacing = 20.0;
    final itemWidth = (screenWidth - 2 * padding - spacing) / 2;
    const itemHeight = 160.0;

    final fromRow = fromIndex ~/ 2;
    final fromCol = fromIndex % 2;
    final isHorizontal = toIndex == fromIndex + 1 && fromCol == 0;

    double left, top;

    if (isHorizontal) {
      // Horizontal arrow (same row)
      left =
          padding + (itemWidth + spacing) * fromCol + itemWidth - arrowSize / 2;
      top = padding +
          (itemHeight + spacing) * fromRow +
          itemHeight / 2 -
          arrowSize / 2;
    } else {
      // Vertical arrow (next row)
      left = padding +
          (itemWidth + spacing) * fromCol +
          itemWidth / 2 -
          arrowSize / 2;
      top = padding +
          (itemHeight + spacing) * fromRow +
          itemHeight -
          arrowSize / 2;
    }

    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: _arrowAnimation,
        builder: (context, child) {
          return Transform(
            transform: isHorizontal
                ? Matrix4.identity()
                : Matrix4.rotationZ(1.5708), // 90 degrees for vertical
            child: Transform.translate(
              offset: Offset(0, shouldBounce ? _arrowAnimation.value : 0),
              child: Image.asset(
                'assets/home/arrow.png',
                width: arrowSize,
                height: arrowSize,
                color: isFromCompleted ? Colors.green : Colors.amber,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemCard(int index) {
    final item = _items[index];
    final isCompleted = index < _isCompleted.length && _isCompleted[index];
    final isAvailable = index <= _currentIndex;
    final cardKey = GlobalKey(); // Add this line

    return GestureDetector(
      key: cardKey,
      onTap: isAvailable ? () => _startItem(item, index) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable ? item.secondaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAvailable ? item.primaryColor : Colors.grey,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.type == 'lesson'
                ? _buildLessonBadge(index + 1, item.primaryColor, isAvailable)
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAvailable ? item.primaryColor : Colors.grey,
                    ),
                    child: const Icon(Icons.quiz, color: Colors.white),
                  ),
            const SizedBox(height: 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isAvailable ? Colors.brown[800] : Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            if (isCompleted)
              const Icon(Icons.check_circle, color: Colors.green, size: 28)
            else if (isAvailable)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () => _startItem(item, index),
                child: Text(
                  item.type == 'lesson' ? 'START' : 'START QUIZ',
                  style: GoogleFonts.medievalSharp(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            else
              const Icon(Icons.lock, color: Colors.amber, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonBadge(int number, Color color, bool isUnlocked) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked ? color : Colors.grey,
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: GoogleFonts.medievalSharp(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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

    if (index == _currentIndex && index < _items.length - 1) {
      await _progressService.setCurrentLessonIndex(index + 1);
    }

    if (mounted) setState(() {});
  }

  Future<void> _showResetDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text('Are you sure you want to reset all progress?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _progressService.resetProgress();
              if (mounted) {
                await _loadData();
                Navigator.pop(context);
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
