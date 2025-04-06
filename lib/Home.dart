import 'package:flutter/material.dart';
import 'SchoolPage.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(userName, style: const TextStyle(color: Colors.white)),
            const Text('Language >', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: Container(
        color: Colors.lightGreenAccent,
        child: Column(
          children: [
            Container(
              height: 60,
              color: Colors.lightGreen,
              child: const Center(
                child: Text(
                  'MY First Words',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  PushableButton(
                    label: 'School',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolPage(userName: userName),
                        ),
                      );
                    },
                  ),
                  PushableButton(
                    label: 'Games',
                    onPressed: () {},
                  ),
                  PushableButton(
                    label: 'Translate',
                    onPressed: () {},
                  ),
                  PushableButton(
                    label: 'Stories',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              color: Colors.orange,
              child: const Center(
                child: Icon(Icons.home, size: 50, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PushableButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PushableButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.greenAccent.withOpacity(0.5), Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // shadow position
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
