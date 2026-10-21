import 'package:flutter/material.dart';

class HealthLineBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const HealthLineBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  static const Color _surface = Color(0xFF211D1D);
  static const Color _accent = Color(0xFFFF454D);
  static const Color _muted = Color(0xFFAAAAAA);

  static const List<String> _routes = [
    '/dashboard',
    '/appointments',
    '/messages',
    '/profile-settings',
  ];

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.chat_bubble_outline_rounded,
    Icons.settings_outlined,
  ];

  static const List<String> _labels = [
    'Home',
    'Schedule',
    'Messages',
    'Settings',
  ];

  void _selectTab(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      _routes[index],
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withAlpha(18)),
          ),
          child: Row(
            children: List.generate(_labels.length, (index) {
              final selected = index == selectedIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => _selectTab(context, index),
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 62,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _icons[index],
                          color: selected ? _accent : _muted,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _labels[index],
                          style: TextStyle(
                            color: selected ? Colors.white : _muted,
                            fontSize: 9,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
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