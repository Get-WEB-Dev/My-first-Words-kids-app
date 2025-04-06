import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gech/School/Nursery/English/Quarter 1/lesson.dart';
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

class _ShowLessonState extends State<ShowLesson> {
  int _currentLetterIndex = 0;
  bool _isLessonComplete = false;

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

          // Whiteboard Area
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
                ),
                child: _isLessonComplete
                    ? _buildCompletionScreen()
                    : Center(
                        child: Text(
                          currentLetter,
                          style: GoogleFonts.bubblegumSans(
                            fontSize: 200,
                            color: widget.lesson.primaryColor,
                          ),
                        ),
                      ),
              ),
            ),
          ),

          // Navigation Buttons
          if (!_isLessonComplete)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: _currentLetterIndex > 0
                          ? widget.lesson.primaryColor
                          : Colors.grey,
                    ),
                    onPressed: _currentLetterIndex > 0
                        ? () {
                            setState(() {
                              _currentLetterIndex--;
                            });
                          }
                        : null,
                  ),

                  // Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.lesson.letters.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentLetterIndex
                                ? widget.lesson.primaryColor
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Next/Complete Button
                  IconButton(
                    icon: Icon(
                      _currentLetterIndex < widget.lesson.letters.length - 1
                          ? Icons.arrow_forward
                          : Icons.check_circle,
                      size: 40,
                      color: widget.lesson.primaryColor,
                    ),
                    onPressed: () {
                      if (_currentLetterIndex <
                          widget.lesson.letters.length - 1) {
                        setState(() {
                          _currentLetterIndex++;
                        });
                      } else {
                        // Complete the lesson
                        setState(() {
                          _isLessonComplete = true;
                        });
                        widget.onLessonComplete();
                        ProgressService().completeLesson(widget.lesson.id);
                      }
                    },
                  ),
                ],
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
