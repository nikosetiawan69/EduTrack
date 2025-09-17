// lib/services/wilayah_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/wilayah.dart';

class WilayahService {
  final _client = Supabase.instance.client;

  // Ambil semua dusun yang unik
  Future<List<Wilayah>> getDusunList() async {
    try {
      final response = await _client
          .from('wilayah')
          .select('id, dusun')
          .not('dusun', 'is', null)
          .neq('dusun', '')
          .order('dusun');

      // Remove duplicates berdasarkan nama dusun
      final Map<String, Wilayah> uniqueDusun = {};
      for (final data in response) {
        final wilayah = Wilayah.fromMap(data);
        if (wilayah.dusun != null && wilayah.dusun!.trim().isNotEmpty && 
            !uniqueDusun.containsKey(wilayah.dusun!.trim())) {
          uniqueDusun[wilayah.dusun!.trim()] = wilayah;
        }
      }

      return uniqueDusun.values.toList()
        ..sort((a, b) => a.dusun!.compareTo(b.dusun!));
    } catch (e) {
      throw Exception('Failed to load dusun: $e');
    }
  }

  // Ambil desa berdasarkan dusun yang dipilih
  Future<List<Wilayah>> getDesaByDusun(String dusunName) async {
    try {
      final response = await _client
          .from('wilayah')
          .select('id, desa, dusun')
          .eq('dusun', dusunName)
          .not('desa', 'is', null)
          .neq('desa', '')
          .order('desa');

      // Remove duplicates berdasarkan nama desa
      final Map<String, Wilayah> uniqueDesa = {};
      for (final data in response) {
        final wilayah = Wilayah.fromMap(data);
        if (wilayah.desa != null && wilayah.desa!.trim().isNotEmpty && 
            !uniqueDesa.containsKey(wilayah.desa!.trim())) {
          uniqueDesa[wilayah.desa!.trim()] = wilayah;
        }
      }

      return uniqueDesa.values.toList()
        ..sort((a, b) => a.desa!.compareTo(b.desa!));
    } catch (e) {
      throw Exception('Failed to load desa: $e');
    }
  }

  // Ambil kecamatan berdasarkan desa yang dipilih
  Future<List<Wilayah>> getKecamatanByDesa(String desaName) async {
    try {
      final response = await _client
          .from('wilayah')
          .select('id, kecamatan, desa')
          .eq('desa', desaName)
          .not('kecamatan', 'is', null)
          .neq('kecamatan', '')
          .order('kecamatan');

      // Remove duplicates berdasarkan nama kecamatan
      final Map<String, Wilayah> uniqueKecamatan = {};
      for (final data in response) {
        final wilayah = Wilayah.fromMap(data);
        if (wilayah.kecamatan != null && wilayah.kecamatan!.trim().isNotEmpty && 
            !uniqueKecamatan.containsKey(wilayah.kecamatan!.trim())) {
          uniqueKecamatan[wilayah.kecamatan!.trim()] = wilayah;
        }
      }

      return uniqueKecamatan.values.toList()
        ..sort((a, b) => a.kecamatan!.compareTo(b.kecamatan!));
    } catch (e) {
      throw Exception('Failed to load kecamatan: $e');
    }
  }

  // Ambil kabupaten berdasarkan kecamatan yang dipilih
  Future<List<Wilayah>> getKabupatenByKecamatan(String kecamatanName) async {
    try {
      final response = await _client
          .from('wilayah')
          .select('id, kabupaten, kecamatan')
          .eq('kecamatan', kecamatanName)
          .not('kabupaten', 'is', null)
          .neq('kabupaten', '')
          .order('kabupaten');

      // Remove duplicates berdasarkan nama kabupaten
      final Map<String, Wilayah> uniqueKabupaten = {};
      for (final data in response) {
        final wilayah = Wilayah.fromMap(data);
        if (wilayah.kabupaten != null && wilayah.kabupaten!.trim().isNotEmpty && 
            !uniqueKabupaten.containsKey(wilayah.kabupaten!.trim())) {
          uniqueKabupaten[wilayah.kabupaten!.trim()] = wilayah;
        }
      }

      return uniqueKabupaten.values.toList()
        ..sort((a, b) => a.kabupaten!.compareTo(b.kabupaten!));
    } catch (e) {
      throw Exception('Failed to load kabupaten: $e');
    }
  }

  // Ambil data lengkap wilayah berdasarkan ID (untuk keperluan tertentu)
  Future<Wilayah?> getWilayahById(String id) async {
    try {
      final response = await _client
          .from('wilayah')
          .select('*')
          .eq('id', id)
          .single();

      return Wilayah.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  // Cari wilayah untuk keperluan edit (mencari ID berdasarkan nama)
  // Ini berguna jika nanti Anda perlu referensi ID untuk keperluan lain
  Future<String?> findWilayahId({
    String? dusun,
    String? desa,
    String? kecamatan,
    String? kabupaten,
  }) async {
    try {
      var query = _client.from('wilayah').select('id');

      if (dusun != null) query = query.eq('dusun', dusun);
      if (desa != null) query = query.eq('desa', desa);
      if (kecamatan != null) query = query.eq('kecamatan', kecamatan);
      if (kabupaten != null) query = query.eq('kabupaten', kabupaten);

      final response = await query.limit(1).single();
      return response['id'].toString();
    } catch (e) {
      return null;
    }
  }

  // Method untuk testing koneksi database
  Future<bool> testConnection() async {
    try {
      await _client.from('wilayah').select('id').limit(1);
      return true;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Method debug untuk melihat struktur data
  Future<void> debugTableStructure() async {
    try {
      final response = await _client.from('wilayah').select('*').limit(5);
      print('Sample data from wilayah:');
      for (final row in response) {
        print(row);
      }
    } catch (e) {
      print('Debug error: $e');
    }
  }
}