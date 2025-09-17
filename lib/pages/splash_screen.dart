import 'package:edu_track/pages/student_list_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Setup animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Background utama putih
        child: Stack(
          children: [
            // Custom painted wave/abstrak shape
            Positioned.fill(
              child: CustomPaint(
                painter: WavePainter(),
                child: Container(),
              ),
            ),
            // Gradasi di atas wave
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE6F0FA), Color(0xFFF3E5F5)], // Biru muda ke ungu muda
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Content centered
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: _animation,
                    child: const Text(
                      'EduTrack',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sistem Data Siswa',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Navbar kecil dengan tombol Start
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const StudentListPage()),
                    );
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for wave/abstrak shape
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5); // Mulai dari 50% tinggi
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.6,
      size.width * 0.5, size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.4,
      size.width, size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}