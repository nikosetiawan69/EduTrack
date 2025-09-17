import 'package:flutter/material.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:edu_track/models/student.dart';
import 'package:edu_track/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;

  const StudentFormPage({super.key, this.student});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _showSuccessAnimation = false;

  // Animations for form content
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // Animation for success
  late final AnimationController _successAnimationController;
  late final Animation<double> _successFadeAnimation;
  late final Animation<double> _successScaleAnimation;

  // Controllers
  late final TextEditingController _nisnController;
  late final TextEditingController _namaLengkapController;
  String? _selectedGender;
  String? _selectedReligion;
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;
  late final TextEditingController _tempatLahirController;
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

    // Parse initial date if editing
    if (widget.student?.tanggalLahir != null) {
      final parsedDate = DateTime.tryParse(widget.student!.tanggalLahir);
      if (parsedDate != null) {
        _selectedYear = parsedDate.year;
        _selectedMonth = parsedDate.month;
        _selectedDay = parsedDate.day;
      }
    }

    // Init form content animation
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

    // Init success animation
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _successFadeAnimation = CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.easeIn,
    );
    _successScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _successAnimationController, curve: Curves.elasticOut),
    );

    // Init controllers with optional initial student data
    _nisnController = TextEditingController(text: widget.student?.nisn ?? '');
    _namaLengkapController =
        TextEditingController(text: widget.student?.namaLengkap ?? '');
    _selectedGender = widget.student?.jenisKelamin;
    _selectedReligion = widget.student?.agama;
    _tempatLahirController =
        TextEditingController(text: widget.student?.tempatLahir ?? '');
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
    _kodePosController =
        TextEditingController(text: widget.student?.kodePos ?? '');
    _namaAyahController =
        TextEditingController(text: widget.student?.namaAyah ?? '');
    _namaIbuController =
        TextEditingController(text: widget.student?.namaIbu ?? '');
    _namaWaliController =
        TextEditingController(text: widget.student?.namaWali ?? '');
    _alamatOrangTuaController =
        TextEditingController(text: widget.student?.alamatOrangTua ?? '');
  }

  // Get days in month
  int _daysInMonth(int year, int month) {
    if (month == 2) {
      return DateTime(year, month + 1, 0).day; // Accounts for leap year
    }
    return month <= 7 ? (month % 2 == 1 ? 31 : 30) : (month % 2 == 0 ? 31 : 30);
  }

  @override
  void dispose() {
    _controller.dispose();
    _successAnimationController.dispose();
    _nisnController.dispose();
    _namaLengkapController.dispose();
    _tempatLahirController.dispose();
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
      // Validate date selection
      if (_selectedYear == null || _selectedMonth == null || _selectedDay == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal Lahir wajib diisi lengkap')),
        );
        return;
      }

      final selectedDate = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
      if (selectedDate.isAfter(DateTime.now()) || selectedDate.isBefore(DateTime(1990))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal Lahir tidak valid')),
        );
        return;
      }

      setState(() => _showSuccessAnimation = true);
      _successAnimationController.forward();
      final student = Student(
        nisn: _nisnController.text.trim(),
        namaLengkap: _namaLengkapController.text.trim(),
        jenisKelamin: _selectedGender ?? '',
        agama: _selectedReligion ?? '',
        tempatLahir: _tempatLahirController.text.trim(),
        tanggalLahir: "${_selectedDay}-${_selectedMonth}-${_selectedYear}",
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
      } else {
        provider.updateStudent(widget.student!.nisn, student);
      }

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _showSuccessAnimation = false);
        _successAnimationController.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.student == null
                  ? 'Siswa berhasil ditambahkan ✅'
                  : 'Data siswa berhasil diperbarui ✅',
            ),
          ),
        );
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periksa kembali data yang wajib diisi')),
      );
    }
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.lightBlueAccent),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDateDropdown({
    required String label,
    required List<int> items,
    required int? value,
    required void Function(int?) onChanged,
    required String? Function(int?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.arrow_drop_down, color: Colors.lightBlueAccent),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate year, month, day lists
    final years = List.generate(36, (index) => 1990 + index);
    final months = List.generate(12, (index) => index + 1);
    int maxDays = 31;
    if (_selectedMonth != null && _selectedYear != null) {
      maxDays = _daysInMonth(_selectedYear!, _selectedMonth!);
    }
    final days = List.generate(maxDays, (index) => index + 1);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: AppBar(
            title: Text(
              widget.student == null ? 'Tambah Data Siswa' : 'Edit Data Siswa',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Form(
                key: _formKey,
                child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep += 1);
                    } else {
                      _saveStudent();
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep -= 1);
                    }
                  },
                  onStepTapped: (step) {
                    setState(() => _currentStep = step);
                  },
                  steps: [
                    Step(
                      title: GestureDetector(
                        onTap: () => setState(() => _currentStep = 0),
                        child: const Text(
                          "Data Diri",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                      content: Column(
                        children: [
                          _buildInputField('NISN', _nisnController, Icons.badge,
                              keyboardType: TextInputType.number,
                              validator: Validators.requiredValidator),
                          _buildInputField('Nama Lengkap', _namaLengkapController, Icons.person,
                              validator: Validators.requiredValidator),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.wc, color: Colors.lightBlueAccent),
                              labelText: "Jenis Kelamin",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: ["Laki-laki", "Perempuan"]
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => setState(() => _selectedGender = val),
                            validator: (val) => val == null ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 12),
                          _buildInputField('Tempat Lahir', _tempatLahirController, Icons.location_city,
                              validator: Validators.requiredValidator),
                          // Date selection with separate dropdowns (navbar-like)
                          Row(
                            children: [
                              Expanded(
                                child: _buildDateDropdown(
                                  label: "Tahun",
                                  items: years,
                                  value: _selectedYear,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedYear = val;
                                      // Reset month and day if year changes
                                      if (val != null && _selectedMonth != null) {
                                        final daysInNewMonth = _daysInMonth(val, _selectedMonth!);
                                        if (_selectedDay != null && _selectedDay! > daysInNewMonth) {
                                          _selectedDay = daysInNewMonth;
                                        }
                                      } else {
                                        _selectedMonth = null;
                                        _selectedDay = null;
                                      }
                                    });
                                  },
                                  validator: (val) => val == null ? "Tahun wajib" : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDateDropdown(
                                  label: "Bulan",
                                  items: months,
                                  value: _selectedMonth,
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedMonth = val;
                                      // Reset day if month changes
                                      if (val != null && _selectedYear != null) {
                                        final daysInMonth = _daysInMonth(_selectedYear!, val);
                                        if (_selectedDay != null && _selectedDay! > daysInMonth) {
                                          _selectedDay = daysInMonth;
                                        }
                                      } else {
                                        _selectedDay = null;
                                      }
                                    });
                                  },
                                  validator: (val) => val == null ? "Bulan wajib" : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDateDropdown(
                                  label: "Hari",
                                  items: days,
                                  value: _selectedDay,
                                  onChanged: (val) => setState(() => _selectedDay = val),
                                  validator: (val) => val == null ? "Hari wajib" : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _selectedReligion,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.self_improvement, color: Colors.lightBlueAccent),
                              labelText: "Agama",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: ["Islam", "Kristen", "Katolik", "Hindu", "Budha", "Konghucu"]
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (val) => setState(() => _selectedReligion = val),
                            validator: (val) => val == null ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 12),
                          _buildInputField('No. Tlp/HP', _noHpController, Icons.phone,
                              keyboardType: TextInputType.phone, validator: Validators.phoneValidator),
                          _buildInputField('NIK', _nikController, Icons.credit_card,
                              keyboardType: TextInputType.number, validator: Validators.requiredValidator),
                        ],
                      ),
                    ),
                    Step(
                      title: GestureDetector(
                        onTap: () => setState(() => _currentStep = 1),
                        child: const Text(
                          "Alamat",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                      content: Column(
                        children: [
                          _buildInputField('Jalan', _jalanController, Icons.map,
                              validator: Validators.requiredValidator),
                          _buildInputField('RT/RW', _rtRwController, Icons.format_list_numbered,
                              validator: Validators.requiredValidator),
                          _buildInputField('Dusun', _dusunController, Icons.home_work,
                              validator: Validators.requiredValidator),
                          _buildInputField('Desa', _desaController, Icons.villa,
                              validator: Validators.requiredValidator),
                          _buildInputField('Kecamatan', _kecamatanController, Icons.apartment,
                              validator: Validators.requiredValidator),
                          _buildInputField('Kabupaten', _kabupatenController, Icons.location_city,
                              validator: Validators.requiredValidator),
                          _buildInputField('Provinsi', _provinsiController, Icons.flag,
                              validator: Validators.requiredValidator),
                          _buildInputField('Kode Pos', _kodePosController, Icons.local_post_office,
                              keyboardType: TextInputType.number, validator: Validators.requiredValidator),
                        ],
                      ),
                    ),
                    Step(
                      title: GestureDetector(
                        onTap: () => setState(() => _currentStep = 2),
                        child: const Text(
                          "Orang Tua",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      isActive: _currentStep >= 2,
                      state: _currentStep == 2 ? StepState.editing : StepState.indexed,
                      content: Column(
                        children: [
                          _buildInputField('Nama Ayah', _namaAyahController, Icons.male,
                              validator: Validators.requiredValidator),
                          _buildInputField('Nama Ibu', _namaIbuController, Icons.female,
                              validator: Validators.requiredValidator),
                          _buildInputField('Nama Wali (jika ada)', _namaWaliController, Icons.group),
                          _buildInputField('Alamat Orang Tua', _alamatOrangTuaController, Icons.home,
                              validator: Validators.requiredValidator),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showSuccessAnimation)
            Stack(
              children: [
                // Dark overlay to dim the background
                Container(
                  color: Colors.black.withOpacity(0.6),
                ),
                Center(
                  child: FadeTransition(
                    opacity: _successFadeAnimation,
                    child: ScaleTransition(
                      scale: _successScaleAnimation,
                      child: Lottie.network(
                        'https://assets4.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}