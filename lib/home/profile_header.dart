import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cartoon_button.dart';
import 'dart:io';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String profileImagePath; // Contains either asset path or file path
  final VoidCallback onResetPressed;
  final VoidCallback onProfileTap; // Add this callback
  final double avatarRadius = 32.0;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.profileImagePath,
    required this.onResetPressed,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final nameBubbleHeight = avatarRadius * 4;
    const nameBubbleWidth = 180.0;
    const avatarToTextPadding = 45.0;
    const avatarBackgroundPadding = 8.0;

    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: SizedBox(
        height: avatarRadius * 2 + 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onProfileTap, // Combined Avatar + Name Bubble
              child: SizedBox(
                height: avatarRadius * 2 + 1,
                width: nameBubbleWidth + avatarRadius + avatarToTextPadding,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Name Bubble with Image Background
                    Positioned(
                      left: avatarRadius - 1,
                      top: (avatarRadius * 2 - nameBubbleHeight) / 2.3,
                      child: Container(
                        width: nameBubbleWidth,
                        height: nameBubbleHeight,
                        padding: const EdgeInsets.only(
                          left: avatarToTextPadding,
                          right: 10,
                        ),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/home/Bp.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            userName,
                            style: GoogleFonts.luckiestGuy(
                              fontSize: 28,
                              color: const Color.fromARGB(255, 255, 239, 19),
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    // Avatar with Image Background
                    Positioned(
                      left: 0,
                      top: (avatarRadius * 2 - nameBubbleHeight) / 6,
                      child: Container(
                        width: avatarRadius * 3,
                        height: avatarRadius * 3,
                        padding: const EdgeInsets.only(
                          left: 5.5,
                          bottom: avatarBackgroundPadding,
                          right: avatarBackgroundPadding,
                          top: 0,
                        ),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/home/Pb.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: avatarRadius * 0.87,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                profileImagePath.startsWith('assets/')
                                    ? AssetImage(profileImagePath)
                                    : FileImage(File(profileImagePath)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Settings Button
            CartoonButton(
              icon: Icons.settings,
              color: Colors.purple[300]!,
              shadowColor: Colors.purple[600]!,
              onTap: onResetPressed,
            ),
          ],
        ),
      ),
    );
  }
}
