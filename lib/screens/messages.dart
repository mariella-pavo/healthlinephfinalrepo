import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import 'chat_detail.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  static const Color background = Colors.black;
  static const Color panelGrey = Color(0xFF707070);
  static const Color mutedText = Color(0xFFE0E0E0);

  final List<Map<String, String>> alerts = const [
    {
      'title': 'Dr. Zana would like your rating!',
      'message':
          'Share your experience with Dr. Zana and help other patients.'
    },
    {
      'title': 'Dr. Ken is now available. Would you like to book a consult?',
      'message':
          'Dr. Ken is available for consultation. You can explore booking options.'
    },
    {
      'title': 'Rate United Health clinic and earn 5 points.',
      'message':
          'Leave a rating for United Health clinic to earn 5 points.'
    },
  ];

  final List<String> hospitals = const [
    'United Health Clinic - Cancer Society',
    'Davao International Hospital - Dermatology',
    'Davao United Doctors - Internal Medicine',
    'Davao United Doctors - General Health',
    'Dr. Ken Lee and Doctors Clinic',
    'International Chinese Hospital',
    'Metro Clinic - Davao Region',
    'Philippine Internal Hospital - Southern Mindanao',
  ];

  void _openDetails(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageDetailScreen(
          title: title,
          message: message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(19, 12, 19, 20),
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/dashboard',
                            (route) => false,
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 22,
                          minHeight: 28,
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        'Messages',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 17),

                  // Alerts section
                  const Text(
                    'Alerts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: panelGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: List.generate(alerts.length, (index) {
                        final alert = alerts[index];

                        return InkWell(
                          onTap: () => _openDetails(
                            context,
                            title: alert['title']!,
                            message: alert['message']!,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Color(0xFFD9D9D9),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    alert['title']!,
                                    style: const TextStyle(
                                      color: mutedText,
                                      fontSize: 7,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white54,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Chats section
                  const Text(
                    'Chats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 21),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: panelGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: List.generate(hospitals.length, (index) {
                        final hospital = hospitals[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatDetailScreen(
                                  hospital: hospital,
                                  ),
                                  ),
                                  );
                                  },
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 28,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Color(0xFFD9D9D9),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    hospital,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: mutedText,
                                      fontSize: 7,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white54,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Shared bottom navigation; Messages is active.
            const HealthLineBottomNavigation(
              selectedIndex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// Temporary destination for a selected alert or conversation.
// Replace this with the real chat screen when messaging is implemented.

class MessageDetailScreen extends StatelessWidget {
  final String title;
  final String message;

  const MessageDetailScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
