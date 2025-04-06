import 'package:flutter/material.dart';
import 'alphabet_page.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lesson Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Alphabet Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AlphabetPage()),
            );
          },
          child: const Text("Go to Alphabet Lesson"),
        ),
      ),
    );
  }
}
