import 'package:flutter/material.dart';

class Lesson {
  final int id;
  final String title;
  final String type; // 'lesson' or 'quiz'
  final String category; // Alphabet, Numbers, etc.
  int quarter;
  String level; // Nursery, LKG, UKG
  String language; // English, Amharic, Afaan Oromo
  List<String> letters;
  final List<String>? words; // Words for each letter
  final List<String>? sentences; // Example sentences
  final List<QuizQuestion>? questions;
  final Color primaryColor;
  final Color secondaryColor;
  final String? content;
  final String? image; // Optional image path
  final String? audio; // Optional audio path
  final String? promptAudio; // Optional audio path
  final String fontFamily; // Font for displaying letters
  final List<String>? numbers; // For number lessons

  Lesson({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.quarter,
    required this.level,
    required this.language,
    required this.letters,
    this.words,
    this.sentences,
    this.questions,
    required this.primaryColor,
    required this.secondaryColor,
    this.content,
    this.image,
    this.audio,
    this.promptAudio,
    this.fontFamily = 'ComicNeue',
    required this.numbers, // <-- Mark as required
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      category: json['category'] ?? 'General',
      quarter: json['quarter'] ?? 1,
      level: json['level'] ?? 'Nursery',
      language: json['language'] ?? 'English',
      letters:
          (json['letters'] as List? ?? []).map((l) => l.toString()).toList(),
      words: (json['words'] as List?)?.map((w) => w.toString()).toList(),
      sentences:
          (json['sentences'] as List?)?.map((s) => s.toString()).toList(),
      questions: json['type'] == 'quiz'
          ? (json['questions'] as List?)
              ?.map((q) => QuizQuestion.fromJson(q))
              .toList()
          : null,
      primaryColor: _parseColor(json['primaryColor'] ?? '#FF5252'),
      secondaryColor: _parseColor(json['secondaryColor'] ?? '#FFCDD2'),
      content: json['content'],
      image: json['image'],
      audio: json['audio'],
      promptAudio: json['promptAudio'],
      fontFamily: json['fontFamily'] ?? 'ComicNeue',
      numbers:
          (json['numbers'] as List? ?? []).map((n) => n.toString()).toList(),
    );
  }

  static Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceFirst('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.blue; // Default color if parsing fails
    }
  }

  bool isFromQuarter(int quarterNumber) => quarter == quarterNumber;
}

class QuizQuestion {
  final String type; // 'tap_letter' or other question types
  final String prompt;
  final String? image;
  final String? promptAudio;
  final List<String>? letters;
  final int? correctIndex;
  final String? question; // For backward compatibility
  final List<String>? options; // For backward compatibility
  final dynamic correctAnswer; // For backward compatibility

  QuizQuestion({
    required this.type,
    required this.prompt,
    this.image,
    this.promptAudio,
    this.letters,
    this.correctIndex,
    this.question,
    this.options,
    this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      type: json['type'] ?? 'tap_letter',
      prompt: json['prompt'] ?? json['question'] ?? '',
      image: json['image'],
      promptAudio: json['promptAudio'] ?? json['audio'],
      letters: (json['letters'] as List?)?.map((l) => l.toString()).toList(),
      correctIndex: json['correctIndex'] ?? json['correctAnswer'],
      question: json['question'], // For backward compatibility
      options: (json['options'] as List?)
          ?.map((o) => o.toString())
          .toList(), // For backward compatibility
      correctAnswer: json['correctAnswer'], // For backward compatibility
    );
  }
}
