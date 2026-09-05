import 'package:flutter/material.dart';

class FamilyDetailScreen extends StatelessWidget {
  final String name;
  final String relation;
  final String image;
  final String about;

  const FamilyDetailScreen({
    super.key,
    required this.name,
    required this.relation,
    required this.image,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy memory images
    final List<String> memories = [
      'https://images.unsplash.com/photo-1511895426328-dc8714191300',
      'https://images.unsplash.com/photo-1504159506876-f8338247a14a',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF181A2E),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2238),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Family Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF526FA6),
                    Color(0xFF242A3A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // LARGE PROFILE IMAGE
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF9DBBEF),
                          Color(0xFF7356B5),
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 58,
                      backgroundImage: NetworkImage(image),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Text(
                      relation,
                      style: const TextStyle(
                        color: Color(0xFFD7E3FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ABOUT SECTION
            _buildSectionCard(
              icon: Icons.person_outline_rounded,
              title: 'About',
              child: Text(
                about,
                style: const TextStyle(
                  color: Color(0xFFB8BECA),
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // MEMORIES SECTION
            _buildSectionCard(
              icon: Icons.photo_library_outlined,
              title: 'Memories',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Precious moments shared with family.',
                    style: TextStyle(
                      color: Color(0xFFB8BECA),
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 18),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: memories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              memories[index],
                              fit: BoxFit.cover,
                            ),

                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0x66000000),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                            const Positioned(
                              bottom: 10,
                              left: 10,
                              child: Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // VOICE NOTE BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF2A2E45),
                      content: Text(
                        'Voice note feature coming soon!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.play_circle_fill_rounded,
                  size: 25,
                ),
                label: const Text(
                  'Play Voice Note',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C7FC2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF25283A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF40506F),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF7FA6E8),
                size: 25,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}