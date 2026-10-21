import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentStore extends ChangeNotifier {
  AppointmentStore._();

  static final AppointmentStore instance = AppointmentStore._();

  final List<Appointment> _appointments = [];

  List<Appointment> get upcoming => _appointments
      .where((appointment) => appointment.isUpcoming)
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  List<Appointment> get history =>
      _appointments.where((appointment) => appointment.isHistory).toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

  void add(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void cancel(String id) {
    final index = _appointments.indexWhere((item) => item.id == id);
    if (index == -1) return;

    _appointments[index] =
        _appointments[index].copyWith(status: 'cancelled');
    notifyListeners();
  }

  void complete(String id) {
    final index = _appointments.indexWhere((item) => item.id == id);
    if (index == -1) return;

    _appointments[index] =
        _appointments[index].copyWith(status: 'completed');
    notifyListeners();
  }
}

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  static const Color background = Colors.black;
  static const Color mauve = Color(0xFF806666);
  static const Color historyGrey = Color(0xFF707070);
  static const Color activeRed = Color(0xFFFF3038);

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${date.hour >= 12 ? 'PM' : 'AM'}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: AppointmentStore.instance,
                builder: (context, _) {
                  final upcoming = AppointmentStore.instance.upcoming;
                  final history = AppointmentStore.instance.history;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.maybePop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                            ),
                            const Text(
                              'Appointments',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _sectionTitle('Upcoming'),
                        const SizedBox(height: 20),
                        if (upcoming.isEmpty)
                          _emptyState(
                            'No upcoming appointments',
                            'Appointments you book will appear here.',
                          )
                        else
                          ...upcoming.map(
                            (appointment) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _upcomingCard(context, appointment),
                            ),
                          ),
                        const SizedBox(height: 24),
                        _sectionTitle('History'),
                        const SizedBox(height: 20),
                        if (history.isEmpty)
                          _emptyState(
                            'No appointment history',
                            'Completed and cancelled appointments will appear here.',
                            historyStyle: true,
                          )
                        else
                          _historyCard(history),
                      ],
                    ),
                  );
                },
              ),
            ),
            _bottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _emptyState(
    String title,
    String subtitle, {
    bool historyStyle = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: historyStyle ? historyGrey : const Color(0xFF171717),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFFCCCCCC),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _upcomingCard(BuildContext context, Appointment appointment) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.clinicName,
            style: const TextStyle(
              color: Color(0xFF292929),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              _avatar(circle: false),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        color: Color(0xFF424242),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      appointment.specialty,
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(appointment.dateTime),
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${_formatTime(appointment.dateTime)} · ${[
                      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
                      'Friday', 'Saturday', 'Sunday'
                    ][appointment.dateTime.weekday - 1]}',
                    style: const TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 7,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _actionButton(
                'Contact',
                const Color(0xFF684747),
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact integration is not configured yet.'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _actionButton(
                'Cancel',
                const Color(0xFFD0A0A0),
                () => _confirmCancel(context, appointment),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyCard(List<Appointment> appointments) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: historyGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: appointments.map((appointment) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                _avatar(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        appointment.specialty,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 8,
                        ),
                      ),
                      Text(
                        appointment.status == 'cancelled'
                            ? 'Cancelled'
                            : appointment.status == 'completed'
                                ? 'Completed'
                                : 'Past appointment',
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatDate(appointment.dateTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                      ),
                    ),
                    Text(
                      _formatTime(appointment.dateTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _avatar({bool circle = true}) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(11),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 25),
    );
  }

  Widget _actionButton(String label, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 82,
      height: 29,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: const StadiumBorder(),
        ),
        child: Text(label, style: const TextStyle(fontSize: 10)),
      ),
    );
  }

  void _confirmCancel(BuildContext context, Appointment appointment) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF292323),
        title: const Text(
          'Cancel appointment?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This appointment will be moved to your history.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Keep appointment',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              AppointmentStore.instance.cancel(appointment.id);
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Cancel appointment',
              style: TextStyle(color: Color(0xFFE6A5A5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigation(BuildContext context) {
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
          _navItem(
            context,
            Icons.home_outlined,
            'Home',
            false,
            () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
              (route) => false,
            ),
          ),
          _navItem(
            context,
            Icons.calendar_month_outlined,
            'Schedule',
            true,
            () => Navigator.pushNamed(context, '/appointments'),
          ),
          _navItem(
            context,
            Icons.chat_bubble_outline,
            'Messages',
            false,
            () => Navigator.pushNamed(context, '/messages'),
          ),
          _navItem(
            context,
            Icons.settings_outlined,
            'Settings',
            false,
            () => Navigator.pushNamed(context, '/profile-settings'),
          ),
        ],
      ),
    ),
  );
  }

  Widget _navItem(
    BuildContext context,
  IconData icon,
  String label,
  bool selected,
  VoidCallback onTap,
  ) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 56,
        child: Center(
          child: Icon(
            icon,
            color: selected ? activeRed : Colors.white,
            size: 23,
          ),
        ),
      ),
    ),
  );
} }