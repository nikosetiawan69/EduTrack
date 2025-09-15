// lib/pages/student_form_page.dart
import 'package:flutter/material.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:edu_track/models/student.dart';
import 'package:edu_track/utils/validator.dart';
import 'package:provider/provider.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;

  const StudentFormPage({super.key, this.student});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nisnController;
  late TextEditingController _namaLengkapController;
  late TextEditingController _jenisKelaminController;
  late TextEditingController _agamaController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _noHpController;
  late TextEditingController _nikController;
  late TextEditingController _jalanController;
  late TextEditingController _rtRwController;
  late TextEditingController _dusunController;
  late TextEditingController _desaController;
  late TextEditingController _kecamatanController;
  late TextEditingController _kabupatenController;
  late TextEditingController _provinsiController;
  late TextEditingController _kodePosController;
  late TextEditingController _namaAyahController;
  late TextEditingController _namaIbuController;
  late TextEditingController _namaWaliController;
  late TextEditingController _alamatOrangTuaController;

  @override
  void initState() {
    super.initState();
    _nisnController = TextEditingController(text: widget.student?.nisn ?? '');
    _namaLengkapController = TextEditingController(text: widget.student?.namaLengkap ?? '');
    _jenisKelaminController = TextEditingController(text: widget.student?.jenisKelamin ?? '');
    _agamaController = TextEditingController(text: widget.student?.agama ?? '');
    _tempatLahirController = TextEditingController(text: widget.student?.tempatLahir ?? '');
    _tanggalLahirController = TextEditingController(text: widget.student?.tanggalLahir ?? '');
    _noHpController = TextEditingController(text: widget.student?.noHp ?? '');
    _nikController = TextEditingController(text: widget.student?.nik ?? '');
    _jalanController = TextEditingController(text: widget.student?.jalan ?? '');
    _rtRwController = TextEditingController(text: widget.student?.rtRw ?? '');
    _dusunController = TextEditingController(text: widget.student?.dusun ?? '');
    _desaController = TextEditingController(text: widget.student?.desa ?? '');
    _kecamatanController = TextEditingController(text: widget.student?.kecamatan ?? '');
    _kabupatenController = TextEditingController(text: widget.student?.kabupaten ?? '');
    _provinsiController = TextEditingController(text: widget.student?.provinsi ?? '');
    _kodePosController = TextEditingController(text: widget.student?.kodePos ?? '');
    _namaAyahController = TextEditingController(text: widget.student?.namaAyah ?? '');
    _namaIbuController = TextEditingController(text: widget.student?.namaIbu ?? '');
    _namaWaliController = TextEditingController(text: widget.student?.namaWali ?? '');
    _alamatOrangTuaController = TextEditingController(text: widget.student?.alamatOrangTua ?? '');
  }

  @override
  void dispose() {
    _nisnController.dispose();
    _namaLengkapController.dispose();
    _jenisKelaminController.dispose();
    _agamaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _noHpController.dispose();
    _nikController.dispose();
    _jalanController.dispose();
    _rtRwController.dispose();
    _dusunController.dispose();
    _desaController.dispose();
    _kecamatanController.dispose();
    _kabupatenController.dispose();
    _provinsiController.dispose();
    _kodePosController.dispose();
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _namaWaliController.dispose();
    _alamatOrangTuaController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        nisn: _nisnController.text,
        namaLengkap: _namaLengkapController.text,
        jenisKelamin: _jenisKelaminController.text,
        agama: _agamaController.text,
        tempatLahir: _tempatLahirController.text,
        tanggalLahir: _tanggalLahirController.text,
        noHp: _noHpController.text,
        nik: _nikController.text,
        jalan: _jalanController.text,
        rtRw: _rtRwController.text,
        dusun: _dusunController.text,
        desa: _desaController.text,
        kecamatan: _kecamatanController.text,
        kabupaten: _kabupatenController.text,
        provinsi: _provinsiController.text,
        kodePos: _kodePosController.text,
        namaAyah: _namaAyahController.text,
        namaIbu: _namaIbuController.text,
        namaWali: _namaWaliController.text.isEmpty ? null : _namaWaliController.text,
        alamatOrangTua: _alamatOrangTuaController.text,
      );

      final provider = Provider.of<StudentProvider>(context, listen: false);
      if (widget.student == null) {
        provider.addStudent(student);
      } else {
        provider.updateStudent(widget.student!.nisn, student);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Tambah Siswa' : 'Edit Siswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nisnController,
                decoration: const InputDecoration(labelText: 'NISN'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaLengkapController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jenisKelaminController,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _agamaController,
                decoration: const InputDecoration(labelText: 'Agama'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tempatLahirController,
                decoration: const InputDecoration(labelText: 'Tempat Lahir'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalLahirController,
                decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noHpController,
                decoration: const InputDecoration(labelText: 'No. Tlp/HP'),
                validator: Validators.phoneValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nikController,
                decoration: const InputDecoration(labelText: 'NIK'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 24),
              const Text('Alamat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _jalanController,
                decoration: const InputDecoration(labelText: 'Jalan'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rtRwController,
                decoration: const InputDecoration(labelText: 'RT/RW'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dusunController,
                decoration: const InputDecoration(labelText: 'Dusun'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _desaController,
                decoration: const InputDecoration(labelText: 'Desa'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kecamatanController,
                decoration: const InputDecoration(labelText: 'Kecamatan'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kabupatenController,
                decoration: const InputDecoration(labelText: 'Kabupaten'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _provinsiController,
                decoration: const InputDecoration(labelText: 'Provinsi'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kodePosController,
                decoration: const InputDecoration(labelText: 'Kode Pos'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 24),
              const Text('Orang Tua/Wali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _namaAyahController,
                decoration: const InputDecoration(labelText: 'Nama Ayah'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaIbuController,
                decoration: const InputDecoration(labelText: 'Nama Ibu'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaWaliController,
                decoration: const InputDecoration(labelText: 'Nama Wali (jika ada)'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatOrangTuaController,
                decoration: const InputDecoration(labelText: 'Alamat Orang Tua'),
                validator: Validators.requiredValidator,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveStudent,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}