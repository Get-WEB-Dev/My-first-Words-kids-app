import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_service.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentImagePath;
  final String currentFullName;
  final String currentAge;
  final String currentLevel;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentImagePath,
    required this.currentFullName,
    required this.currentAge,
    required this.currentLevel,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _fullNameController;
  late TextEditingController _ageController;
  late TextEditingController _levelController;
  File? _profileImage;
  int _selectedAvatar = 1;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _fullNameController = TextEditingController(text: widget.currentFullName);
    _ageController = TextEditingController(text: widget.currentAge);
    _levelController = TextEditingController(text: widget.currentLevel);

    // Check if current image is a default avatar
    if (widget.currentImagePath.contains('avatar1')) {
      _selectedAvatar = 1;
    } else if (widget.currentImagePath.contains('avatar2')) {
      _selectedAvatar = 2;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _selectedAvatar = 0; // Mark as custom image
      });
    }
  }

  Future<void> _saveProfile() async {
    final updatedData = {
      'name': _nameController.text,
      'profileImagePath': _profileImage?.path ??
          (_selectedAvatar == 1
              ? 'assets/avatars/avatar1.jpeg'
              : 'assets/avatars/avatar2.jpeg'),
      'fullName': _fullNameController.text, // Make sure these are included
      'age': _ageController.text,
      'level': _levelController.text,
    };

    await ProfileService.updateProfile(updatedData);
    if (mounted) {
      Navigator.pop(context, updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.luckiestGuy(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture Section
            Text(
              'Profile Picture',
              style: GoogleFonts.luckiestGuy(
                fontSize: 22,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Default Avatar 1
                GestureDetector(
                  onTap: () => setState(() {
                    _profileImage = null;
                    _selectedAvatar = 1;
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _selectedAvatar == 1 ? Colors.orange : Colors.grey,
                        width: 4,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/avatars/avatar1.jpeg'),
                    ),
                  ),
                ),

                // Custom Upload
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _selectedAvatar == 0 ? Colors.orange : Colors.grey,
                        width: 4,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue[100],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.add_a_photo, size: 30)
                          : null,
                    ),
                  ),
                ),

                // Default Avatar 2
                GestureDetector(
                  onTap: () => setState(() {
                    _profileImage = null;
                    _selectedAvatar = 2;
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _selectedAvatar == 2 ? Colors.orange : Colors.grey,
                        width: 4,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/avatars/avatar2.jpeg'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Nickname Input
            _buildInputField(
              controller: _nameController,
              label: 'Nickname',
              icon: Icons.face,
            ),
            const SizedBox(height: 20),

            // Full Name Input
            _buildInputField(
              controller: _fullNameController,
              label: 'Full Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),

            // Age Input
            _buildInputField(
              controller: _ageController,
              label: 'Age',
              icon: Icons.cake,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Class/Level Input
            _buildInputField(
              controller: _levelController,
              label: 'Class/Grade',
              icon: Icons.school,
            ),
            const SizedBox(height: 30),

            // Save Button
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'SAVE CHANGES',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        style: GoogleFonts.comicNeue(fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.comicNeue(
            fontSize: 16,
            color: Colors.purple,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.purple),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _levelController.dispose();
    super.dispose();
  }
}
