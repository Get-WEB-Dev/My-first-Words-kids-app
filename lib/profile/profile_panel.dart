import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'edit_profile.dart';

class ProfilePanel extends StatelessWidget {
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onEditProfile;
  final VoidCallback onResetProfile;
  final String profileImagePath;
  final String userName;
  final String fullName;
  final String age;
  final String currentLevel;

  const ProfilePanel({
    super.key,
    required this.onClose,
    required this.onEditProfile,
    required this.onResetProfile,
    required this.profileImagePath,
    required this.userName,
    required this.fullName,
    required this.age,
    required this.currentLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.pink[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: onClose,
              ),
            ),
          ),

          // Profile content that can scroll if needed
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage: profileImagePath.startsWith('assets/')
                        ? AssetImage(profileImagePath)
                        : FileImage(File(profileImagePath)) as ImageProvider,
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    userName,
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 28,
                      color: Colors.purple,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Divider Line
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.orange.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),

                  // Profile Details
                  _buildDetailRow('Full Name', fullName),
                  _buildDetailRow('Age', age),
                  _buildDetailRow('Class', currentLevel),
                  const SizedBox(height: 20),

                  // Edit Profile Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        final updatedData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              currentName: userName,
                              currentImagePath: profileImagePath,
                              currentFullName: fullName,
                              currentAge: age,
                              currentLevel: currentLevel,
                            ),
                          ),
                        );

                        if (updatedData != null) {
                          onEditProfile(
                              updatedData); // This now matches the type
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.comicNeue(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider Line
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.orange.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),

          // Reset Button fixed at bottom
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onResetProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Reset Progress',
                      style: GoogleFonts.comicNeue(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.comicNeue(
              fontSize: 18,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.comicNeue(
              fontSize: 18,
              color: Colors.deepPurple[800],
            ),
          ),
        ],
      ),
    );
  }
}
