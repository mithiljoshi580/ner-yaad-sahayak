import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'add_family_member_screen.dart';

class FamilyDetailScreen extends StatelessWidget {
  final String name;
  final String relation;
  final Uint8List? image;
  final String about;
  final String heroTag;

  const FamilyDetailScreen({
    super.key,
    required this.name,
    required this.relation,
    required this.image,
    required this.about,
    required this.heroTag,
  });

  static const Color backgroundColor = Color(0xFF080B14);
  static const Color cardColor = Color(0xFF111827);
  static const Color primaryColor = Color(0xFF1E3A5F);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color borderColor = Color(0xFF263548);
  static const Color secondaryTextColor = Color(0xFF9CA3AF);

  Future<void> _editMember(BuildContext context) async {
    final updatedMember =
        await Navigator.push<Map<String, dynamic>>(
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
    final List<Uint8List> memories = [];

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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              // ================= PROFILE =================

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
                  ),
                ),

                child: Column(
                  children: [
                    // ================= HERO PROFILE PHOTO =================

                    Hero(
                      tag: heroTag,

                      child: Container(
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

                          child: ClipOval(
                            child: image != null
                                ? Image.memory(
                                    image!,
                                    width: 116,
                                    height: 116,
                                    fit: BoxFit.cover,
                                  )
                                : _buildDefaultAvatar(),
                          ),
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
                        color: Colors.white.withValues(alpha: 0.08),

                        borderRadius: BorderRadius.circular(25),

                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
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

              // ================= ABOUT =================

              _buildSectionCard(
                icon: Icons.person_outline_rounded,
                title: 'About',

                child: Text(
                  about.isEmpty
                      ? 'No information added yet.'
                      : about,

                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= MEMORIES =================

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

                    if (memories.isEmpty)
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 20,
                        ),

                        decoration: BoxDecoration(
                          color: backgroundColor,

                          borderRadius: BorderRadius.circular(18),

                          border: Border.all(
                            color: borderColor,
                          ),
                        ),

                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons.photo_library_outlined,
                                color: accentColor,
                                size: 40,
                              ),
                            ),

                            const SizedBox(height: 16),

                            const Text(
                              'No Memories Yet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Create and save precious family moments here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

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

                            child: Image.memory(
                              memories[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ================= VOICE NOTE =================

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
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: primaryColor,

      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 55,
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