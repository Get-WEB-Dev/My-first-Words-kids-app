import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const _completedKey = 'completed_lessons';
  static const _currentIndexKey = 'current_index';

  Future<List<int>> getCompletedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_completedKey) ?? [];
    return completed.map(int.parse).toList();
  }

  Future<int> getCurrentLessonIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentIndexKey) ?? 0;
  }

  Future<void> completeLesson(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = await getCompletedLessons();
    if (!completed.contains(id)) {
      completed.add(id);
      await prefs.setStringList(
        _completedKey,
        completed.map((id) => id.toString()).toList(),
      );
    }
  }

  Future<void> setCurrentLessonIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentIndexKey, index);
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_completedKey);
    await prefs.setInt(_currentIndexKey, 0);
  }

  Future<void> unlockLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    switch (level) {
      case 'Nursery':
        await prefs.setBool('LKG_unlocked', true);
        break;
      case 'LKG':
        await prefs.setBool('UKG_unlocked', true);
        break;
    }
  }

  Future<bool> isLevelUnlocked(String level) async {
    final prefs = await SharedPreferences.getInstance();
    if (level == 'Nursery') return true;
    return prefs.getBool('${level}_unlocked') ?? false;
  }
}
