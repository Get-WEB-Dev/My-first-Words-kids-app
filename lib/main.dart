import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../profile/profile_setup.dart';
import '../profile/profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ComicNeue',
      ),
      home: FutureBuilder(
        future: ProfileService.hasProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data == true
                ? const HomePage()
                : const ProfileSetupPage();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
