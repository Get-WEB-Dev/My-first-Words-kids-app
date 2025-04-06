import 'package:flutter/material.dart';

class Lesson {
  final int id;
  final String title;
  final String type; // 'lesson' or 'quiz'
  final List<String> letters;
  final List<QuizQuestion>? questions;
  final Color primaryColor;
  final Color secondaryColor;

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.letters,
    this.questions,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      letters: (json['letters'] as List).map((l) => l.toString()).toList(),
      questions: json['type'] == 'quiz'
          ? (json['questions'] as List)
              .map((q) => QuizQuestion.fromJson(q))
              .toList()
          : null,
      primaryColor: _parseColor(json['primaryColor']),
      secondaryColor: _parseColor(json['secondaryColor']),
    );
  }

  static Color _parseColor(String hexColor) {
    return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'],
      options: (json['options'] as List).map((o) => o.toString()).toList(),
      correctAnswer: json['correctAnswer'],
    );
  }
}
