import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'family_detail_screen.dart';
import 'add_family_member_screen.dart';
import '../widgets/shimmer_loading.dart';

class FamilyListScreen extends StatefulWidget {
  const FamilyListScreen({super.key});

  @override
  State<FamilyListScreen> createState() => _FamilyListScreenState();
}

class _FamilyListScreenState extends State<FamilyListScreen> {
  final List<Map<String, dynamic>> familyMembers = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFamilyMembers();
  }

  Future<void> _loadFamilyMembers() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  // ================= ADD FAMILY MEMBER =================

  Future<void> _addFamilyMember() async {
    final newMember = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFamilyMemberScreen(),
      ),
    );

    if (newMember != null) {
      setState(() {
        familyMembers.add(newMember);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF2A2E45),
            content: Text(
              '${newMember['name']} added successfully!',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  // ================= OPEN FAMILY MEMBER =================

  Future<void> _openFamilyMember(int index) async {
    final member = familyMembers[index];

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => FamilyDetailScreen(
          name: member['name'] ?? '',
          relation: member['relation'] ?? '',
          image: member['image'],
          about: member['about'] ?? '',
          heroTag: 'member_photo_$index',
        ),
      ),
    );

    if (result == null || !mounted) return;

    final action = result['action'];

    if (action == 'edit') {
      final updatedMember =
          Map<String, dynamic>.from(result['member']);

      setState(() {
        familyMembers[index] = updatedMember;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2A2E45),
          content: Text(
            '${updatedMember['name']} updated successfully!',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (action == 'delete') {
      setState(() {
        familyMembers.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFFB91C1C),
          content: Text(
            'Family member deleted successfully!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B14),

      appBar: AppBar(
        backgroundColor: const Color(0xFF080B14),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: _isLoading
            ? _buildShimmerLoading()
            : familyMembers.isEmpty
                ? _buildEmptyState()
                : _buildFamilyList(),
      ),

      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xFF3B82F6),
              elevation: 8,
              onPressed: _addFamilyMember,
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

  // ================= SHIMMER LOADING =================

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ShimmerLoading(
          width: double.infinity,
          height: 230,
          borderRadius: BorderRadius.circular(28),
        ),

        const SizedBox(height: 30),

        Row(
          children: [
            ShimmerLoading(
              width: 28,
              height: 28,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(width: 10),
            ShimmerLoading(
              width: 170,
              height: 25,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),

        const SizedBox(height: 20),

        ...List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ShimmerLoading(
              width: double.infinity,
              height: 102,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
      ],
    );
  }

  // ================= FAMILY LIST =================

  Widget _buildFamilyList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(),

        const SizedBox(height: 30),

        Row(
          children: [
            const Icon(
              Icons.people_alt_rounded,
              color: Color(0xFF3B82F6),
              size: 24,
            ),

            const SizedBox(width: 10),

            const Text(
              'Family Members',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            Text(
              '${familyMembers.length}',
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 16,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        ...familyMembers.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final member = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _FamilyMemberCard(
                name: member['name'] ?? '',
                relation: member['relation'] ?? '',
                image: member['image'],
                heroTag: 'member_photo_$index',
                onTap: () => _openFamilyMember(index),
              ),
            );
          },
        ),

        const SizedBox(height: 90),
      ],
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A5F),
            Color(0xFF111827),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF263548),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
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
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ================= EMPTY STATE =================

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF111827),
                border: Border.all(
                  color: const Color(0xFF263548),
                ),
              ),
              child: const Icon(
                Icons.family_restroom_rounded,
                color: Color(0xFF3B82F6),
                size: 55,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'No Family Members Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Start building your family memories by adding your first family member.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: _addFamilyMember,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Add Family Member'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= FAMILY MEMBER CARD =================

class _FamilyMemberCard extends StatelessWidget {
  final String name;
  final String relation;
  final Uint8List? image;
  final String heroTag;
  final VoidCallback onTap;

  const _FamilyMemberCard({
    required this.name,
    required this.relation,
    required this.image,
    required this.heroTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFF263548),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: heroTag,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF3B82F6),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: image != null
                        ? Image.memory(
                            image!,
                            fit: BoxFit.cover,
                          )
                        : _buildDefaultAvatar(),
                  ),
                ),
              ),

              const SizedBox(width: 18),

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
                        color: const Color(0xFF1E3A5F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        relation,
                        style: const TextStyle(
                          color: Color(0xFF93C5FD),
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
                color: Color(0xFF9CA3AF),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFF1E3A5F),
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}