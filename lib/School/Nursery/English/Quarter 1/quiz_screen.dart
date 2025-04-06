import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lesson.dart';

class QuizScreen extends StatefulWidget {
  final Lesson quiz;
  final VoidCallback onComplete;

  const QuizScreen({
    super.key,
    required this.quiz,
    required this.onComplete,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<int?> _selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.quiz.questions!.length, null);
  }

  void _answerQuestion(int selectedIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = selectedIndex;

      if (selectedIndex ==
          widget.quiz.questions![_currentQuestionIndex].correctAnswer) {
        _score++;
      }

      if (_currentQuestionIndex < widget.quiz.questions!.length - 1) {
        _currentQuestionIndex++;
      } else {
        _quizCompleted = true;
        widget.onComplete();
      }
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quiz.questions![_currentQuestionIndex];
    final progress =
        (_currentQuestionIndex + 1) / widget.quiz.questions!.length;

    return Scaffold(
      backgroundColor: widget.quiz.secondaryColor,
      appBar: AppBar(
        backgroundColor: widget.quiz.primaryColor,
        title: Text(
          widget.quiz.title,
          style: GoogleFonts.comicNeue(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(widget.quiz.primaryColor),
            minHeight: 10,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _quizCompleted
                  ? _buildResults()
                  : _buildQuestion(currentQuestion),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(QuizQuestion question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Question Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Text(
            question.question,
            style: GoogleFonts.comicNeue(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Options
        Expanded(
          child: ListView.builder(
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              final isSelected =
                  _selectedAnswers[_currentQuestionIndex] == index;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? widget.quiz.primaryColor.withOpacity(0.8)
                        : widget.quiz.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _answerQuestion(index),
                  child: Text(
                    question.options[index],
                    style: GoogleFonts.comicNeue(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Navigation buttons
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentQuestionIndex > 0)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _previousQuestion,
                  child: Text(
                    "Back",
                    style: GoogleFonts.comicNeue(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                "Question ${_currentQuestionIndex + 1}/${widget.quiz.questions!.length}",
                style: GoogleFonts.comicNeue(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final percentage = (_score / widget.quiz.questions!.length) * 100;
    String message;
    Color messageColor;
    String emoji;

    if (percentage >= 80) {
      message = 'Awesome!';
      messageColor = Colors.green;
      emoji = '🎉';
    } else if (percentage >= 60) {
      message = 'Good Job!';
      messageColor = Colors.orange;
      emoji = '👍';
    } else {
      message = 'Keep Practicing!';
      messageColor = Colors.red;
      emoji = '💪';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Quiz Completed!",
            style: GoogleFonts.comicNeue(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: widget.quiz.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Your Score:",
            style: GoogleFonts.comicNeue(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$_score/${widget.quiz.questions!.length}",
            style: GoogleFonts.comicNeue(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: widget.quiz.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: GoogleFonts.comicNeue(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: messageColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.quiz.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back to Lessons',
              style: GoogleFonts.comicNeue(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
