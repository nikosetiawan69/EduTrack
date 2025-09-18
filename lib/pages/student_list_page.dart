import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:edu_track/pages/student_form_page.dart';
import 'package:edu_track/widgets/student_tile.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Siswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentFormPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await studentProvider.fetchStudents();
        },
        child: Builder(
          builder: (context) {
            if (studentProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (studentProvider.students.isEmpty) {
              return  ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 200),
                  Center(child: Text('Tidak ada data siswa')),
                ],
              );
            }
            return ListView.separated(
              itemCount: studentProvider.students.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = studentProvider.students[index];
                return StudentTile(student: student);
              },
            );
          },
        ),
      ),
    );
  }
}
