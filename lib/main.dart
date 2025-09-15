import 'package:flutter/material.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:provider/provider.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(const EduTrackApp());
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EduTrack',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: const SplashScreen(), // mulai dari splash screen
      ),
    );
  }
}
