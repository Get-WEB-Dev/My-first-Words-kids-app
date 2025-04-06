import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Add your button action here
        print('Floating Action Button Pressed');
      },
      child: const Icon(Icons.add),
    );
  }
}
