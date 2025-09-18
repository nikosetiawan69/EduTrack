import 'package:flutter/material.dart';
import 'package:edu_track/models/student.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 AppBar dengan gradasi biru ungu muda dan border radius bawah
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE6F0FA), Color(0xFFF3E5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 4,
              title: const Text(
                'Detail Siswa',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black87),
            ),
          ),
        ),
      ),

      backgroundColor: Colors.blue[100], // 🔹 Background utama biru
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(Icons.account_circle, 'Data Pribadi'),
          _buildDetailBox(Icons.verified_user, 'NISN', student.nisn),
          _buildDetailBox(
              Icons.person_outline, 'Nama Lengkap', student.namaLengkap),
          _buildDetailBox(Icons.wc, 'Jenis Kelamin', student.jenisKelamin),
          _buildDetailBox(Icons.lightbulb_outline, 'Agama', student.agama),
          _buildDetailBox(Icons.calendar_today, 'Tempat, Tanggal Lahir',
              '${student.tempatLahir}, ${student.tanggalLahir}'),
          _buildDetailBox(
              Icons.phone_android, 'No. Tlp/HP', student.noHp ?? '-'),
          _buildDetailBox(Icons.card_membership, 'NIK', student.nik),
          const SizedBox(height: 20),
          _buildSectionTitle(Icons.location_city, 'Alamat'),
          _buildDetailBox(Icons.directions, 'Jalan', student.jalan ?? '-'),
          _buildDetailBox(
              Icons.format_list_numbered, 'RT/RW', student.rtRw ?? '-'),
          _buildDetailBox(Icons.landscape, 'Dusun', student.dusun),
          _buildDetailBox(Icons.home, 'Desa', student.desa),
          _buildDetailBox(Icons.local_taxi, 'Kecamatan', student.kecamatan),
          _buildDetailBox(Icons.domain, 'Kabupaten', student.kabupaten),
          _buildDetailBox(Icons.map, 'Provinsi', student.provinsi),
          _buildDetailBox(
              Icons.markunread_mailbox, 'Kode Pos', student.kodePos),
          const SizedBox(height: 20),
          _buildSectionTitle(Icons.people, 'Orang Tua/Wali'),
          _buildDetailBox(Icons.man, 'Nama Ayah', student.namaAyah),
          _buildDetailBox(Icons.woman, 'Nama Ibu', student.namaIbu),
          if (student.namaWali != null)
            _buildDetailBox(
                Icons.supervisor_account, 'Nama Wali', student.namaWali!),
          _buildDetailBox(
              Icons.location_pin, 'Alamat Orang Tua', student.alamatOrangTua),
        ],
      ),
    );
  }

  // 🔹 Widget Judul Bagian
  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Kotak detail data (navbar kotak style)
  Widget _buildDetailBox(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
