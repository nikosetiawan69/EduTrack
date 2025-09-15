// lib/models/student.dart
class Student {
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempatLahir;
  final String tanggalLahir;
  final String noHp;
  final String nik;
  final String jalan;
  final String rtRw;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String kodePos;
  final String namaAyah;
  final String namaIbu;
  final String? namaWali;
  final String alamatOrangTua;

  Student({
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.noHp,
    required this.nik,
    required this.jalan,
    required this.rtRw,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.namaAyah,
    required this.namaIbu,
    this.namaWali,
    required this.alamatOrangTua,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      nisn: map['nisn'],
      namaLengkap: map['namaLengkap'],
      jenisKelamin: map['jenisKelamin'],
      agama: map['agama'],
      tempatLahir: map['tempatLahir'],
      tanggalLahir: map['tanggalLahir'],
      noHp: map['noHp'],
      nik: map['nik'],
      jalan: map['jalan'],
      rtRw: map['rtRw'],
      dusun: map['dusun'],
      desa: map['desa'],
      kecamatan: map['kecamatan'],
      kabupaten: map['kabupaten'],
      provinsi: map['provinsi'],
      kodePos: map['kodePos'],
      namaAyah: map['namaAyah'],
      namaIbu: map['namaIbu'],
      namaWali: map['namaWali'],
      alamatOrangTua: map['alamatOrangTua'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nisn': nisn,
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'agama': agama,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'noHp': noHp,
      'nik': nik,
      'jalan': jalan,
      'rtRw': rtRw,
      'dusun': dusun,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'kodePos': kodePos,
      'namaAyah': namaAyah,
      'namaIbu': namaIbu,
      'namaWali': namaWali,
      'alamatOrangTua': alamatOrangTua,
    };
  }
}