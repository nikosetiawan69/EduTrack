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

class _StudentFormPageState extends State<StudentFormPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Animations
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // Controllers
  late final TextEditingController _nisnController;
  late final TextEditingController _namaLengkapController;
  late final TextEditingController _jenisKelaminController;
  late final TextEditingController _agamaController;
  late final TextEditingController _tempatLahirController;
  late final TextEditingController _tanggalLahirController;
  late final TextEditingController _noHpController;
  late final TextEditingController _nikController;
  late final TextEditingController _jalanController;
  late final TextEditingController _rtRwController;
  late final TextEditingController _dusunController;
  late final TextEditingController _desaController;
  late final TextEditingController _kecamatanController;
  late final TextEditingController _kabupatenController;
  late final TextEditingController _provinsiController;
  late final TextEditingController _kodePosController;
  late final TextEditingController _namaAyahController;
  late final TextEditingController _namaIbuController;
  late final TextEditingController _namaWaliController;
  late final TextEditingController _alamatOrangTuaController;

  @override
  void initState() {
    super.initState();

    // Init animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Init controllers with optional initial student data
    _nisnController = TextEditingController(text: widget.student?.nisn ?? '');
    _namaLengkapController =
        TextEditingController(text: widget.student?.namaLengkap ?? '');
    _jenisKelaminController =
        TextEditingController(text: widget.student?.jenisKelamin ?? '');
    _agamaController = TextEditingController(text: widget.student?.agama ?? '');
    _tempatLahirController =
        TextEditingController(text: widget.student?.tempatLahir ?? '');
    _tanggalLahirController =
        TextEditingController(text: widget.student?.tanggalLahir ?? '');
    _noHpController = TextEditingController(text: widget.student?.noHp ?? '');
    _nikController = TextEditingController(text: widget.student?.nik ?? '');
    _jalanController = TextEditingController(text: widget.student?.jalan ?? '');
    _rtRwController = TextEditingController(text: widget.student?.rtRw ?? '');
    _dusunController = TextEditingController(text: widget.student?.dusun ?? '');
    _desaController = TextEditingController(text: widget.student?.desa ?? '');
    _kecamatanController =
        TextEditingController(text: widget.student?.kecamatan ?? '');
    _kabupatenController =
        TextEditingController(text: widget.student?.kabupaten ?? '');
    _provinsiController =
        TextEditingController(text: widget.student?.provinsi ?? '');
    _kodePosController = TextEditingController(text: widget.student?.kodePos ?? '');
    _namaAyahController =
        TextEditingController(text: widget.student?.namaAyah ?? '');
    _namaIbuController = TextEditingController(text: widget.student?.namaIbu ?? '');
    _namaWaliController = TextEditingController(text: widget.student?.namaWali ?? '');
    _alamatOrangTuaController =
        TextEditingController(text: widget.student?.alamatOrangTua ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
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
        nisn: _nisnController.text.trim(),
        namaLengkap: _namaLengkapController.text.trim(),
        jenisKelamin: _jenisKelaminController.text.trim(),
        agama: _agamaController.text.trim(),
        tempatLahir: _tempatLahirController.text.trim(),
        tanggalLahir: _tanggalLahirController.text.trim(),
        noHp: _noHpController.text.trim(),
        nik: _nikController.text.trim(),
        jalan: _jalanController.text.trim(),
        rtRw: _rtRwController.text.trim(),
        dusun: _dusunController.text.trim(),
        desa: _desaController.text.trim(),
        kecamatan: _kecamatanController.text.trim(),
        kabupaten: _kabupatenController.text.trim(),
        provinsi: _provinsiController.text.trim(),
        kodePos: _kodePosController.text.trim(),
        namaAyah: _namaAyahController.text.trim(),
        namaIbu: _namaIbuController.text.trim(),
        namaWali: _namaWaliController.text.trim().isEmpty
            ? null
            : _namaWaliController.text.trim(),
        alamatOrangTua: _alamatOrangTuaController.text.trim(),
      );

      final provider = Provider.of<StudentProvider>(context, listen: false);
      if (widget.student == null) {
        provider.addStudent(student);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Siswa berhasil ditambahkan')),
        );
      } else {
        provider.updateStudent(widget.student!.nisn, student);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data siswa berhasil diperbarui')),
        );
      }

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali data yang wajib diisi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            elevation: 0, // Hilangkan bayangan bawaan
            flexibleSpace: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Tengah vertikal
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.student == null ? Icons.person_add : Icons.edit,
                            color: Colors.white,
                            size: 26,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.student == null ? 'Tambah Data Siswa' : 'Edit Data Siswa',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4), // Jarak kecil antara judul dan teks
                      const Text(
                        'Mohon isi form dengan benar',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  titlePadding: EdgeInsets.zero, // Hapus padding bawaan
                  collapseMode: CollapseMode.parallax, // Teks tambahan hilang saat collapse
                ),
              ),
            ),
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // Titik-titik 3 di tengah (visual cue)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16),
              child: Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),

          // Form (wrap with Fade+Slide animations)
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Color(0xFFB3E5FC)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        _buildInputField(Icons.badge, "NISN", _nisnController,
                            Validators.requiredValidator,
                            keyboardType: TextInputType.number),
                        _buildInputField(Icons.person, "Nama Lengkap",
                            _namaLengkapController, Validators.requiredValidator),
                        _buildInputField(Icons.wc, "Jenis Kelamin",
                            _jenisKelaminController, Validators.requiredValidator),
                        _buildInputField(Icons.account_balance, "Agama",
                            _agamaController, Validators.requiredValidator),
                        _buildInputField(Icons.location_city, "Tempat Lahir",
                            _tempatLahirController, Validators.requiredValidator),
                        _buildInputField(Icons.calendar_today, "Tanggal Lahir",
                            _tanggalLahirController, Validators.requiredValidator,
                            hintText: 'dd-mm-yyyy'),
                        _buildInputField(Icons.phone, "No. Tlp/HP", _noHpController,
                            Validators.phoneValidator,
                            keyboardType: TextInputType.phone),
                        _buildInputField(Icons.credit_card, "NIK", _nikController,
                            Validators.requiredValidator,
                            keyboardType: TextInputType.number),

                        const SizedBox(height: 18),
                        _sectionTitle("Alamat"),
                        _buildInputField(Icons.map, "Jalan", _jalanController,
                            Validators.requiredValidator),
                        _buildInputField(Icons.format_list_numbered, "RT/RW",
                            _rtRwController, Validators.requiredValidator),
                        _buildInputField(Icons.home_work, "Dusun", _dusunController,
                            Validators.requiredValidator),
                        _buildInputField(Icons.location_on, "Desa", _desaController,
                            Validators.requiredValidator),
                        _buildInputField(Icons.apartment, "Kecamatan",
                            _kecamatanController, Validators.requiredValidator),
                        _buildInputField(Icons.location_city, "Kabupaten",
                            _kabupatenController, Validators.requiredValidator),
                        _buildInputField(Icons.flag, "Provinsi", _provinsiController,
                            Validators.requiredValidator),
                        _buildInputField(Icons.local_post_office, "Kode Pos",
                            _kodePosController, Validators.requiredValidator,
                            keyboardType: TextInputType.number),

                        const SizedBox(height: 18),
                        _sectionTitle("Orang Tua / Wali"),
                        _buildInputField(Icons.male, "Nama Ayah", _namaAyahController,
                            Validators.requiredValidator),
                        _buildInputField(Icons.female, "Nama Ibu", _namaIbuController,
                            Validators.requiredValidator),
                        _buildInputField(Icons.group, "Nama Wali (jika ada)",
                            _namaWaliController, null),
                        _buildInputField(Icons.home, "Alamat Orang Tua",
                            _alamatOrangTuaController, Validators.requiredValidator),

                        const SizedBox(height: 24),

                        // Save button full width
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saveStudent,
                            icon: const Icon(Icons.save),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                "Simpan",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Small helper: section title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      ),
    );
  }

  // Custom input builder with icon and card border
  Widget _buildInputField(
    IconData icon,
    String label,
    TextEditingController controller,
    String? Function(String?)? validator, {
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.lightBlueAccent, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.lightBlueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hintText,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}