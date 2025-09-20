import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityGuard extends StatefulWidget {
  final Widget child;

  const ConnectivityGuard({super.key, required this.child});

  @override
  State<ConnectivityGuard> createState() => _ConnectivityGuardState();
}

class _ConnectivityGuardState extends State<ConnectivityGuard> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _dialogShown = false;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _startListening();
      // 🔑 kasih delay dikit biar nggak langsung ngecek pas app baru jalan
      await Future.delayed(const Duration(seconds: 1));
      _checkNow();
    });
  }

  void _startListening() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkNow();
    });
  }

  Future<void> _checkNow() async {
    // 🔑 cek internet 2x biar lebih yakin
    bool hasNet = await _hasActualInternet();
    if (!hasNet) {
      await Future.delayed(const Duration(milliseconds: 500));
      hasNet = await _hasActualInternet();
    }

    if (!mounted) return;

    // 🔑 hanya ubah state kalau beda dari sebelumnya
    if (hasNet && _offline) {
      setState(() => _offline = false);
      _hideDialogIfAny();
    } else if (!hasNet && !_offline) {
      setState(() => _offline = true);
      _showOfflineDialog();
    }
  }

  Future<bool> _hasActualInternet() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final bool anyConnected =
          results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);
      if (!anyConnected) return false;

      final response = await http
          .get(Uri.parse('https://www.google.com/generate_204'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void _showOfflineDialog() {
    if (_dialogShown) return;
    _dialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 480;
            final EdgeInsets padding = isWide
                ? const EdgeInsets.all(32)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 24);
            final double iconSize = isWide ? 96 : 72;

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.purple.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: iconSize + 24,
                      height: iconSize + 24,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.wifi_off,
                        color: Colors.red,
                        size: iconSize,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tidak Ada Internet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Periksa koneksi Wi-Fi atau data seluler Anda.\n'
                      'Aplikasi akan melanjutkan otomatis saat internet kembali.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: isWide ? 160 : 130,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              await _checkNow();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: isWide ? 160 : 130,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await _checkNow();
                              if (!_offline && mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Saya Sudah Online'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _dialogShown = false;
    });
  }

  void _hideDialogIfAny() {
    if (_dialogShown && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      _dialogShown = false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
