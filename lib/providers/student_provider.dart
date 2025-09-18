import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:edu_track/models/student.dart';
import 'package:edu_track/services/wilayah_service.dart';

class StudentProvider with ChangeNotifier {
  List<Student> _students = [];
  bool _isLoading = false;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;

  final _client = Supabase.instance.client;
  final _wilayahService = WilayahService();

  StudentProvider() {
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response =
          await _client.from('students').select('*, wilayah!inner(*)');
      _students = (response as List<dynamic>)
          .map((data) => Student.fromMap({
                ...data,
                'dusun': data['wilayah']['dusun'],
                'desa': data['wilayah']['desa'],
                'kecamatan': data['wilayah']['kecamatan'],
                'kabupaten': data['wilayah']['kabupaten'],
                'provinsi': data['wilayah']['provinsi'],
                'kode_pos': data['wilayah']['kode_pos'],
              }))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching students: $e');
      _isLoading = false;
      _students = [];
      notifyListeners();
    }
  }

  Future<void> addStudent(Student student) async {
    try {
      print(
          'Attempting to add student with: dusun=${student.dusun}, desa=${student.desa}, kecamatan=${student.kecamatan}, kabupaten=${student.kabupaten}, provinsi=${student.provinsi}');
      final wilayahId = await _wilayahService.findWilayahId(
        dusun: student.dusun,
        desa: student.desa,
        kecamatan: student.kecamatan,
        kabupaten: student.kabupaten,
        provinsi: student.provinsi,
      );
      if (wilayahId == null) {
        throw Exception('Wilayah tidak ditemukan');
      }

      await _client.from('students').insert({
        'nisn': student.nisn,
        'nama_lengkap': student.namaLengkap,
        'jenis_kelamin': student.jenisKelamin,
        'agama': student.agama,
        'tempat_lahir': student.tempatLahir,
        'tanggal_lahir': student.tanggalLahir,
        'no_hp': student.noHp,
        'nik': student.nik,
        'jalan': student.jalan,
        'rt_rw': student.rtRw,
        'dusun': student.dusun,
        'desa': student.desa,
        'kecamatan': student.kecamatan,
        'kabupaten': student.kabupaten,
        'provinsi': student.provinsi,
        'kode_pos': student.kodePos,
        'nama_ayah': student.namaAyah,
        'nama_ibu': student.namaIbu,
        'nama_wali': student.namaWali,
        'alamat_orang_tua': student.alamatOrangTua,
        'wilayah_id': wilayahId,
      });
      print('Student added successfully with wilayah_id: $wilayahId');
      await fetchStudents();
    } catch (e) {
      print('Error adding student: $e');
      throw Exception('Error adding student: $e');
    }
  }

  Future<void> updateStudent(String nisn, Student student) async {
    try {
      print(
          'Attempting to update student with: dusun=${student.dusun}, desa=${student.desa}, kecamatan=${student.kecamatan}, kabupaten=${student.kabupaten}, provinsi=${student.provinsi}');
      final wilayahId = await _wilayahService.findWilayahId(
        dusun: student.dusun,
        desa: student.desa,
        kecamatan: student.kecamatan,
        kabupaten: student.kabupaten,
        provinsi: student.provinsi,
      );
      if (wilayahId == null) {
        throw Exception('Wilayah tidak ditemukan');
      }

      await _client.from('students').update({
        'nama_lengkap': student.namaLengkap,
        'jenis_kelamin': student.jenisKelamin,
        'agama': student.agama,
        'tempat_lahir': student.tempatLahir,
        'tanggal_lahir': student.tanggalLahir,
        'no_hp': student.noHp,
        'nik': student.nik,
        'jalan': student.jalan,
        'rt_rw': student.rtRw,
        'dusun': student.dusun,
        'desa': student.desa,
        'kecamatan': student.kecamatan,
        'kabupaten': student.kabupaten,
        'provinsi': student.provinsi,
        'kode_pos': student.kodePos,
        'nama_ayah': student.namaAyah,
        'nama_ibu': student.namaIbu,
        'nama_wali': student.namaWali,
        'alamat_orang_tua': student.alamatOrangTua,
        'wilayah_id': wilayahId,
      }).eq('nisn', nisn);
      print('Student updated successfully with wilayah_id: $wilayahId');
      await fetchStudents();
    } catch (e) {
      print('Error updating student: $e');
      throw Exception('Error updating student: $e');
    }
  }

  Future<void> deleteStudent(String nisn) async {
    try {
      await _client.from('students').delete().eq('nisn', nisn);
      await fetchStudents();
    } catch (e) {
      print('Error deleting student: $e');
      rethrow;
    }
  }
}
