import 'package:flutter/material.dart';

class AlphabetPage extends StatefulWidget {
  const AlphabetPage({super.key});

  @override
  _AlphabetPageState createState() => _AlphabetPageState();
}

class _AlphabetPageState extends State<AlphabetPage> {
  int _index = 0; // To track the current letter index
  final List<String> _alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];

  void _next() {
    setState(() {
      if (_index < _alphabets.length - 1) {
        _index++;
      }
    });
  }

  void _previous() {
    setState(() {
      if (_index > 0) {
        _index--;
      }
    });
  }

  void _toggleVolume() {
    // Handle volume logic here (e.g., toggle sound)
    print("Volume toggled");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alphabet Learning")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _alphabets[_index],
            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _previous,
                child: const Text("Previous"),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _next,
                child: const Text("Next"),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: _toggleVolume,
                iconSize: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
