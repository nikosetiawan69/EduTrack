// lib/providers/student_provider.dart
import 'package:flutter/material.dart';
import 'package:edu_track/models/student.dart';

class StudentProvider extends ChangeNotifier {
  final List<Student> _students = [];

  List<Student> get students => _students;

  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  void updateStudent(String nisn, Student updatedStudent) {
    final index = _students.indexWhere((s) => s.nisn == nisn);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }

  void deleteStudent(String nisn) {
    _students.removeWhere((s) => s.nisn == nisn);
    notifyListeners();
  }

  Student? getStudentByNisn(String nisn) {
    try {
      return _students.firstWhere((s) => s.nisn == nisn);
    } catch (e) {
      return null;
    }
  }
}