import 'package:flutter/material.dart';
import 'package:edu_track/models/student.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  const StudentDetailPage({super.key, required this.student});

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFE2E8F0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Enhanced SliverAppBar with hero effect
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
  background: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: SingleChildScrollView( // ⬅️ ini penting biar tidak overflow
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        widget.student.namaLengkap.isNotEmpty
                            ? widget.student.namaLengkap[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nama
                  Text(
                    widget.student.namaLengkap,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  // NISN
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'NISN: ${widget.student.nisn}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  ),
),

              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            
            // Content sections
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildSectionCard(
                          icon: Icons.person_rounded,
                          title: 'Data Pribadi',
                          color: const Color(0xFF3B82F6),
                          children: [
                            _buildDetailTile(Icons.badge, 'NISN', widget.student.nisn),
                            _buildDetailTile(Icons.person_outline, 'Nama Lengkap', widget.student.namaLengkap),
                            _buildDetailTile(Icons.wc, 'Jenis Kelamin', widget.student.jenisKelamin),
                            _buildDetailTile(Icons.self_improvement, 'Agama', widget.student.agama),
                            _buildDetailTile(Icons.cake_rounded, 'Tempat, Tanggal Lahir', '${widget.student.tempatLahir}, ${widget.student.tanggalLahir}'),
                            _buildDetailTile(Icons.phone_android, 'No. Tlp/HP', widget.student.noHp ?? '-'),
                            _buildDetailTile(Icons.credit_card, 'NIK', widget.student.nik),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildSectionCard(
                          icon: Icons.location_on_rounded,
                          title: 'Alamat',
                          color: const Color(0xFF10B981),
                          children: [
                            _buildDetailTile(Icons.add_road, 'Jalan', widget.student.jalan ?? '-'),
                            _buildDetailTile(Icons.home_work_rounded, 'RT/RW', widget.student.rtRw ?? '-'),
                            _buildDetailTile(Icons.landscape_rounded, 'Dusun', widget.student.dusun),
                            _buildDetailTile(Icons.villa_rounded, 'Desa', widget.student.desa),
                            _buildDetailTile(Icons.apartment_rounded, 'Kecamatan', widget.student.kecamatan),
                            _buildDetailTile(Icons.location_city_rounded, 'Kabupaten', widget.student.kabupaten),
                            _buildDetailTile(Icons.flag_rounded, 'Provinsi', widget.student.provinsi),
                            _buildDetailTile(Icons.local_post_office_rounded, 'Kode Pos', widget.student.kodePos),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildSectionCard(
                          icon: Icons.family_restroom_rounded,
                          title: 'Orang Tua/Wali',
                          color: const Color(0xFFF59E0B),
                          children: [
                            _buildDetailTile(Icons.man_rounded, 'Nama Ayah', widget.student.namaAyah),
                            _buildDetailTile(Icons.woman_rounded, 'Nama Ibu', widget.student.namaIbu),
                            if (widget.student.namaWali != null)
                              _buildDetailTile(Icons.supervisor_account_rounded, 'Nama Wali', widget.student.namaWali!),
                            _buildDetailTile(Icons.home_rounded, 'Alamat Orang Tua', widget.student.alamatOrangTua),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          
          // Section content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF64748B),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}