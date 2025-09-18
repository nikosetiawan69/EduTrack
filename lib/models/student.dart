class Student {
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempatLahir;
  final String tanggalLahir;
  final String? noHp;
  final String nik;
  final String? jalan;
  final String? rtRw;
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
    this.noHp,
    required this.nik,
    this.jalan,
    this.rtRw,
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
      nisn: map['nisn'] as String,
      namaLengkap: map['nama_lengkap'] as String,
      jenisKelamin: map['jenis_kelamin'] as String,
      agama: map['agama'] as String,
      tempatLahir: map['tempat_lahir'] as String,
      tanggalLahir: map['tanggal_lahir'] as String,
      noHp: map['no_hp'] as String?,
      nik: map['nik'] as String,
      jalan: map['jalan'] as String?,
      rtRw: map['rt_rw'] as String?,
      dusun: map['dusun'] as String,
      desa: map['desa'] as String,
      kecamatan: map['kecamatan'] as String,
      kabupaten: map['kabupaten'] as String,
      provinsi: map['provinsi'] as String,
      kodePos: map['kode_pos'] as String,
      namaAyah: map['nama_ayah'] as String,
      namaIbu: map['nama_ibu'] as String,
      namaWali: map['nama_wali'] as String?,
      alamatOrangTua: map['alamat_orang_tua'] as String,
    );
  }
}