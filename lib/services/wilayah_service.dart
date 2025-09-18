import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:edu_track/models/wilayah.dart';

class WilayahService {
  final _client = Supabase.instance.client;

  Future<List<Wilayah>> getDusunList() async {
    final response = await _client.from('wilayah').select().neq('dusun', '');
    return (response as List<dynamic>)
        .map((data) => Wilayah.fromMap(data))
        .toList();
  }

  Future<List<Wilayah>> searchDusun(String query) async {
    final response = await _client
        .from('wilayah')
        .select()
        .neq('dusun', '')
        .ilike('dusun', '%$query%');
    return (response as List<dynamic>)
        .map((data) => Wilayah.fromMap(data))
        .toList();
  }

  Future<List<Wilayah>> getDesaByDusun(String dusunName) async {
    final response = await _client
        .from('wilayah')
        .select()
        .eq('dusun', dusunName)
        .neq('desa', '');
    return (response as List<dynamic>)
        .map((data) => Wilayah.fromMap(data))
        .toList();
  }

  Future<List<Wilayah>> getKecamatanByDesa(String desaName) async {
    final response = await _client
        .from('wilayah')
        .select()
        .eq('desa', desaName)
        .neq('kecamatan', '');
    return (response as List<dynamic>)
        .map((data) => Wilayah.fromMap(data))
        .toList();
  }

  Future<List<Wilayah>> getKabupatenByKecamatan(String kecamatanName) async {
    final response = await _client
        .from('wilayah')
        .select()
        .eq('kecamatan', kecamatanName)
        .neq('kabupaten', '');
    return (response as List<dynamic>)
        .map((data) => Wilayah.fromMap(data))
        .toList();
  }

  Future<Map<String, dynamic>?> getProvinsiAndKodePosByDusun(
      String dusunName) async {
    final response = await _client
        .from('wilayah')
        .select('provinsi, kode_pos')
        .eq('dusun', dusunName)
        .neq('provinsi', '')
        .neq('kode_pos', '')
        .maybeSingle();
    return response != null ? Map<String, dynamic>.from(response) : null;
  }

  Future<String?> findWilayahId({
    required String dusun,
    required String desa,
    required String kecamatan,
    required String kabupaten,
    required String provinsi,
  }) async {
    try {
      final response = await _client
          .from('wilayah')
          .select('id')
          .eq('dusun', dusun)
          .eq('desa', desa)
          .eq('kecamatan', kecamatan)
          .eq('kabupaten', kabupaten)
          .eq('provinsi', provinsi)
          .maybeSingle();
      if (response == null) {
        print(
            'No wilayah found for: dusun=$dusun, desa=$desa, kecamatan=$kecamatan, kabupaten=$kabupaten, provinsi=$provinsi');
        return null;
      }
      final dynamic rawId = response['id'];
      // Pastikan id selalu String untuk konsistensi model
      return rawId is String ? rawId : rawId.toString();
    } catch (e) {
      print('Error finding wilayah_id: $e');
      return null;
    }
  }
}
