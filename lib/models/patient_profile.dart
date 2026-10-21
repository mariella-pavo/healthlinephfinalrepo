
import 'package:flutter/material.dart';

class PatientProfile extends ChangeNotifier {
  PatientProfile._();

  static final PatientProfile instance = PatientProfile._();

  String name = 'Joyce Jimenez';
  DateTime? dateOfBirth;
  String phoneNumber = '';
  String address = '';
  String medicalNotes = '';
  String? photoUrl;

  int get age {
    if (dateOfBirth == null) return 0;

    final today = DateTime.now();
    int result = today.year - dateOfBirth!.year;

    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month &&
            today.day < dateOfBirth!.day)) {
      result--;
    }

    return result;
  }

  void updateProfile({
    required String name,
    required DateTime? dateOfBirth,
    required String phoneNumber,
    required String address,
    required String medicalNotes,
    String? photoUrl,
  }) {
    this.name = name;
    this.dateOfBirth = dateOfBirth;
    this.phoneNumber = phoneNumber;
    this.address = address;
    this.medicalNotes = medicalNotes;
    this.photoUrl = photoUrl;
    notifyListeners();
  }
}