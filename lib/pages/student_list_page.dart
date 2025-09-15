// lib/pages/student_list_page.dart
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
      appBar: AppBar(
        title: const Text('Daftar Siswa'),
      ),
      body: studentProvider.students.isEmpty
          ? const Center(child: Text('Tidak ada data siswa.'))
          : ListView.builder(
              itemCount: studentProvider.students.length,
              itemBuilder: (context, index) {
                return StudentTile(student: studentProvider.students[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}