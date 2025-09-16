import 'package:flutter/material.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:edu_track/widgets/student_tile.dart';
import 'package:provider/provider.dart';
import 'student_form_page.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      // 🔹 Background linear gradient biru → putih (sama seperti detail page)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE1F5FE)], // putih → biru muda
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 🔹 AppBar putih dengan border radius bawah
            PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 4,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.school, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Text(
                        'Edu Track',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  centerTitle: true,
                ),
              ),
            ),

            // 🔹 Subjudul "Layanan Data Siswa"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.transparent,
              child: const Text(
                "Layanan Data Siswa",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),

            // 🔹 List Data Siswa
            Expanded(
              child: studentProvider.students.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada data siswa.',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  : ListView.builder(
                      itemCount: studentProvider.students.length,
                      itemBuilder: (context, index) {
                        return StudentTile(
                          student: studentProvider.students[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentFormPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.blueAccent),
      ),
    );
  }
}
