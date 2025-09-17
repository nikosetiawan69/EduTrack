import 'package:edu_track/providers/student_provider.dart';
import 'package:edu_track/widgets/student_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'student_form_page.dart';

class StudentListPage extends StatelessWidget {
  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue[50], // Background utama biru muda
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // tinggi appbar pas
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.people, size: 28, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Daftar Siswa',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow( // 👉 shadow elegan
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Garis horizontal kecil di atas daftar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 8),
              child: Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          studentProvider.students.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.info_outline,
                            size: 48, color: Colors.blueGrey),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada data siswa',
                          style:
                              TextStyle(fontSize: 16, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final student = studentProvider.students[index];

                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration:
                            Duration(milliseconds: 400 + (index * 100)), // delay tiap item
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 50 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.lightBlueAccent.shade100,
                              width: 1.5,
                            ),
                          ),
                          elevation: 3,
                          child: StudentTile(student: student),
                        ),
                      );
                    },
                    childCount: studentProvider.students.length,
                  ),
                ),
        ],
      ),
      // Tombol tambah
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentFormPage()),
          );
        },
        backgroundColor: Colors.lightBlueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
