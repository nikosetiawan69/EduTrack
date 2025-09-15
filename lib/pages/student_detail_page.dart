// lib/pages/student_detail_page.dart
import 'package:flutter/material.dart';
import 'package:edu_track/models/student.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Siswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('NISN', student.nisn),
            _buildDetailRow('Nama Lengkap', student.namaLengkap),
            _buildDetailRow('Jenis Kelamin', student.jenisKelamin),
            _buildDetailRow('Agama', student.agama),
            _buildDetailRow('Tempat, Tanggal Lahir', '${student.tempatLahir}, ${student.tanggalLahir}'),
            _buildDetailRow('No. Tlp/HP', student.noHp),
            _buildDetailRow('NIK', student.nik),
            const SizedBox(height: 16),
            const Text('Alamat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildDetailRow('Jalan', student.jalan),
            _buildDetailRow('RT/RW', student.rtRw),
            _buildDetailRow('Dusun', student.dusun),
            _buildDetailRow('Desa', student.desa),
            _buildDetailRow('Kecamatan', student.kecamatan),
            _buildDetailRow('Kabupaten', student.kabupaten),
            _buildDetailRow('Provinsi', student.provinsi),
            _buildDetailRow('Kode Pos', student.kodePos),
            const SizedBox(height: 16),
            const Text('Orang Tua/Wali', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            _buildDetailRow('Nama Ayah', student.namaAyah),
            _buildDetailRow('Nama Ibu', student.namaIbu),
            if (student.namaWali != null) _buildDetailRow('Nama Wali', student.namaWali!),
            _buildDetailRow('Alamat Orang Tua', student.alamatOrangTua),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}