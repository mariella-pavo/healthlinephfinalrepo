
import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../models/patient_profile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const Color _background = Color(0xFF101010);
  static const Color _surface = Color(0xFF1C1A1A);
  static const Color _mauve = Color(0xFF806666);
  static const Color _accent = Color(0xFFFF454D);
  static const Color _muted = Color(0xFFAAAAAA);

  final List<Map<String, String>> _services = [
    {'name': 'Check-up', 'icon': 'medical'},
    {'name': 'Vaccination', 'icon': 'vaccination'},
    {'name': 'Laboratory', 'icon': 'laboratory'},
    {'name': 'Dental Care', 'icon': 'dental'},
  ];

  final List<Map<String, String>> _doctors = [
    {
      'name': 'Dr. John Doe',
      'specialty': 'Internal Medicine',
      'rating': '5.0',
      'reviews': '123 reviews',
    },
    {
      'name': 'Dr. Maria Santos',
      'specialty': 'Pediatrics',
      'rating': '4.9',
      'reviews': '98 reviews',
    },
    {
      'name': 'Dr. Alex Reyes',
      'specialty': 'Cardiology',
      'rating': '4.8',
      'reviews': '87 reviews',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void _showService(String service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$service selected'),
        backgroundColor: _mauve,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = PatientProfile.instance;

    final filteredDoctors = _doctors.where((doctor) {
      final query = _searchQuery.toLowerCase();
      return doctor['name']!.toLowerCase().contains(query) ||
          doctor['specialty']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: profile,
          builder: (context, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
                        _buildHeader(profile),
                        const SizedBox(height: 28),
                        _buildGreeting(profile),
                        const SizedBox(height: 22),
                        _buildSearch(),
                        const SizedBox(height: 30),
                        _buildSectionHeader(
                          'Popular Services',
                          'Explore',
                        ),
                        const SizedBox(height: 16),
                        _buildServices(),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'Our Doctors',
                          'View all',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const _AllDoctorsPlaceholder(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Find the right specialist for you',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (filteredDoctors.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                'No doctors found.',
                                style: TextStyle(color: _muted),
                              ),
                            ),
                          )
                        else
                          _buildDoctors(filteredDoctors),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavigation(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(PatientProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _openRoute('/profile-settings'),
            child: _avatar(profile, 48),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _openRoute('/profile-settings'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Your health, our priority',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _roundIcon(
            Icons.notifications_none_rounded,
            onTap: () => _openRoute('/messages'),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(PatientProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF624747), Color(0xFF342828)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFFFB5B5),
                  size: 17,
                ),
                SizedBox(width: 7),
                Text(
                  'HEALTHLINE PH',
                  style: TextStyle(
                    color: Color(0xFFE8D4D4),
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Hello, ${profile.name.split(' ').first}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take care of yourself today.\nYour next step to better health starts here.',
              style: TextStyle(
                color: Color(0xFFE3D7D7),
                height: 1.5,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () => _openRoute('/appointments'),
              icon: const Icon(Icons.calendar_month_rounded, size: 16),
              label: const Text('My appointments'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFBCA6A6)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() => _searchQuery = value.trim());
        },
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search doctors or specialties...',
          hintStyle: const TextStyle(color: _muted, fontSize: 12),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _muted,
          ),
          filled: true,
          fillColor: _surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: _mauve),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String action, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              action,
              style: const TextStyle(
                color: Color(0xFFD7AAAA),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServices() {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _services.length,
        separatorBuilder: (_, _) => const SizedBox(width: 13),
        itemBuilder: (context, index) {
          final service = _services[index];

          return GestureDetector(
            onTap: () => _showService(service['name']!),
            child: Container(
              width: 112,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withAlpha(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _mauve.withAlpha(65),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _serviceIcon(service['icon']!),
                      color: const Color(0xFFE6CACA),
                      size: 23,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    service['name']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _serviceIcon(String service) {
    switch (service) {
      case 'medical':
        return Icons.medical_services_outlined;
      case 'vaccination':
        return Icons.vaccines_outlined;
      case 'laboratory':
        return Icons.science_outlined;
      case 'dental':
        return Icons.health_and_safety_outlined;
      default:
        return Icons.local_hospital_outlined;
    }
  }

  Widget _buildDoctors(List<Map<String, String>> doctors) {
    return SizedBox(
      height: 174,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final doctor = doctors[index];

          return GestureDetector(
            onTap: () => _openRoute('/messages'),
            child: Container(
              width: 245,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: Colors.white.withAlpha(18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 66,
                    height: 86,
                    decoration: BoxDecoration(
                      color: const Color(0xFF423636),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFFE0CACA),
                      size: 35,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doctor['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          doctor['specialty']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFCA67),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${doctor['rating']} · ${doctor['reviews']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'VIDEO  ·  AUDIO  ·  CHAT',
                          style: TextStyle(
                            color: Color(0xFFE6BDBD),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _avatar(PatientProfile profile, double size) {
    final Uint8List? bytes = profile.photoBytes;

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF423636),
      ),
      child: bytes != null
          ? Image.memory(bytes, fit: BoxFit.cover)
          : profile.photoUrl != null && profile.photoUrl!.isNotEmpty
              ? Image.network(
                  profile.photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.person_rounded,
                  color: Color(0xFFE6CACA),
                  size: 26,
                ),
    );
  }

  Widget _roundIcon(
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: _surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: const Color(0xFF211D1D),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(18)),
          ),
          child: Row(
            children: [
              _navItem(Icons.home_rounded, 'Home', true, () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  (route) => false,
                );
              }),
              _navItem(
                Icons.calendar_month_rounded,
                'Schedule',
                false,
                () => _openRoute('/appointments'),
              ),
              _navItem(
                Icons.chat_bubble_outline_rounded,
                'Messages',
                false,
                () => _openRoute('/messages'),
              ),
              _navItem(
                Icons.settings_outlined,
                'Settings',
                false,
                () => _openRoute('/profile-settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 62,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? _accent : _muted,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : _muted,
                  fontSize: 9,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllDoctorsPlaceholder extends StatelessWidget {
  const _AllDoctorsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.white,
        title: const Text('Our Doctors'),
      ),
      body: const Center(
        child: Text(
          'All doctors will appear here.',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  static const Color _backgroundColor = Color(0xFF101010);
}
