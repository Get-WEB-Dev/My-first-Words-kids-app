import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<File> get _profileFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/user_profile.json');
  }

  static Future<bool> get hasProfile async {
    final file = await _profileFile;
    return file.exists();
  }

  static Future<Map<String, dynamic>> loadProfile() async {
    try {
      final file = await _profileFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        return jsonDecode(contents);
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
    return {
      'name': 'Guest',
      'profileImagePath': 'assets/avatars/avatar1.png',
      'fullName': 'New User',
      'age': '5',
      'level': 'Kindergarten',
      'isSetupComplete': false
    };
  }

  static Future<void> saveProfile({
    required String name,
    required String imagePath,
    String fullName = 'New User',
    String age = '5',
    String level = 'Kindergarten',
  }) async {
    final file = await _profileFile;
    await file.writeAsString(jsonEncode({
      'name': name,
      'profileImagePath': imagePath,
      'fullName': fullName,
      'age': age,
      'level': level,
      'isSetupComplete': true,
    }));
  }

  static Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    final file = await _profileFile;
    if (await file.exists()) {
      final currentData = jsonDecode(await file.readAsString());
      // Update all fields from the new data
      currentData['name'] = updatedData['name'];
      currentData['profileImagePath'] = updatedData['profileImagePath'];
      currentData['fullName'] = updatedData['fullName'];
      currentData['age'] = updatedData['age'];
      currentData['level'] = updatedData['level'];
      await file.writeAsString(jsonEncode(currentData));
    }
  }

  static Future<void> resetProfile() async {
    final file = await _profileFile;
    if (await file.exists()) {
      await file.delete();
    }
  }
}
