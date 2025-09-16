import 'package:flutter/material.dart';
import 'package:edu_track/models/student.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔹 AppBar dengan border radius bawah
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 4,
            title: const Text(
              'Detail Siswa',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),

      backgroundColor: Colors.blue[100], // 🔹 Background utama biru
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(Icons.person, 'Data Pribadi'),
          _buildDetailBox(Icons.badge, 'NISN', student.nisn),
          _buildDetailBox(Icons.person, 'Nama Lengkap', student.namaLengkap),
          _buildDetailBox(Icons.wc, 'Jenis Kelamin', student.jenisKelamin),
          _buildDetailBox(Icons.star, 'Agama', student.agama),
          _buildDetailBox(Icons.cake, 'Tempat, Tanggal Lahir',
              '${student.tempatLahir}, ${student.tanggalLahir}'),
          _buildDetailBox(Icons.phone, 'No. Tlp/HP', student.noHp),
          _buildDetailBox(Icons.credit_card, 'NIK', student.nik),

          const SizedBox(height: 20),
          _buildSectionTitle(Icons.home, 'Alamat'),
          _buildDetailBox(Icons.map, 'Jalan', student.jalan),
          _buildDetailBox(Icons.home_work, 'RT/RW', student.rtRw),
          _buildDetailBox(Icons.location_city, 'Dusun', student.dusun),
          _buildDetailBox(Icons.location_on, 'Desa', student.desa),
          _buildDetailBox(Icons.place, 'Kecamatan', student.kecamatan),
          _buildDetailBox(Icons.apartment, 'Kabupaten', student.kabupaten),
          _buildDetailBox(Icons.flag, 'Provinsi', student.provinsi),
          _buildDetailBox(Icons.local_post_office, 'Kode Pos', student.kodePos),

          const SizedBox(height: 20),
          _buildSectionTitle(Icons.family_restroom, 'Orang Tua/Wali'),
          _buildDetailBox(Icons.male, 'Nama Ayah', student.namaAyah),
          _buildDetailBox(Icons.female, 'Nama Ibu', student.namaIbu),
          if (student.namaWali != null)
            _buildDetailBox(Icons.supervisor_account, 'Nama Wali', student.namaWali!),
          _buildDetailBox(Icons.location_pin, 'Alamat Orang Tua', student.alamatOrangTua),
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
                  fontWeight: FontWeight.w600, color: Colors.black87),
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
