import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../School/Nursery/English/Quarter 1/services.dart';

class ProgressServices {
  // File storage constants
  static const _progressFileName = 'quiz_progress.json';

  // Progress data structure
  static ProgressData _progressData = ProgressData.empty();

  // Initialize the service
  static Future<void> initialize() async {
    _progressData = await _loadProgress();
  }

  Future<void> resetQuizProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) =>
            key.startsWith('quiz_score_') ||
            key.startsWith('total_questions_') ||
            key.startsWith('quiz_title_') ||
            key.startsWith('quiz_category_') ||
            key.startsWith('quiz_completed_'))
        .toList();

    for (var key in keys) {
      await prefs.remove(key);
    }
    debugPrint('Cleared ${keys.length} quiz-related keys');
  }

  // Get the progress file
  static Future<File> get _progressFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_progressFileName');
  }

  // Load progress from file
  static Future<ProgressData> _loadProgress() async {
    try {
      final file = await _progressFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents) as Map<String, dynamic>;
        return ProgressData.fromJson(jsonData);
      }
    } catch (e) {
      print('Error loading progress: $e');
    }
    return ProgressData.empty();
  }

  Future<Map<String, double>> getCategoryProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final items = await DataService.loadAllItems();
    final quizzes = items.where((item) => item.type == 'quiz').toList();

    final categoryProgress = <String, double>{};
    final categoryStats = <String, List<int>>{};

    // Calculate scores per category
    for (var quiz in quizzes) {
      final category = quiz.category ?? 'Uncategorized';
      final score = prefs.getInt('quiz_score_${quiz.id}') ?? 0;
      final total = quiz.questions?.length ?? 1;

      if (!categoryStats.containsKey(category)) {
        categoryStats[category] = [0, 0];
      }
      categoryStats[category]![0] += score;
      categoryStats[category]![1] += total;
    }

    // Calculate percentages
    categoryStats.forEach((category, stats) {
      categoryProgress[category] = stats[1] > 0 ? stats[0] / stats[1] : 0;
    });

    return categoryProgress;
  }

  // Save progress to file
  static Future<void> _saveProgress() async {
    try {
      final file = await _progressFile;
      await file.writeAsString(jsonEncode(_progressData.toJson()));
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  // Public API
  static Future<void> saveQuizResult({
    required String quizId,
    required String category,
    required int totalQuestions,
    required int correctAnswers,
  }) async {
    _progressData.updateQuizResult(
      quizId: quizId,
      category: category,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
    );
    await _saveProgress();
  }

  static double getCategoryMastery(String category) {
    return _progressData.getCategoryMastery(category);
  }

  static double getOverallMastery() {
    return _progressData.getOverallMastery();
  }

  static List<String> getCompletedQuizzes() {
    return _progressData.getCompletedQuizzes();
  }

  static Future<void> resetAllProgress() async {
    _progressData = ProgressData.empty();
    await _saveProgress();
  }

  // Debugging
  static void printProgress() {
    print('Current Progress:');
  }
}

// Data model for progress tracking
class ProgressData {
  final Map<String, QuizResult> quizResults;
  DateTime lastUpdated;

  ProgressData({
    required this.quizResults,
    required this.lastUpdated,
  });

  factory ProgressData.empty() {
    return ProgressData(
      quizResults: {},
      lastUpdated: DateTime.now(),
    );
  }

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    final results = <String, QuizResult>{};
    (json['quizResults'] as Map<String, dynamic>).forEach((key, value) {
      results[key] = QuizResult.fromJson(value);
    });

    return ProgressData(
      quizResults: results,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    final resultsJson = {};
    quizResults.forEach((key, value) {
      resultsJson[key] = value.toJson();
    });

    return {
      'quizResults': resultsJson,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Business logic
  void updateQuizResult({
    required String quizId,
    required String category,
    required int totalQuestions,
    required int correctAnswers,
  }) {
    quizResults[quizId] = QuizResult(
      quizId: quizId,
      category: category,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      lastAttempt: DateTime.now(),
    );
    lastUpdated = DateTime.now();
  }

  double getCategoryMastery(String category) {
    int total = 0;
    int correct = 0;

    quizResults.values.where((r) => r.category == category).forEach((result) {
      total += result.totalQuestions;
      correct += result.correctAnswers;
    });

    return total > 0 ? correct / total : 0.0;
  }

  double getOverallMastery() {
    int total = 0;
    int correct = 0;

    for (var result in quizResults.values) {
      total += result.totalQuestions;
      correct += result.correctAnswers;
    }

    return total > 0 ? correct / total : 0.0;
  }

  List<String> getCompletedQuizzes() {
    return quizResults.keys.toList();
  }
}

// Individual quiz result model
class QuizResult {
  final String quizId;
  final String category;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime lastAttempt;

  QuizResult({
    required this.quizId,
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.lastAttempt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      quizId: json['quizId'],
      category: json['category'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      lastAttempt: DateTime.parse(json['lastAttempt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'category': category,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'lastAttempt': lastAttempt.toIso8601String(),
    };
  }

  double get scorePercentage {
    return totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
  }

  // Add this method to your ProgressService class
}
