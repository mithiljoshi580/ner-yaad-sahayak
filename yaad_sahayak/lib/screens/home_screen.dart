import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> games = const [
    {
      'name': 'Thang Ta',
      'subtitle': 'The Art of War & Peace',
      'icon': Icons.sports_martial_arts,
      'color': Color(0xFF6C3FC5),
    },
    {
      'name': 'Mukna',
      'subtitle': 'The Game of Strategy',
      'icon': Icons.sports_kabaddi,
      'color': Color(0xFF2E8B57),
    },
    {
      'name': 'Insuknawr',
      'subtitle': 'The Game of Courage',
      'icon': Icons.groups,
      'color': Color(0xFF2979C9),
    },
    {
      'name': 'Coming Soon',
      'subtitle': 'More exciting games!',
      'icon': Icons.hourglass_top,
      'color': Color(0xFFE67E22),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10152F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF10152F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'NE Games',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let's Play & Explore 🎮",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Discover the pride of North-East India ✨',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.builder(
                itemCount: games.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final game = games[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: game['color'],
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            game['icon'],
                            color: Colors.white,
                            size: 55,
                          ),

                          const SizedBox(height: 18),

                          Text(
                            game['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            game['subtitle'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}