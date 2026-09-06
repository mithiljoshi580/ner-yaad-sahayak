import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class GameDetailScreen extends StatelessWidget {
  final String gameName;

  const GameDetailScreen({
    super.key,
    required this.gameName,
  });

  Map<String, dynamic> getGameDetails() {
    switch (gameName) {
      case 'Thang Ta':
        return {
          'icon': Icons.sports_martial_arts,
          'color': const Color(0xFF6C3FC5),
          'about':
              'Thang Ta is a traditional martial art from Manipur that combines physical skill, discipline and cultural heritage.',
          'howToPlay':
              'Players learn traditional movements, techniques and combat skills using swords and spears.',
        };

      case 'Mukna':
        return {
          'icon': Icons.sports_kabaddi,
          'color': const Color(0xFF2E8B57),
          'about':
              'Mukna is a traditional form of wrestling from Manipur and is known for its strength, strategy and competitive spirit.',
          'howToPlay':
              'Players compete using traditional wrestling techniques while following the rules of the game.',
        };

      case 'Insuknawr':
        return {
          'icon': Icons.groups,
          'color': const Color(0xFF2979C9),
          'about':
              'Insuknawr is a traditional game that represents teamwork, courage and the cultural heritage of North-East India.',
          'howToPlay':
              'Players participate using teamwork, skill and strategy according to the traditional rules of the game.',
        };

      default:
        return {
          'icon': Icons.sports_esports,
          'color': const Color(0xFFFF7A00),
          'about':
              'Discover an exciting traditional game and explore its cultural heritage.',
          'howToPlay':
              'Learn the rules and enjoy the traditional gameplay experience.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = getGameDetails();
    final Color gameColor = game['color'];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Text(
          gameName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GAME HERO SECTION
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      gameColor,
                      const Color(0xFF121212),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gameColor.withOpacity(0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    game['icon'],
                    size: 110,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // GAME TITLE
              Text(
                gameName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Explore the culture, history and excitement behind this traditional game.',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // ABOUT THE GAME
              _buildInfoCard(
                icon: Icons.auto_stories,
                title: 'About the Game',
                description: game['about'],
                gameColor: gameColor,
              ),

              const SizedBox(height: 16),

              // HOW TO PLAY
              _buildInfoCard(
                icon: Icons.sports_esports,
                title: 'How to Play',
                description: game['howToPlay'],
                gameColor: gameColor,
              ),

              const SizedBox(height: 30),

              // PLAY QUIZ BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          gameName: gameName,
                        ), 
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text(
                    'PLAY QUIZ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gameColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
    required Color gameColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gameColor.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: gameColor,
            size: 28,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}