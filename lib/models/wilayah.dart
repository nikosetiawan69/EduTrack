// lib/models/wilayah.dart
class Wilayah {
  final String id;
  final String? kabupaten;
  final String? kecamatan;
  final String? desa;
  final String? dusun;
  final String? kodePos;

  Wilayah({
    required this.id,
    this.kabupaten,
    this.kecamatan,
    this.desa,
    this.dusun,
    this.kodePos,
  });

  factory Wilayah.fromMap(Map<String, dynamic> map) {
    return Wilayah(
      id: map['id'].toString(),
      kabupaten: map['kabupaten'],
      kecamatan: map['kecamatan'],
      desa: map['desa'],
      dusun: map['dusun'],
      kodePos: map['kode_pos'], // Sesuai dengan nama kolom di database
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kabupaten': kabupaten,
      'kecamatan': kecamatan,
      'desa': desa,
      'dusun': dusun,
      'kode_pos': kodePos, // Sesuai dengan nama kolom di database
    };
  }

  @override
  String toString() {
    return 'Wilayah{id: $id, kabupaten: $kabupaten, kecamatan: $kecamatan, desa: $desa, dusun: $dusun, kodePos: $kodePos}';
  }
}