import 'package:flutter/material.dart';
import 'game_detail_screen.dart';
import 'family_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {
      'name': 'Thang Ta',
      'subtitle': 'The Art of War & Peace',
      'icon': Icons.sports_martial_arts,
      'color': Color(0xFF3B82F6),
    },
    {
      'name': 'Mukna',
      'subtitle': 'The Game of Strategy',
      'icon': Icons.sports_kabaddi,
      'color': Color(0xFF2563EB),
    },
    {
      'name': 'Insuknawr',
      'subtitle': 'The Game of Courage',
      'icon': Icons.groups_rounded,
      'color': Color(0xFF1D4ED8),
    },
    {
      'name': 'Coming Soon',
      'subtitle': 'More exciting games!',
      'icon': Icons.hourglass_top_rounded,
      'color': Color(0xFF334155),
    },
  ];

  final List<Map<String, String>> recentMemories = const [
    {
      'title': 'Family Together',
      'subtitle': 'A beautiful family moment',
      'image':
          'https://images.unsplash.com/photo-1511895426328-dc8714191300',
    },
    {
      'title': 'Happy Memories',
      'subtitle': 'Moments to remember',
      'image':
          'https://images.unsplash.com/photo-1504159506876-f8338247a14a',
    },
    {
      'title': 'Special Day',
      'subtitle': 'A day full of happiness',
      'image':
          'https://images.unsplash.com/photo-1511988617509-a57c8a288659',
    },
  ];

  static const Color backgroundColor = Color(0xFF080B14);
  static const Color cardColor = Color(0xFF111827);
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color borderColor = Color(0xFF263548);
  static const Color secondaryTextColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,

        title: const Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: accentColor,
              size: 25,
            ),
            SizedBox(width: 10),
            Text(
              'Yaad Sahayak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: 'My Family',

              icon: Container(
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),

                child: const Icon(
                  Icons.family_restroom_rounded,
                  color: accentColor,
                  size: 22,
                ),
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyListScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),

                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E3A5F),
                      Color(0xFF111827),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  border: Border.all(
                    color: const Color(0xFF345A85),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,

                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: Color(0xFFFFC857),
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning! 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            'Remember your loved ones and cherish every memory.',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Your Memories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.people_alt_rounded,
                      number: '3',
                      label: 'Family Members',
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.favorite_rounded,
                      number: '6',
                      label: 'Total Memories',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Memories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FamilyListScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 190,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentMemories.length,

                  itemBuilder: (context, index) {
                    final memory = recentMemories[index];

                    return Container(
                      width: 155,

                      margin: EdgeInsets.only(
                        right: index == recentMemories.length - 1
                            ? 0
                            : 15,
                      ),

                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),

                      clipBehavior: Clip.antiAlias,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    memory['image']!,
                                    fit: BoxFit.cover,

                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Container(
                                        color: primaryColor,
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: secondaryTextColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                Positioned(
                                  top: 10,
                                  right: 10,

                                  child: Container(
                                    padding: const EdgeInsets.all(6),

                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.45,
                                      ),
                                      shape: BoxShape.circle,
                                    ),

                                    child: const Icon(
                                      Icons.favorite_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(12),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [
                                Text(
                                  memory['title']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  memory['subtitle']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Explore Traditional Games',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Discover and learn about the traditional games of North-East India.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: games.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.82,
                ),

                itemBuilder: (context, index) {
                  final game = games[index];

                  return GestureDetector(
                    onTap: () {
                      if (game['name'] == 'Coming Soon') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'More games coming soon!',
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDetailScreen(
                              gameName: game['name'],
                            ),
                          ),
                        );
                      }
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: borderColor),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 62,
                              height: 62,

                              decoration: BoxDecoration(
                                color: (game['color'] as Color)
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                game['icon'] as IconData,
                                color: game['color'] as Color,
                                size: 32,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              game['name'] as String,
                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              game['subtitle'] as String,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}