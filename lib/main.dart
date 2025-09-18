import 'package:flutter/material.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tcpqyhjfidxiymehybde.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjcHF5aGpmaWR4aXltZWh5YmRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxOTg3NzAsImV4cCI6MjA3Mzc3NDc3MH0.AXuvcZBvfVCwlpdFBTqokljxfNQYj6LQ-NbbQn37m5Y',
  );

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
        home: const SplashScreen(),
      ),
    );
  }
}
