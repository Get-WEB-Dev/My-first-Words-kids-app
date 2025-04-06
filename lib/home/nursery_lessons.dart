// lib/lessons/nursery_lessons.dart
class NurseryLessons {
  static Map<int, Map<String, dynamic>> lessons = {
    1: {
      'title': 'Letters A-E',
      'type': 'alphabet',
      'content': [
        {'letter': 'A', 'word': 'Apple', 'image': 'assets/apple.png'},
        {'letter': 'B', 'word': 'Ball', 'image': 'assets/ball.png'},
        {'letter': 'C', 'word': 'Cat', 'image': 'assets/cat.png'},
        {'letter': 'D', 'word': 'Dog', 'image': 'assets/dog.png'},
        {'letter': 'E', 'word': 'Elephant', 'image': 'assets/elephant.png'},
      ],
      'completionMessage': 'Great job learning A-E!'
    },
    2: {
      'title': 'Letters F-J',
      'type': 'alphabet',
      'content': [
        {'letter': 'F', 'word': 'Fish', 'image': 'assets/fish.png'},
        // ... other letters
      ],
      'completionMessage': 'Awesome work with F-J!'
    },
    // ... add up to Lesson 10
  };
}