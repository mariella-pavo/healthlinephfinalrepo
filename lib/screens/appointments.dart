
import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../widgets/bottom_navigation.dart';

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

  static const Color _background = Color(0xFF101010);
  static const Color _surface = Color(0xFF1C1A1A);
  static const Color _mauve = Color(0xFF806666);
  static const Color _accent = Color(0xFFFF454D);
  static const Color _muted = Color(0xFFAAAAAA);
  static const Color _lightMauve = Color(0xFFE6CACA);

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
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
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: AppointmentStore.instance,
                builder: (context, _) {
                  final upcoming = AppointmentStore.instance.upcoming;
                  final history = AppointmentStore.instance.history;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                    children: [
                      // Header
                      Row(
                        children: [
                          _iconButton(
                            Icons.arrow_back_rounded,
                            onTap: () {
                              Navigator.maybePop(context);
                            },
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Appointments',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Manage your healthcare visits',
                                  style: TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _mauve.withAlpha(40),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: _lightMauve,
                              size: 23,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Upcoming section
                      _sectionHeader(
                        'Upcoming',
                        '${upcoming.length} appointments',
                      ),

                      const SizedBox(height: 15),

                      if (upcoming.isEmpty)
                        _emptyState(
                          icon: Icons.calendar_today_outlined,
                          title: 'No upcoming appointments',
                          subtitle:
                              'Appointments you book will appear here.',
                        )
                      else
                        ...upcoming.map(
                          (appointment) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _upcomingCard(context, appointment),
                          ),
                        ),

                      const SizedBox(height: 22),

                      // History section
                      _sectionHeader('History', '${history.length} records'),

                      const SizedBox(height: 15),

                      if (history.isEmpty)
                        _emptyState(
                          icon: Icons.history_rounded,
                          title: 'No appointment history',
                          subtitle:
                              'Completed and cancelled appointments will appear here.',
                        )
                      else
                        _historyCard(history),
                    ],
                  );
                },
              ),
            ),

            // Shared navigation: Schedule is selected.
            const HealthLineBottomNavigation(selectedIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 21),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          count,
          style: const TextStyle(
            color: _muted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _mauve.withAlpha(45),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              icon,
              color: _lightMauve,
              size: 27,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _upcomingCard(
    BuildContext context,
    Appointment appointment,
  ) {
    final weekday = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][appointment.dateTime.weekday - 1];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clinic information
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: _mauve.withAlpha(45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.local_hospital_outlined,
                  color: _lightMauve,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  appointment.clinicName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),
          Divider(color: Colors.white.withAlpha(18), height: 1),
          const SizedBox(height: 16),

          // Doctor information
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF423636),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: _lightMauve,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      appointment.specialty,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          // Appointment date and time
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFF282222),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: _lightMauve,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(appointment.dateTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$weekday · ${_formatTime(appointment.dateTime)}',
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _mauve.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Upcoming',
                    style: TextStyle(
                      color: _lightMauve,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 17),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Contact integration is not configured yet.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_outlined, size: 16),
                  label: const Text('Contact'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _lightMauve,
                    side: const BorderSide(color: _mauve),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _confirmCancel(context, appointment),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF8D93),
                    side: BorderSide(
                      color: _accent.withAlpha(130),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyCard(List<Appointment> appointments) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(18)),
      ),
      child: Column(
        children: List.generate(appointments.length, (index) {
          final appointment = appointments[index];
          final isCancelled = appointment.status == 'cancelled';
          final isCompleted = appointment.status == 'completed';

          final status = isCancelled
              ? 'Cancelled'
              : isCompleted
                  ? 'Completed'
                  : 'Past appointment';

          final statusColor = isCancelled
              ? const Color(0xFFFF8D93)
              : isCompleted
                  ? const Color(0xFF9BC9A4)
                  : _muted;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: _mauve.withAlpha(40),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: _lightMauve,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            appointment.specialty,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatDate(appointment.dateTime),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _formatTime(appointment.dateTime),
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (index != appointments.length - 1)
                Divider(
                  height: 1,
                  color: Colors.white.withAlpha(18),
                ),
            ],
          );
        }),
      ),
    );
  }

  void _confirmCancel(
    BuildContext context,
    Appointment appointment,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF242020),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Cancel appointment?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'This appointment will be moved to your history.',
          style: TextStyle(
            color: _muted,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Keep appointment',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              AppointmentStore.instance.cancel(appointment.id);
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Cancel appointment',
              style: TextStyle(
                color: Color(0xFFFF8D93),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
