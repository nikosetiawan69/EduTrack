// lib/utils/validators.dart
class Validators {
  static String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini wajib diisi';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor telepon harus berupa angka';
    }
    return null;
  }
}