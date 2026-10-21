
import 'package:flutter/material.dart';
import '../models/patient_profile.dart';
import '../widgets/bottom_navigation.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends State<ProfileSettingsScreen> {
  final PatientProfile profile = PatientProfile.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  DateTime? _dateOfBirth;
  String? _photoUrl;

  static const Color _mutedMauve = Color(0xFF806666);
  static const Color _mutedText = Color(0xFFBDBDBD);
  static const Color _activeRed = Color(0xFFFF3038);

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: profile.name);
    _phoneController =
        TextEditingController(text: profile.phoneNumber);
    _addressController =
        TextEditingController(text: profile.address);
    _notesController =
        TextEditingController(text: profile.medicalNotes);

    _dateOfBirth = profile.dateOfBirth;
    _photoUrl = profile.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _activeRed,
            surface: Color(0xFF292020),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _changePhoto() async {
    final controller = TextEditingController(text: _photoUrl);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF292020),
        title: const Text(
          'Change Photo',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter image URL',
            hintStyle: TextStyle(color: _mutedText),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (result != null) {
      setState(() {
        _photoUrl = result.isEmpty ? null : result;
      });
    }
  }

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.')),
      );
      return;
    }

    profile.updateProfile(
      name: _nameController.text.trim(),
      dateOfBirth: _dateOfBirth,
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      medicalNotes: _notesController.text.trim(),
      photoUrl: _photoUrl,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
            ),
          ),
          TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 8, top: 8),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _mutedText),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _activeRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const Text(
                    'Profile and Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _changePhoto,
                      child: Container(
                        width: 68,
                        height: 68,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9D9D9),
                        ),
                        child: _photoUrl != null &&
                                _photoUrl!.isNotEmpty
                            ? Image.network(
                                _photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.person, size: 35),
                              )
                            : const Icon(
                                Icons.person,
                                color: Color(0xFFD9D9D9),
                                size: 1,
                              ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: _changePhoto,
                      child: const Text(
                        'Change Photo',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 9,
                        ),
                      ),
                    ),

                    const SizedBox(height: 38),

                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Personal Information',
                        style: TextStyle(
                          color: _mutedText,
                          fontSize: 9,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _field('Full Name', _nameController),

                    InkWell(
                      onTap: _selectDate,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date of Birth',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _mutedText,
                                  ),
                                ),
                              ),
                              child: Text(
                                _dateOfBirth == null
                                    ? 'Select date of birth'
                                    : '${_dateOfBirth!.day.toString().padLeft(2, '0')}/'
                                      '${_dateOfBirth!.month.toString().padLeft(2, '0')}/'
                                      '${_dateOfBirth!.year}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    _field('Phone Number', _phoneController),
                    _field('Address', _addressController),
                    _field('Medical Notes', _notesController),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        foregroundColor: _activeRed,
                        minimumSize: const Size(48, 28),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const HealthLineBottomNavigation(selectedIndex: 3),
          ],
        ),
      ),
    );
  }
}
