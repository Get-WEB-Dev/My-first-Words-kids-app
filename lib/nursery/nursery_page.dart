import 'package:flutter/material.dart';
import 'lesson_page.dart';

class NurseryPage extends StatelessWidget {
  const NurseryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nursery Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Lesson Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LessonPage()),
            );
          },
          child: const Text("Go to Lesson Page"),
        ),
      ),
    );
  }
}
