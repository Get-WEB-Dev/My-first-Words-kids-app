import 'package:flutter/material.dart';

class BottomNavigationButtons extends StatefulWidget {
  final int initialIndex;
  final Function(int) onTabChanged;

  const BottomNavigationButtons({
    super.key,
    this.initialIndex = 1, // Default to Home as active
    required this.onTabChanged,
  });

  @override
  _BottomNavigationButtonsState createState() =>
      _BottomNavigationButtonsState();
}

class _BottomNavigationButtonsState extends State<BottomNavigationButtons> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildImageButton(
            imageAsset: 'assets/home/Button.png',
            isActive: _selectedIndex == 0,
            onTap: () => _updateIndex(0),
          ),
          _buildImageButton(
            imageAsset: 'assets/home/home_icon.png',
            isActive: _selectedIndex == 1,
            onTap: () => _updateIndex(1),
          ),
          _buildImageButton(
            imageAsset: 'assets/home/Button1.png',
            isActive: _selectedIndex == 2,
            onTap: () => _updateIndex(2),
          ),
        ],
      ),
    );
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onTabChanged(index);
  }

  Widget _buildImageButton({
    required String imageAsset,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: isActive ? 100 : 80,
        height: isActive ? 100 : 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.2, -0.2),
            radius: isActive ? 1.2 : 0.9,
            colors: isActive
                ? [
                    const Color(0xFFFFA726), // Active - Orange
                    const Color(0xFFFB8C00),
                  ]
                : [
                    const Color.fromARGB(255, 83, 157, 226), // Inactive - Blue
                    const Color(0xFF42A5F5),
                  ],
            stops: const [0.1, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isActive ? 0.35 : 0.25),
              blurRadius: isActive ? 15 : 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: isActive ? const Color(0xFFE65100) : const Color(0xFFD6891D),
            width: isActive ? 8 : 6,
          ),
        ),
        child: Stack(
          children: [
            // Glossy highlight
            Positioned(
              top: isActive ? 8 : 5,
              left: isActive ? 8 : 5,
              child: Container(
                width: isActive ? 70 : 60,
                height: isActive ? 70 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.4, -0.4),
                    radius: 0.6,
                    colors: [
                      Colors.white.withOpacity(isActive ? 0.95 : 0.9),
                      Colors.white.withOpacity(isActive ? 0.2 : 0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Image
            Center(
              child: Image.asset(
                imageAsset,
                width: isActive ? 100 : 90,
                height: isActive ? 100 : 90,
                // color: isActive ? Colors.white : Colors.white.withOpacity(0.9),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
