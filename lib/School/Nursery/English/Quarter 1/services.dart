import 'package:flutter/services.dart';
import 'dart:convert';
import 'lesson.dart';

class DataService {
  static Future<List<Lesson>> loadAllItems() async {
    try {
      final jsonString = await rootBundle
          .loadString('assets/home/Nursery/English/Quarter_1/lessons.json');
      final jsonData = json.decode(jsonString);

      if (jsonData is List) {
        return jsonData.map((item) => Lesson.fromJson(item)).toList();
      }
      throw const FormatException('Invalid JSON format');
    } catch (e) {
      // debugPrint('Error loading lessons: $e');
      return [];
    }
  }
}
