import 'package:flutter/material.dart';
import 'add_family_member_screen.dart';

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

  static const Color backgroundColor = Color(0xFF080B14);
  static const Color cardColor = Color(0xFF111827);
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color borderColor = Color(0xFF263548);
  static const Color secondaryTextColor = Color(0xFF9CA3AF);

  // EDIT MEMBER
  Future<void> _editMember(BuildContext context) async {
    final updatedMember = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddFamilyMemberScreen(
          existingMember: {
            'name': name,
            'relation': relation,
            'image': image,
            'about': about,
          },
        ),
      ),
    );

    if (updatedMember != null && context.mounted) {
      Navigator.pop(
        context,
        {
          'action': 'edit',
          'member': updatedMember,
        },
      );
    }
  }

  // DELETE MEMBER
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Family Member?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'This action cannot be undone. Are you sure you want to delete this family member?',
            style: TextStyle(
              color: secondaryTextColor,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: secondaryTextColor,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pop(
                  context,
                  {
                    'action': 'delete',
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> memories = [
      'https://images.unsplash.com/photo-1511895426328-dc8714191300',
      'https://images.unsplash.com/photo-1504159506876-f8338247a14a',
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
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

        actions: [
          IconButton(
            tooltip: 'Edit Member',
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
            onPressed: () => _editMember(context),
          ),

          IconButton(
            tooltip: 'Delete Member',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFFF6B6B),
            ),
            onPressed: () => _showDeleteDialog(context),
          ),

          const SizedBox(width: 5),
        ],
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
                    primaryColor,
                    cardColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: accentColor,
                  width: 1,
                ),
              ),

              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accentColor,
                          primaryColor,
                        ],
                      ),
                    ),

                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: backgroundColor,
                      child: image.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                image,
                                width: 116,
                                height: 116,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 55,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 55,
                            ),
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
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Text(
                      relation,
                      style: const TextStyle(
                        color: Color(0xFF93C5FD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ABOUT
            _buildSectionCard(
              icon: Icons.person_outline_rounded,
              title: 'About',
              child: Text(
                about,
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // MEMORIES
            _buildSectionCard(
              icon: Icons.photo_library_outlined,
              title: 'Memories',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Precious moments shared with family.',
                    style: TextStyle(
                      color: secondaryTextColor,
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
                        child: Image.network(
                          memories[index],
                          fit: BoxFit.cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              color: primaryColor,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: secondaryTextColor,
                                size: 35,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // VOICE NOTE
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Voice note feature coming soon!',
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
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
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
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: accentColor,
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