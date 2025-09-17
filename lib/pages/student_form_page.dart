import 'package:flutter/material.dart';
import 'package:edu_track/providers/student_provider.dart';
import 'package:edu_track/models/student.dart';
import 'package:edu_track/models/wilayah.dart';
import 'package:edu_track/services/wilayah_service.dart';
import 'package:edu_track/utils/validator.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;

  const StudentFormPage({super.key, this.student});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _showSuccessAnimation = false;

  // Service
  final _wilayahService = WilayahService();

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
  
  // New searchable dusun controller
  late final TextEditingController _dusunController;
  String? _selectedDusun;
  List<String> _filteredDusunList = [];
  bool _isDusunDropdownVisible = false;
  
  String? _selectedDesa;
  String? _selectedKecamatan;
  String? _selectedKabupaten;
  late final TextEditingController _provinsiController;
  late final TextEditingController _kodePosController;
  late final TextEditingController _namaAyahController;
  late final TextEditingController _namaIbuController;
  late final TextEditingController _namaWaliController;
  late final TextEditingController _alamatOrangTuaController;

  // Address data lists
  List<Wilayah> _dusunList = [];
  List<Wilayah> _desaList = [];
  List<Wilayah> _kecamatanList = [];
  List<Wilayah> _kabupatenList = [];

  // Loading states
  bool _loadingDusun = false;
  bool _loadingDesa = false;
  bool _loadingKecamatan = false;
  bool _loadingKabupaten = false;

  // Cache for form data per step
  final Map<int, Map<String, dynamic>> _formDataCache = {};

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
    _namaLengkapController = TextEditingController(text: widget.student?.namaLengkap ?? '');
    _selectedGender = widget.student?.jenisKelamin;
    _selectedReligion = widget.student?.agama;
    _tempatLahirController = TextEditingController(text: widget.student?.tempatLahir ?? '');
    _noHpController = TextEditingController(text: widget.student?.noHp ?? '');
    _nikController = TextEditingController(text: widget.student?.nik ?? '');
    _jalanController = TextEditingController(text: widget.student?.jalan ?? '');
    _rtRwController = TextEditingController(text: widget.student?.rtRw ?? '');
    
    // Initialize searchable dusun controller
    _dusunController = TextEditingController(text: widget.student?.dusun ?? '');
    _selectedDusun = widget.student?.dusun;
    
    _selectedDesa = widget.student?.desa;
    _selectedKecamatan = widget.student?.kecamatan;
    _selectedKabupaten = widget.student?.kabupaten;
    _provinsiController = TextEditingController(text: widget.student?.provinsi ?? '');
    _kodePosController = TextEditingController(text: widget.student?.kodePos ?? '');
    _namaAyahController = TextEditingController(text: widget.student?.namaAyah ?? '');
    _namaIbuController = TextEditingController(text: widget.student?.namaIbu ?? '');
    _namaWaliController = TextEditingController(text: widget.student?.namaWali ?? '');
    _alamatOrangTuaController = TextEditingController(text: widget.student?.alamatOrangTua ?? '');

    // Add listener for dusun text changes
    _dusunController.addListener(_onDusunTextChanged);

    // Load initial data
    _loadDusunData();

    // If editing, load cascading data
    if (widget.student != null) {
      _initializeCascadingData();
    }

    // Initialize cache for the first step
    _cacheFormData();
  }

  void _onDusunTextChanged() {
    final query = _dusunController.text.toLowerCase();
    final allDusunNames = _dusunList
        .map((w) => w.dusun!)
        .where((d) => d.isNotEmpty)
        .toSet()
        .toList();

    setState(() {
      if (query.isEmpty) {
        _filteredDusunList = allDusunNames..sort();
      } else {
        _filteredDusunList = allDusunNames
            .where((dusun) => dusun.toLowerCase().contains(query))
            .toList()
          ..sort();
      }
      _isDusunDropdownVisible = query.isNotEmpty && _filteredDusunList.isNotEmpty;
    });
  }

  void _selectDusun(String dusun) {
    setState(() {
      _dusunController.text = dusun;
      _selectedDusun = dusun;
      _isDusunDropdownVisible = false;
      
      // Clear dependent fields
      _selectedDesa = null;
      _selectedKecamatan = null;
      _selectedKabupaten = null;
      _desaList.clear();
      _kecamatanList.clear();
      _kabupatenList.clear();
    });
    
    _loadDesaData(dusun);
    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  Future<void> _initializeCascadingData() async {
    if (_selectedDusun != null) {
      await _loadDesaData(_selectedDusun!);
      if (_selectedDesa != null) {
        await _loadKecamatanData(_selectedDesa!);
        if (_selectedKecamatan != null) {
          await _loadKabupatenData(_selectedKecamatan!);
        }
      }
    }
  }

  Future<void> _loadDusunData() async {
    setState(() => _loadingDusun = true);
    try {
      final dusunList = await _wilayahService.getDusunList();
      setState(() {
        _dusunList = dusunList;
        _loadingDusun = false;
        
        // Initialize filtered list
        final allDusunNames = dusunList
            .map((w) => w.dusun!)
            .where((d) => d.isNotEmpty)
            .toSet()
            .toList()..sort();
        _filteredDusunList = allDusunNames;
        
        // Auto-select first Dusun if available and not editing
        if (_selectedDusun == null && widget.student == null && dusunList.isNotEmpty) {
          final firstDusun = dusunList.first.dusun!;
          _selectedDusun = firstDusun;
          _dusunController.text = firstDusun;
          _loadDesaData(_selectedDusun!);
        }
      });
    } catch (e) {
      setState(() => _loadingDusun = false);
      _showError('Error loading dusun: $e');
    }
  }

  Future<void> _loadDesaData(String dusunName) async {
    setState(() => _loadingDesa = true);
    try {
      final desaList = await _wilayahService.getDesaByDusun(dusunName);
      setState(() {
        _desaList = desaList;
        _loadingDesa = false;
        // Clear subsequent fields
        if (_selectedDesa != null && !desaList.any((d) => d.desa == _selectedDesa)) {
          _selectedDesa = null;
          _selectedKecamatan = null;
          _selectedKabupaten = null;
          _kecamatanList.clear();
          _kabupatenList.clear();
        }
        // Auto-select first Desa if available and not editing
        if (_selectedDesa == null && desaList.isNotEmpty && widget.student == null) {
          _selectedDesa = desaList.first.desa;
          _loadKecamatanData(_selectedDesa!);
        }
      });
      // Force UI refresh after data is loaded
      if (_selectedDesa != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      }
    } catch (e) {
      setState(() => _loadingDesa = false);
      _showError('Error loading desa: $e');
    }
  }

  Future<void> _loadKecamatanData(String desaName) async {
    setState(() => _loadingKecamatan = true);
    try {
      final kecamatanList = await _wilayahService.getKecamatanByDesa(desaName);
      setState(() {
        _kecamatanList = kecamatanList;
        _loadingKecamatan = false;
        // Clear subsequent fields
        if (_selectedKecamatan != null && !kecamatanList.any((k) => k.kecamatan == _selectedKecamatan)) {
          _selectedKecamatan = null;
          _selectedKabupaten = null;
          _kabupatenList.clear();
        }
        // Auto-select first Kecamatan if available and not editing
        if (_selectedKecamatan == null && kecamatanList.isNotEmpty && widget.student == null) {
          _selectedKecamatan = kecamatanList.first.kecamatan;
          _loadKabupatenData(_selectedKecamatan!);
        }
      });
      // Force UI refresh after data is loaded
      if (_selectedKecamatan != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      }
    } catch (e) {
      setState(() => _loadingKecamatan = false);
      _showError('Error loading kecamatan: $e');
    }
  }

  Future<void> _loadKabupatenData(String kecamatanName) async {
    setState(() => _loadingKabupaten = true);
    try {
      final kabupatenList = await _wilayahService.getKabupatenByKecamatan(kecamatanName);
      setState(() {
        _kabupatenList = kabupatenList;
        _loadingKabupaten = false;
        // Clear subsequent fields
        if (_selectedKabupaten != null && !kabupatenList.any((k) => k.kabupaten == _selectedKabupaten)) {
          _selectedKabupaten = null;
        }
        // Auto-select first Kabupaten if available and not editing
        if (_selectedKabupaten == null && kabupatenList.isNotEmpty && widget.student == null) {
          _selectedKabupaten = kabupatenList.first.kabupaten;
        }
      });
      // Force UI refresh after data is loaded
      if (_selectedKabupaten != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      }
    } catch (e) {
      setState(() => _loadingKabupaten = false);
      _showError('Error loading kabupaten: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Get days in month
  int _daysInMonth(int year, int month) {
    if (month == 2) {
      return DateTime(year, month + 1, 0).day;
    }
    return month <= 7 ? (month % 2 == 1 ? 31 : 30) : (month % 2 == 0 ? 31 : 30);
  }

  // Cache current form data for the current step
  void _cacheFormData() {
    _formDataCache[_currentStep] = {
      if (_currentStep == 0) ...{
        'nisn': _nisnController.text,
        'namaLengkap': _namaLengkapController.text,
        'gender': _selectedGender,
        'religion': _selectedReligion,
        'tempatLahir': _tempatLahirController.text,
        'year': _selectedYear,
        'month': _selectedMonth,
        'day': _selectedDay,
        'noHp': _noHpController.text,
        'nik': _nikController.text,
      },
      if (_currentStep == 1) ...{
        'jalan': _jalanController.text,
        'rtRw': _rtRwController.text,
        'dusun': _selectedDusun,
        'desa': _selectedDesa,
        'kecamatan': _selectedKecamatan,
        'kabupaten': _selectedKabupaten,
        'provinsi': _provinsiController.text,
        'kodePos': _kodePosController.text,
      },
      if (_currentStep == 2) ...{
        'namaAyah': _namaAyahController.text,
        'namaIbu': _namaIbuController.text,
        'namaWali': _namaWaliController.text,
        'alamatOrangTua': _alamatOrangTuaController.text,
      },
    };
  }

  // Restore form data for the given step
  void _restoreFormData(int step) {
    final cachedData = _formDataCache[step];
    if (cachedData == null) return;

    setState(() {
      if (step == 0) {
        _nisnController.text = cachedData['nisn'] ?? '';
        _namaLengkapController.text = cachedData['namaLengkap'] ?? '';
        _selectedGender = cachedData['gender'];
        _selectedReligion = cachedData['religion'];
        _tempatLahirController.text = cachedData['tempatLahir'] ?? '';
        _selectedYear = cachedData['year'];
        _selectedMonth = cachedData['month'];
        _selectedDay = cachedData['day'];
        _noHpController.text = cachedData['noHp'] ?? '';
        _nikController.text = cachedData['nik'] ?? '';
      } else if (step == 1) {
        _jalanController.text = cachedData['jalan'] ?? '';
        _rtRwController.text = cachedData['rtRw'] ?? '';
        _selectedDusun = cachedData['dusun'];
        _dusunController.text = _selectedDusun ?? '';
        _selectedDesa = cachedData['desa'];
        _selectedKecamatan = cachedData['kecamatan'];
        _selectedKabupaten = cachedData['kabupaten'];
        _provinsiController.text = cachedData['provinsi'] ?? '';
        _kodePosController.text = cachedData['kodePos'] ?? '';
        if (_selectedDusun != null) _loadDesaData(_selectedDusun!);
        if (_selectedDesa != null) _loadKecamatanData(_selectedDesa!);
        if (_selectedKecamatan != null) _loadKabupatenData(_selectedKecamatan!);
      } else if (step == 2) {
        _namaAyahController.text = cachedData['namaAyah'] ?? '';
        _namaIbuController.text = cachedData['namaIbu'] ?? '';
        _namaWaliController.text = cachedData['namaWali'] ?? '';
        _alamatOrangTuaController.text = cachedData['alamatOrangTua'] ?? '';
      }
    });
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
    _provinsiController.dispose();
    _kodePosController.dispose();
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _namaWaliController.dispose();
    _alamatOrangTuaController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      return _nisnController.text.isNotEmpty &&
          _namaLengkapController.text.isNotEmpty &&
          _selectedGender != null &&
          _selectedReligion != null &&
          _tempatLahirController.text.isNotEmpty &&
          _selectedYear != null &&
          _selectedMonth != null &&
          _selectedDay != null &&
          Validators.phoneValidator(_noHpController.text) == null &&
          Validators.requiredValidator(_nikController.text) == null;
    } else if (_currentStep == 1) {
      return Validators.requiredValidator(_jalanController.text) == null &&
          Validators.requiredValidator(_rtRwController.text) == null &&
          _selectedDusun != null &&
          _selectedDesa != null &&
          _selectedKecamatan != null &&
          _selectedKabupaten != null &&
          Validators.requiredValidator(_provinsiController.text) == null &&
          Validators.requiredValidator(_kodePosController.text) == null;
    } else if (_currentStep == 2) {
      return Validators.requiredValidator(_namaAyahController.text) == null &&
          Validators.requiredValidator(_namaIbuController.text) == null &&
          Validators.requiredValidator(_alamatOrangTuaController.text) == null;
    }
    return false;
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate() && _validateCurrentStep()) {
      // Validate date selection
      if (_selectedYear == null || _selectedMonth == null || _selectedDay == null) {
        _showError('Tanggal Lahir wajib diisi lengkap');
        return;
      }

      // Validate address selections
      if (_selectedDusun == null || _selectedDesa == null || 
          _selectedKecamatan == null || _selectedKabupaten == null) {
        _showError('Alamat wilayah wajib dipilih lengkap');
        return;
      }

      final selectedDate = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
      if (selectedDate.isAfter(DateTime.now()) || selectedDate.isBefore(DateTime(1990))) {
        _showError('Tanggal Lahir tidak valid');
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
        dusun: _selectedDusun!,
        desa: _selectedDesa!,
        kecamatan: _selectedKecamatan!,
        kabupaten: _selectedKabupaten!,
        provinsi: _provinsiController.text.trim(),
        kodePos: _kodePosController.text.trim(),
        namaAyah: _namaAyahController.text.trim(),
        namaIbu: _namaIbuController.text.trim(),
        namaWali: _namaWaliController.text.trim().isEmpty ? null : _namaWaliController.text.trim(),
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
              widget.student == null ? 'Siswa berhasil ditambahkan ✅' : 'Data siswa berhasil diperbarui ✅',
            ),
          ),
        );
        Navigator.pop(context);
      });
    } else {
      _showError('Periksa kembali data yang wajib diisi');
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

  Widget _buildSearchableDusunField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _dusunController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.home_work, color: Colors.lightBlueAccent),
              labelText: "Dusun",
              hintText: "Ketik untuk mencari dusun...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: _loadingDusun 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.search, color: Colors.grey[600]),
            ),
            validator: (val) {
              if (_selectedDusun == null || _selectedDusun!.isEmpty) {
                return "Wajib dipilih";
              }
              return null;
            },
            onTap: () {
              setState(() {
                _isDusunDropdownVisible = true;
              });
            },
          ),
          if (_isDusunDropdownVisible && _filteredDusunList.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredDusunList.length,
                itemBuilder: (context, index) {
                  final dusun = _filteredDusunList[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      dusun,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _selectedDusun == dusun 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                      ),
                    ),
                    leading: Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.lightBlueAccent,
                    ),
                    onTap: () => _selectDusun(dusun),
                    tileColor: _selectedDusun == dusun 
                      ? Colors.lightBlueAccent.withOpacity(0.1) 
                      : null,
                  );
                },
              ),
            ),
        ],
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
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildWilayahDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    required String? Function(String?)? validator,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.lightBlueAccent),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: isEnabled ? Colors.white : Colors.grey[100],
        ),
        items: items.isEmpty
            ? null
            : items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: isEnabled && !isLoading ? onChanged : null,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(36, (index) => 1990 + index);
    final months = List.generate(12, (index) => index + 1);
    int maxDays = 31;
    if (_selectedMonth != null && _selectedYear != null) {
      maxDays = _daysInMonth(_selectedYear!, _selectedMonth!);
    }
    final days = List.generate(maxDays, (index) => index + 1);

    return GestureDetector(
      onTap: () {
        // Hide dropdown when tapping outside
        setState(() {
          _isDusunDropdownVisible = false;
        });
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                  color: Colors.white,
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
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
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_validateCurrentStep()) {
                        _cacheFormData();
                        if (_currentStep < 2) {
                          setState(() {
                            _currentStep += 1;
                            _restoreFormData(_currentStep);
                          });
                        } else {
                          _saveStudent();
                        }
                      } else {
                        _formKey.currentState!.validate();
                        _showError('Periksa kembali data yang wajib diisi');
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep -= 1;
                          _restoreFormData(_currentStep);
                        });
                      }
                    },
                    onStepTapped: (step) {
                      if (_validateCurrentStep()) {
                        _cacheFormData();
                        setState(() {
                          _currentStep = step;
                          _restoreFormData(_currentStep);
                        });
                      } else {
                        _formKey.currentState!.validate();
                        _showError('Periksa kembali data yang wajib diisi');
                      }
                    },
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_currentStep > 0)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ElevatedButton(
                                    onPressed: details.onStepCancel,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton(
                                  onPressed: _currentStep == 2 && _validateCurrentStep()
                                      ? _saveStudent
                                      : details.onStepContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _currentStep == 2 ? Colors.green : Colors.lightBlueAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text(_currentStep == 2 ? 'Submit' : 'Continue'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
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
                                keyboardType: TextInputType.number, validator: Validators.requiredValidator),
                            _buildInputField('Nama Lengkap', _namaLengkapController, Icons.person,
                                validator: Validators.requiredValidator),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: DropdownButtonFormField<String>(
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
                            ),
                            _buildInputField('Tempat Lahir', _tempatLahirController, Icons.location_city,
                                validator: Validators.requiredValidator),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: DropdownButtonFormField<String>(
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
                            ),
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
                            _buildSearchableDusunField(),
                            _buildWilayahDropdown(
                              label: "Desa",
                              icon: Icons.villa,
                              items: _desaList.map((w) => w.desa!).where((d) => d.isNotEmpty).toSet().toList()..sort(),
                              value: _selectedDesa,
                              onChanged: (val) {
                                setState(() {
                                  _selectedDesa = val;
                                  _selectedKecamatan = null;
                                  _selectedKabupaten = null;
                                  _kecamatanList.clear();
                                  _kabupatenList.clear();
                                });
                                if (val != null) {
                                  _loadKecamatanData(val);
                                }
                              },
                              validator: (val) => val == null ? "Wajib dipilih" : null,
                              isLoading: _loadingDesa,
                              isEnabled: _selectedDusun != null,
                            ),
                            _buildWilayahDropdown(
                              label: "Kecamatan",
                              icon: Icons.apartment,
                              items: _kecamatanList.map((w) => w.kecamatan!).where((k) => k.isNotEmpty).toSet().toList()..sort(),
                              value: _selectedKecamatan,
                              onChanged: (val) {
                                setState(() {
                                  _selectedKecamatan = val;
                                  _selectedKabupaten = null;
                                  _kabupatenList.clear();
                                });
                                if (val != null) {
                                  _loadKabupatenData(val);
                                }
                              },
                              validator: (val) => val == null ? "Wajib dipilih" : null,
                              isLoading: _loadingKecamatan,
                              isEnabled: _selectedDesa != null,
                            ),
                            _buildWilayahDropdown(
                              label: "Kabupaten",
                              icon: Icons.location_city,
                              items: _kabupatenList.map((w) => w.kabupaten!).where((k) => k.isNotEmpty).toSet().toList()..sort(),
                              value: _selectedKabupaten,
                              onChanged: (val) {
                                setState(() => _selectedKabupaten = val);
                              },
                              validator: (val) => val == null ? "Wajib dipilih" : null,
                              isLoading: _loadingKabupaten,
                              isEnabled: _selectedKecamatan != null,
                            ),
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
      ),
    );
  }
}