import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.quiz.questions!.length, null);
    _playQuestionAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playQuestionAudio() async {
    final currentQuestion = widget.quiz.questions![_currentQuestionIndex];
    if (currentQuestion.promptAudio == null) return;

    try {
      // Set audio context for physical device
      await _audioPlayer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            contentType: AndroidContentType.music,
            // usage: AndroidUsage.media,
            audioFocus: AndroidAudioFocus.gainTransient,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: [AVAudioSessionOptions.mixWithOthers],
          ),
        ),
      );

      await _audioPlayer.stop(); // Clear previous playback
      await _audioPlayer.setVolume(1.0); // Max volume
      await _audioPlayer.play(AssetSource(currentQuestion.promptAudio!));

      debugPrint('✅ Playing: ${currentQuestion.promptAudio}');
    } catch (e) {
      debugPrint('❌ Audio error: $e');
    }
  }

  void _completeQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quiz_score_${widget.quiz.id}', _score);
    widget.onComplete();
    Navigator.pop(context, _score);
  }

  Future<void> _answerQuestion(int selectedIndex) async {
    final isCorrect = selectedIndex ==
        widget.quiz.questions![_currentQuestionIndex].correctIndex;

    final prefs = await SharedPreferences.getInstance();
    final quizResults =
        prefs.getStringList('quiz_results_${widget.quiz.id}') ?? [];
    quizResults.add(isCorrect ? '1' : '0');
    await prefs.setStringList('quiz_results_${widget.quiz.id}', quizResults);

    setState(() {
      _selectedAnswers[_currentQuestionIndex] = selectedIndex;

      if (isCorrect) {
        _score++;
      }

      if (_currentQuestionIndex < widget.quiz.questions!.length - 1) {
        _currentQuestionIndex++;
        _playQuestionAudio(); // Play audio for next question
      } else {
        _quizCompleted = true;
        _completeQuiz();
      }
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _playQuestionAudio(); // Play audio for previous question
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
                  : _buildTapLetterQuestion(currentQuestion),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapLetterQuestion(QuizQuestion question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Audio Play Button
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.volume_up : Icons.volume_up_outlined,
            size: 40,
            color: widget.quiz.primaryColor,
          ),
          onPressed: _isPlaying ? null : _playQuestionAudio,
        ),
        const SizedBox(height: 10),

        // Prompt Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            question.prompt,
            style: GoogleFonts.comicNeue(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Image (if available)
        if (question.image != null && question.image!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Image.asset(
              question.image!,
              height: 150,
            ),
          ),

        // Letter Options
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            padding: const EdgeInsets.all(20),
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: List.generate(question.letters!.length, (index) {
              final isSelected =
                  _selectedAnswers[_currentQuestionIndex] == index;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? widget.quiz.primaryColor.withOpacity(0.8)
                      : widget.quiz.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _answerQuestion(index),
                child: Text(
                  question.letters![index],
                  style: GoogleFonts.comicNeue(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }),
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
