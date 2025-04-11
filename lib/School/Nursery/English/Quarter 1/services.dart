import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'lesson.dart';

class DataService {
  // Maintain backward compatibility - default to Nursery/English
  static Future<List<Lesson>> loadAllItems() async {
    return loadAllItemsForLevelAndLanguage('Nursery', 'English');
  }

  // New explicit method for level/language
  static Future<List<Lesson>> loadAllItemsForLevelAndLanguage(
      String level, String language) async {
    final quarters = await loadAllQuarters(level, language);
    return quarters.values.expand((lessons) => lessons).toList();
  }

  static Future<Map<int, List<Lesson>>> loadAllQuarters(
      String level, String language) async {
    final Map<int, List<Lesson>> quarters = {};

    for (int quarter = 1; quarter <= 4; quarter++) {
      try {
        final jsonString = await rootBundle.loadString(
          'assets/home/$level/$language/Quarter_$quarter/lessons.json',
        );
        final jsonData = json.decode(jsonString);

        if (jsonData is List) {
          quarters[quarter] = jsonData.map((item) {
            final lesson = Lesson.fromJson(item);
            lesson.level = level;
            lesson.language = language;
            lesson.quarter = quarter;
            return lesson;
          }).toList();
        }
      } catch (e) {
        debugPrint('Error loading $level/$language Quarter $quarter: $e');
        quarters[quarter] = [];
      }
    }
    return quarters;
  }

  // Deprecated - use loadAllItemsForLevelAndLanguage instead
  static Future<List<Lesson>> loadAllQuartersItems() async {
    debugPrint('Warning: loadAllQuartersItems() is deprecated');
    return loadAllItems();
  }

  // Updated to accept level/language parameters
  static Future<Map<String, List<Lesson>>> getQuizzesByCategory(
      [String level = 'Nursery', String language = 'English']) async {
    try {
      final items = await loadAllItemsForLevelAndLanguage(level, language);
      final quizzes = items.where((item) => item.type == 'quiz').toList();

      debugPrint('Found ${quizzes.length} quizzes in $level/$language');
      final categories = <String, List<Lesson>>{};
      for (var quiz in quizzes) {
        final category = quiz.category ?? 'Uncategorized';
        categories.putIfAbsent(category, () => []).add(quiz);
      }
      return categories;
    } catch (e) {
      debugPrint('Error getting quizzes by category: $e');
      return {};
    }
  }

  // Debug methods remain the same
  static Future<void> debugPrintAllQuizScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .where((key) => key.startsWith('quiz_score_'))
          .toList();

      debugPrint('===== QUIZ SCORES DEBUG =====');
      debugPrint('Found ${keys.length} saved quiz scores');

      if (keys.isEmpty) {
        debugPrint('No quiz scores found in SharedPreferences');
        return;
      }

      for (var key in keys) {
        final quizId = key.replaceFirst('quiz_score_', '');
        final score = prefs.getInt(key);
        final totalQuestions = prefs.getInt('total_questions_$quizId') ?? 0;
        final title = prefs.getString('quiz_title_$quizId') ?? 'Unknown Quiz';
        final category =
            prefs.getString('quiz_category_$quizId') ?? 'Uncategorized';

        debugPrint('Quiz ID: $quizId');
        debugPrint('Title: $title');
        debugPrint('Category: $category');
        debugPrint('Score: $score/$totalQuestions');
        debugPrint('----------------------');
      }
    } catch (e) {
      debugPrint('Error debugging quiz scores: $e');
    }
  }

  static Future<void> debugPrintQuizData(int quizId) async {
    final idString = quizId.toString();
    final prefs = await SharedPreferences.getInstance();
    debugPrint('===== QUIZ $idString DEBUG INFO =====');
    debugPrint('Score: ${prefs.getInt('quiz_score_$idString')}');
    debugPrint('Title: ${prefs.getString('quiz_title_$idString')}');
    debugPrint('Category: ${prefs.getString('quiz_category_$idString')}');
    debugPrint('Completed: ${prefs.getBool('quiz_completed_$idString')}');
    debugPrint('Total questions: ${prefs.getInt('total_questions_$idString')}');
  }
}
