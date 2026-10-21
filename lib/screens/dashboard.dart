import 'package:flutter/material.dart';
import '../models/patient_profile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';

  static const Color _background = Colors.black;
  static const Color _mutedMauve = Color(0xFF806666);
  static const Color _cardGrey = Color(0xFFD9D9D9);
  static const Color _activeRed = Color(0xFFFF3038);
  static const Color _mutedText = Color(0xFFBDBDBD);

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
        duration: const Duration(seconds: 2),
        backgroundColor: _mutedMauve,
      ),
    );
  }

  void _showAllDoctors() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const _AllDoctorsPlaceholder(),
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
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPatientHeader(profile),

                        const SizedBox(height: 15),

                        _buildSearchField(),

                        const SizedBox(height: 22),

                        _buildSectionTitle('Popular Services'),

                        const SizedBox(height: 14),

                        _buildServicesCarousel(),

                        const SizedBox(height: 28),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Doctors',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              GestureDetector(
                                onTap: _showAllDoctors,
                                child: const Text(
                                  'View all',
                                  style: TextStyle(
                                    color: _mutedText,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        if (filteredDoctors.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                'No doctors found.',
                                style: TextStyle(
                                  color: _mutedText,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        else
                          _buildDoctorsCarousel(filteredDoctors),
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

  Widget _buildPatientHeader(PatientProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _openRoute('/profile-settings'),
            child: _buildAvatar(
              photoUrl: profile.photoUrl,
              size: 39,
            ),
          ),

          const SizedBox(width: 9),

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
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${profile.age} years old',
                    style: const TextStyle(
                      color: _mutedText,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            onPressed: () => _openRoute('/messages'),
            tooltip: 'Notifications and messages',
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar({
    required String? photoUrl,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: _cardGrey,
      ),
      clipBehavior: Clip.antiAlias,
      child: photoUrl != null && photoUrl.isNotEmpty
          ? Image.network(
        photoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return const Icon(
            Icons.person,
            color: Colors.white,
          );
        },
      )
          : const Icon(
        Icons.person,
        color: _cardGrey,
        size: 1,
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 44,
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
          },
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'Search a doctor',
            hintStyle: const TextStyle(
              color: _mutedText,
              fontSize: 8,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: _mutedText,
              size: 15,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 27,
              minHeight: 22,
            ),
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: const Color(0xFF4B3A3A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: _mutedMauve,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildServicesCarousel() {
    return SizedBox(
      height: 125,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _services.length,
        separatorBuilder: (_, _) => const SizedBox(width: 11),
        itemBuilder: (context, index) {
          final service = _services[index];

          return GestureDetector(
            onTap: () => _showService(service['name']!),
            child: SizedBox(
              width: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 97,
                    width: 96,
                    decoration: BoxDecoration(
                      color: _cardGrey,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      _serviceIcon(service['icon']!),
                      size: 27,
                      color: const Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    service['name']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
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

  Widget _buildDoctorsCarousel(
      List<Map<String, String>> doctors,
      ) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: doctors.length,
        separatorBuilder: (_, _) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final doctor = doctors[index];

          return GestureDetector(
            onTap: () => _openRoute('/messages'),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _mutedMauve,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: _cardGrey,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: _cardGrey,
                      size: 1,
                    ),
                  ),

                  const SizedBox(width: 8),

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
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          doctor['specialty']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFE1D1D1),
                            fontSize: 6,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFD54F),
                              size: 9,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${doctor['rating']} (${doctor['reviews']})',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 5,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        const Wrap(
                          spacing: 3,
                          children: [
                            _DoctorTag('VIDEO'),
                            _DoctorTag('AUDIO'),
                            _DoctorTag('CHAT'),
                          ],
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

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF4B3A3A),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              selected: true,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/dashboard',
                (route) => false,
                ),
            ),
            _buildNavItem(
              icon: Icons.calendar_month_outlined,
              label: 'Schedule',
              selected: false,
              onTap: () => _openRoute('/appointments'),
            ),
            _buildNavItem(
              icon: Icons.chat_bubble_outline,
              label: 'Messages',
              selected: false,
              onTap: () => _openRoute('/messages'),
            ),
            _buildNavItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              selected: false,
              onTap: () => _openRoute('/profile-settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: SizedBox(
          height: 56,
          child: Center(
            child: Icon(
              icon,
              color: selected ? _activeRed : Colors.white,
              size: 23,
            ),
          ),
        ),
      ),
    );
  }
}

class _DoctorTag extends StatelessWidget {
  final String label;

  const _DoctorTag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF555555),
          fontSize: 4,
          fontWeight: FontWeight.w600,
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('All Doctors'),
      ),
      body: const Center(
        child: Text(
          'All doctors will appear here.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}