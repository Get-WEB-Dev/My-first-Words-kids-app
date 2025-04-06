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
      height: 100,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 143, 6, 17),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFFFA726), // Top part of border (original yellow)
            width: 3, // Half of original 6px
          ),
        ),
        boxShadow: [
          // This creates the darker bottom border effect
          BoxShadow(
            color: Color(0xFFFF8F00), // Darker yellow
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 3), // Positions directly below the main border
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: ImageButton(
                  image: backButtonImage,
                  onPressed: onBackPressed,
                  size: 58,
                ),
              ),
              if (middleWidget != null) middleWidget!,
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: ImageButton(
                  image: settingsButtonImage,
                  onPressed: onSettingsPressed,
                  size: 58,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class ImageButton extends StatelessWidget {
  final ImageProvider image;
  final double size;
  final VoidCallback? onPressed;
  final Color? tintColor;

  const ImageButton({
    super.key,
    required this.image,
    this.size = 58.0,
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
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
