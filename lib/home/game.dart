import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class WordPuzzleGame extends StatefulWidget {
  const WordPuzzleGame({super.key});

  @override
  _WordPuzzleGameState createState() => _WordPuzzleGameState();
}

class _WordPuzzleGameState extends State<WordPuzzleGame> {
  // Kid-friendly word bank
  final List<String> wordBank = [
    'apple',
    'ball',
    'cat',
    'dog',
    'egg',
    'fish',
    'goat',
    'hat',
    'ice',
    'jump',
    'kite',
    'lion',
    'milk',
    'nest',
    'owl',
    'pig',
    'queen',
    'rain',
    'sun',
    'tree'
  ];

  String currentWord = '';
  List<String> scrambledWord = [];
  List<String> userAnswer = [];
  int score = 0;
  int level = 1;
  final AudioPlayer successPlayer = AudioPlayer();
  final AudioPlayer clickPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadSounds();
    _newPuzzle();
  }

  Future<void> _loadSounds() async {
    await successPlayer.setSource(AssetSource('audio/success.mp3'));
    await clickPlayer.setSource(AssetSource('audio/click.mp3'));
  }

  void _newPuzzle() {
    final random = Random();
    setState(() {
      currentWord = wordBank[random.nextInt(wordBank.length)];
      scrambledWord = currentWord.split('')..shuffle();
      userAnswer = List.filled(currentWord.length, '');
    });
  }

  void _letterSelected(int index) {
    clickPlayer.play(AssetSource('audio/click.mp3'));

    // Find first empty spot in user answer
    final emptyIndex = userAnswer.indexWhere((letter) => letter.isEmpty);
    if (emptyIndex != -1) {
      setState(() {
        userAnswer[emptyIndex] = scrambledWord[index];
        scrambledWord[index] = '';
      });

      _checkAnswer();
    }
  }

  void _checkAnswer() {
    if (!userAnswer.any((letter) => letter.isEmpty)) {
      if (userAnswer.join() == currentWord) {
        successPlayer.play(AssetSource('audio/success.mp3'));
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            score += level * 10;
            level++;
            _newPuzzle();
          });
        });
      }
    }
  }

  void _clearLetter(int index) {
    if (userAnswer[index].isNotEmpty) {
      clickPlayer.play(AssetSource('audio/click.mp3'));
      setState(() {
        final letter = userAnswer[index];
        final emptyScrambleIndex = scrambledWord.indexWhere((l) => l.isEmpty);
        if (emptyScrambleIndex != -1) {
          scrambledWord[emptyScrambleIndex] = letter;
          userAnswer[index] = '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Puzzle Fun'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text('$score', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Level indicator
            Text('Level $level',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Word image (placeholder)
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  '🖼️', // Replace with actual image widget
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User's answer slots
            Wrap(
              spacing: 10,
              children: List.generate(
                currentWord.length,
                (index) => _buildLetterSlot(index, userAnswer[index]),
              ),
            ),
            const SizedBox(height: 30),

            // Scrambled letters
            const Text('Arrange the letters:',
                style: TextStyle(fontSize: 18, color: Colors.deepPurple)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: List.generate(
                scrambledWord.length,
                (index) => scrambledWord[index].isNotEmpty
                    ? _buildLetterButton(index, scrambledWord[index])
                    : const SizedBox(width: 50, height: 50),
              ),
            ),
            const SizedBox(height: 20),

            // Clear button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scrambledWord = currentWord.split('')..shuffle();
                  userAnswer = List.filled(currentWord.length, '');
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
              ),
              child: const Text('Start Over'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterSlot(int index, String letter) {
    return GestureDetector(
      onTap: () => _clearLetter(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: letter.isEmpty ? Colors.grey[200] : Colors.lightGreen[200],
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterButton(int index, String letter) {
    return GestureDetector(
      onTap: () => _letterSelected(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.amber[100],
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    successPlayer.dispose();
    clickPlayer.dispose();
    super.dispose();
  }
}
