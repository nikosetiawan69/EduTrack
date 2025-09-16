// lib/widgets/student_tile.dart
import 'package:flutter/material.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:edu_track/models/student.dart';
import 'package:edu_track/pages/student_form_page.dart';
import 'package:edu_track/pages/student_detail_page.dart';
import 'package:provider/provider.dart';

class StudentTile extends StatelessWidget {
  final Student student;

  const StudentTile({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student.namaLengkap),
      subtitle: Text('NISN: ${student.nisn}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailPage(student: student),
          ),
        );
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentFormPage(student: student),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Siswa'),
                  content: const Text('Apakah Anda yakin ingin menghapus siswa ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<StudentProvider>(context, listen: false)
                            .deleteStudent(student.nisn);
                        Navigator.pop(context);
                      },
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}