import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gech/School/Nursery/English/Quarter 1/lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'progress.dart';
import 'navbar.dart';

class ShowLesson extends StatefulWidget {
  final Lesson lesson;
  final Function onLessonComplete;

  const ShowLesson({
    super.key,
    required this.lesson,
    required this.onLessonComplete,
  });

  @override
  _ShowLessonState createState() => _ShowLessonState();
}

class _ShowLessonState extends State<ShowLesson>
    with SingleTickerProviderStateMixin {
  int _currentLetterIndex = 0;
  bool _isLessonComplete = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final Set<String> _completedLetters = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playLetterSound() {
    // Add your sound playing logic here
    _animationController.forward(from: 0.0);
  }

  Future<void> _updateLetterProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final allLetters = widget.lesson.letters;
    final progress = _completedLetters.length / allLetters.length;

    await prefs.setDouble('abc_progress', progress);
    await prefs.setStringList(
        'completed_abc_letters', _completedLetters.toList());
  }

  @override
  Widget build(BuildContext context) {
    final currentLetter = widget.lesson.letters[_currentLetterIndex];

    return Scaffold(
      backgroundColor: widget.lesson.secondaryColor,
      body: Column(
        children: [
          // Navbar
          CustomNavbar(
            onBackPressed: () => Navigator.pop(context),
            onSettingsPressed: () => Navigator.pop(context),
            backButtonImage: const AssetImage('assets/home/back3.png'),
            settingsButtonImage: const AssetImage('assets/home/c6.png'),
          ),

          // Lesson Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.lesson.title,
              style: GoogleFonts.comicNeue(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: widget.lesson.primaryColor,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),

          // Whiteboard Area with Navigation
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  // border: Border.all(
                  //   color: widget.lesson.primaryColor,
                  //   width: 3,
                  // ),
                ),
                child: _isLessonComplete
                    ? _buildCompletionScreen()
                    : Stack(
                        children: [
                          // Main Letter
                          Center(
                            child: GestureDetector(
                              onTap: _playLetterSound,
                              child: AnimatedBuilder(
                                animation: _scaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Text(
                                      currentLetter,
                                      style: GoogleFonts.bubblegumSans(
                                        fontSize: 200,
                                        color: widget.lesson.primaryColor,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            offset: const Offset(3, 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          // Navigation Controls (inside whiteboard)
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Previous Button
                                  GestureDetector(
                                    onTap: _currentLetterIndex > 0
                                        ? () {
                                            setState(() {
                                              _currentLetterIndex--;
                                            });
                                          }
                                        : null,
                                    child: Image.asset(
                                      'assets/home/arrowL.png',
                                      width: 100,
                                      height: 100,
                                      color: _currentLetterIndex > 0
                                          ? widget.lesson.primaryColor
                                          : Colors.grey[300],
                                    ),
                                  ),

                                  // Voice Button
                                  GestureDetector(
                                    onTap: _playLetterSound,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.lesson.primaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: Image.asset(
                                        'assets/home/c8.png',
                                        width: 40,
                                        height: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  // Next/Complete Button
                                  GestureDetector(
                                    onTap: () {
                                      if (_currentLetterIndex <
                                          widget.lesson.letters.length - 1) {
                                        setState(() {
                                          _completedLetters.add(currentLetter);
                                          _currentLetterIndex++;
                                          _updateLetterProgress();
                                        });
                                      } else {
                                        setState(() {
                                          _completedLetters.add(currentLetter);
                                          _isLessonComplete = true;
                                        });
                                        widget.onLessonComplete();
                                        ProgressService()
                                            .completeLesson(widget.lesson.id);
                                        _updateLetterProgress();
                                      }
                                    },
                                    child: Image.asset(
                                      _currentLetterIndex <
                                              widget.lesson.letters.length - 1
                                          ? 'assets/home/arrowR.png'
                                          : 'assets/icons/complete.png',
                                      width: 100,
                                      height: 100,
                                      color: widget.lesson.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Progress Dots (inside whiteboard)
                          Positioned(
                            bottom: 10,
                            top: 90,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: widget.lesson.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    widget.lesson.letters.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _currentLetterIndex = index;
                                          });
                                        },
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: index == _currentLetterIndex
                                                ? widget.lesson.primaryColor
                                                : Colors.grey.withOpacity(0.3),
                                            border: Border.all(
                                              color:
                                                  index == _currentLetterIndex
                                                      ? Colors.black
                                                          .withOpacity(0.2)
                                                      : Colors.transparent,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 100,
            color: Colors.green,
          ),
          const SizedBox(height: 20),
          Text(
            "Congratulations!",
            style: GoogleFonts.comicNeue(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You've completed ${widget.lesson.title}",
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.lesson.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Back to Lessons",
              style: GoogleFonts.comicNeue(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
