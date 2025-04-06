import 'package:flutter/material.dart';
import 'package:gech/nursery/nursery_page.dart'; // Import the nursery page
import 'package:shared_preferences/shared_preferences.dart';

class ClassSelectionPage extends StatefulWidget {
  const ClassSelectionPage({super.key});

  @override
  State<ClassSelectionPage> createState() => _ClassSelectionPageState();
}

class _ClassSelectionPageState extends State<ClassSelectionPage> {
  bool isNurseryCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadProgress(); // Load the saved progress
  }

  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNurseryCompleted = prefs.getBool('nursery_completed') ?? false;
    });
  }

  void _showLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Finish Nursery first!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Class")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClassButton(
              title: "Nursery",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NurseryPage()),
                );
              },
            ),
            ClassButton(
              title: "LKG",
              onPressed: isNurseryCompleted ? () {} : _showLockedMessage,
              isLocked: !isNurseryCompleted,
            ),
            ClassButton(
              title: "UKG",
              onPressed: isNurseryCompleted ? () {} : _showLockedMessage,
              isLocked: !isNurseryCompleted,
            ),
          ],
        ),
      ),
    );
  }
}

class ClassButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLocked;

  const ClassButton({
    required this.title,
    required this.onPressed,
    this.isLocked = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLocked ? Colors.grey : Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        child: Text(title),
      ),
    );
  }
}
