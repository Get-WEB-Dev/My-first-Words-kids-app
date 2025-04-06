import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onSettingsPressed;
  final ImageProvider backButtonImage;
  final ImageProvider settingsButtonImage;
  final String? title;
  final Widget? middleWidget;

  const CustomNavbar({
    super.key,
    required this.onBackPressed,
    required this.onSettingsPressed,
    required this.backButtonImage,
    required this.settingsButtonImage,
    this.title,
    this.middleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E88E5), // Dark blue background
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFFFA726), // Orange underline
            width: 4,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SafeArea(
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              ImageButton(
                image: backButtonImage,
                onPressed: onBackPressed,
                size: 40.0,
              ),

              // Middle title or custom widget
              middleWidget ??
                  (title != null
                      ? Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const SizedBox.shrink()),

              // Settings button
              ImageButton(
                image: settingsButtonImage,
                onPressed: onSettingsPressed,
                size: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ImageButton extends StatelessWidget {
  final ImageProvider image;
  final double size;
  final VoidCallback? onPressed;
  final Color? tintColor;

  const ImageButton({
    super.key,
    required this.image,
    this.size = 40.0,
    this.onPressed,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: image,
            fit: BoxFit.contain,
            colorFilter: tintColor != null
                ? ColorFilter.mode(tintColor!, BlendMode.srcIn)
                : null,
          ),
        ),
      ),
    );
  }
}
