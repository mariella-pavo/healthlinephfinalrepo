
import 'package:flutter/material.dart';

class HealthLineBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const HealthLineBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  static const Color _barColor = Color(0xFF4B3A3A);
  static const Color _activeRed = Color(0xFFFF3038);

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.chat_bubble_outline,
    Icons.settings_outlined,
  ];

  static const List<String> _labels = [
    'Home',
    'Appointments',
    'Messages',
    'Settings',
  ];

  static const List<String> _routes = [
    '/dashboard',
    '/appointments',
    '/messages',
    '/profile-settings',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: _barColor,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (index == selectedIndex) return;

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      _routes[index],
                      (route) => false,
                    );
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: SizedBox(
                    height: 56,
                    child: Center(
                      child: Icon(
                        _icons[index],
                        size: 23,
                        color: selectedIndex == index
                            ? _activeRed
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
