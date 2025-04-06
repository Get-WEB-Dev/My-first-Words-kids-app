import 'package:flutter/material.dart';
import 'dart:math' as math;

class AlphabetPage extends StatefulWidget {
  final String userName;
  final String alphabet;

  const AlphabetPage(
      {required this.userName, required this.alphabet, super.key});

  @override
  _AlphabetPageState createState() => _AlphabetPageState();
}

class _AlphabetPageState extends State<AlphabetPage>
    with SingleTickerProviderStateMixin {
  String _currentAlphabet = '';
  int _alphabetIndex = 0;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  final List<String> _alphabets = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  void initState() {
    super.initState();
    _currentAlphabet = widget.alphabet;
    _alphabetIndex = _alphabets.indexOf(_currentAlphabet);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateAlphabet(int direction) {
    if (direction == 1 && _alphabetIndex < _alphabets.length - 1) {
      _alphabetIndex++;
    } else if (direction == -1 && _alphabetIndex > 0) {
      _alphabetIndex--;
    } else {
      return;
    }

    _controller.forward(from: 0).then((_) {
      setState(() {
        _currentAlphabet = _alphabets[_alphabetIndex];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Alphabets'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Settings'),
                  content: const Text('Settings options will go here.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () => print('Play Sound button clicked'),
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final isFront = _flipAnimation.value < math.pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_flipAnimation.value),
                    child: isFront
                        ? AlphabetCard(alphabet: _currentAlphabet)
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: const AlphabetCard(alphabet: ''),
                          ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () => _navigateAlphabet(-1),
                iconSize: 40,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () => _navigateAlphabet(1),
                iconSize: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AlphabetCard extends StatelessWidget {
  final String alphabet;

  const AlphabetCard({required this.alphabet, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      alignment: Alignment.center,
      color: Colors.blue.shade100,
      child: Text(
        alphabet,
        style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
      ),
    );
  }
}
