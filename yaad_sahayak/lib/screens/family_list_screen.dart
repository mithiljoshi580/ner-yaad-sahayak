import 'package:flutter/material.dart';
import 'family_detail_screen.dart';

class FamilyListScreen extends StatelessWidget {
  const FamilyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> familyMembers = [
      {
        'name': 'Ramesh Kumar',
        'relation': 'Father',
        'image':
            'https://randomuser.me/api/portraits/men/32.jpg',
        'about':
            'A loving father who enjoys sharing stories and preserving family memories.',
      },
      {
        'name': 'Lakshmi Devi',
        'relation': 'Mother',
        'image':
            'https://randomuser.me/api/portraits/women/44.jpg',
        'about':
            'The heart of the family who keeps everyone connected through love and memories.',
      },
      {
        'name': 'Arjun Kumar',
        'relation': 'Son',
        'image':
            'https://randomuser.me/api/portraits/men/12.jpg',
        'about':
            'A cheerful and curious member of the family who loves learning new things.',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF181A2E),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2238),
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'My Family',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // HEADER SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
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
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF526FA6),
                    blurRadius: 25,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.family_restroom_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Your Family, Your Memories',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Keep your loved ones connected through stories, memories and shared moments.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SECTION TITLE
            const Row(
              children: [
                Icon(
                  Icons.people_alt_rounded,
                  color: Color(0xFF7FA6E8),
                  size: 24,
                ),

                SizedBox(width: 10),

                Text(
                  'Family Members',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // FAMILY MEMBER LIST
            ...familyMembers.map(
              (member) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _FamilyMemberCard(
                  name: member['name']!,
                  relation: member['relation']!,
                  image: member['image']!,
                  about: member['about']!,
                ),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF5C7FC2),
        elevation: 8,

        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFF2A2E45),
              content: Text(
                'Add Member feature coming soon!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },

        icon: const Icon(
          Icons.person_add_alt_1_rounded,
          color: Colors.white,
        ),

        label: const Text(
          'Add Member',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


class _FamilyMemberCard extends StatelessWidget {
  final String name;
  final String relation;
  final String image;
  final String about;

  const _FamilyMemberCard({
    required this.name,
    required this.relation,
    required this.image,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FamilyDetailScreen(
              name: name,
              relation: relation,
              image: image,
              about: about,
            ),
          ),
        );
      },

      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF25283A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFF40506F),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              // PROFILE IMAGE
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF7FA6E8),
                      Color(0xFF7356B5),
                    ],
                  ),
                ),

                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFF1B1D2C),
                  backgroundImage: NetworkImage(image),
                ),
              ),

              const SizedBox(width: 18),

              // NAME AND RELATION
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFF526FA6).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        relation,
                        style: const TextStyle(
                          color: Color(0xFF9DBBEF),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF9AA4B7),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}