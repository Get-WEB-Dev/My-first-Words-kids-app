import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'profile_service.dart';
import 'dart:io';
import '../home/home_page.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _nameController = TextEditingController();
  File? _profileImage;
  bool _isSaving = false;
  int _selectedAvatar = 1; // 1 or 2 for default avatars

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
    if (_nameController.text.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      String imagePath;
      if (_profileImage != null) {
        imagePath = _profileImage!.path;
      } else {
        imagePath = 'assets/avatars/avatar$_selectedAvatar.png';
      }

      await ProfileService.saveProfile(
        name: _nameController.text,
        imagePath: imagePath,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );

        // Show the edit profile message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can edit your profile in the profile page'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // ... error handling ...
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Welcome Message
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.purple,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  'Welcome to My First Words!\nThe fun way to learn new words!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: 24,
                    color: Colors.deepPurple[800],
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Bear Animation with Overflow and Scale
              SizedBox(
                height: 120, // Container size
                child: OverflowBox(
                  maxHeight: 280, // Visual size
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: 1.5,
                    child: Lottie.asset(
                      'assets/home/welcome.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Input Box
              Container(
                margin: const EdgeInsets.only(top: 110),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.orange,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 15,
                  top: 15,
                ),
                child: TextField(
                  controller: _nameController,
                  style: GoogleFonts.comicNeue(
                    fontSize: 22,
                    color: Colors.deepPurple,
                  ),
                  decoration: InputDecoration(
                    labelText: 'What should we call you?',
                    labelStyle: GoogleFonts.luckiestGuy(
                      fontSize: 18,
                      color: Colors.pink,
                    ),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.face,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Avatar Selection
              Column(
                children: [
                  Text(
                    'Choose your avatar!',
                    style: GoogleFonts.luckiestGuy(
                      fontSize: 24,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Avatar Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Default Avatar 1
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _profileImage = null;
                            _selectedAvatar = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedAvatar == 1
                                  ? Colors.orange
                                  : Colors.grey[300]!,
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                const AssetImage('assets/home/c6.png'),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _profileImage = null;
                            _selectedAvatar = 2;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedAvatar == 2
                                  ? Colors.orange
                                  : Colors.grey[300]!,
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                const AssetImage('assets/home/c9.png'),
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
                              color: _selectedAvatar == 0
                                  ? Colors.orange
                                  : Colors.grey[300]!,
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.blue[100],
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                            child: _profileImage == null
                                ? Icon(Icons.add_a_photo,
                                    size: 40, color: Colors.purple)
                                : null,
                          ),
                        ),
                      ),

                      // Default Avatar 2
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Tap to select or add your own!',
                    style: GoogleFonts.comicNeue(
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Save Button
              _isSaving
                  ? CircularProgressIndicator(
                      color: Colors.purple,
                    )
                  : ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 3,
                          ),
                        ),
                        elevation: 10,
                      ),
                      child: Text(
                        'START THE FUN!',
                        style: GoogleFonts.luckiestGuy(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
