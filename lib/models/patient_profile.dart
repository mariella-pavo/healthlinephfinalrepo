
import 'package:flutter/material.dart';

class PatientProfile extends ChangeNotifier {
  PatientProfile._();

  static final PatientProfile instance = PatientProfile._();

  String name = 'Joyce Jimenez';
  int age = 25;
  String? photoUrl;

  void updateProfile({
    String? name,
    int? age,
    String? photoUrl,
  }) {
    if (name != null) this.name = name;
    if (age != null) this.age = age;
    if (photoUrl != null) this.photoUrl = photoUrl;

    notifyListeners();
  }
}
