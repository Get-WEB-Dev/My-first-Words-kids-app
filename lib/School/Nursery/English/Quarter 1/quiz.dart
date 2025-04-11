import 'package:flutter/material.dart';

class Quiz {
  final int id;
  final String title;
  final String category; // New field
  final List<QuizQuestion> questions;
  final Color primaryColor;
  final Color secondaryColor;

  Quiz({
    required this.id,
    required this.title,
    required this.category, // Added to constructor
    required this.questions,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      category: json['category'] ?? 'General', // Default category
      questions: (json['questions'] as List)
          .map((question) => QuizQuestion.fromJson(question))
          .toList(),
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
  final String image;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.image,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      image: json['image'],
    );
  }
}
