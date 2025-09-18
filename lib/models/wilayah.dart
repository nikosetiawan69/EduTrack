class Wilayah {
  final String id;
  final String? provinsi;
  final String? kabupaten;
  final String? kecamatan;
  final String? desa;
  final String? dusun;
  final String? kodePos;

  Wilayah({
    required this.id,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
    this.desa,
    this.dusun,
    this.kodePos,
  });

  factory Wilayah.fromMap(Map<String, dynamic> map) {
    return Wilayah(
      id: map['id'].toString(),
      provinsi: map['provinsi'],
      kabupaten: map['kabupaten'],
      kecamatan: map['kecamatan'],
      desa: map['desa'],
      dusun: map['dusun'],
      kodePos: map['kode_pos'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provinsi': provinsi,
      'kabupaten': kabupaten,
      'kecamatan': kecamatan,
      'desa': desa,
      'dusun': dusun,
      'kode_pos': kodePos,
    };
  }

  @override
  String toString() {
    return 'Wilayah{id: $id, provinsi: $provinsi, kabupaten: $kabupaten, kecamatan: $kecamatan, desa: $desa, dusun: $dusun, kodePos: $kodePos}';
  }
}