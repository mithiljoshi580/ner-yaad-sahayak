import 'package:flutter/material.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  final Map<String, String>? existingMember;

  const AddFamilyMemberScreen({
    super.key,
    this.existingMember,
  });

  @override
  State<AddFamilyMemberScreen> createState() =>
      _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState
    extends State<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController relationController;
  late final TextEditingController aboutController;
  late final TextEditingController imageController;

  static const Color backgroundColor = Color(0xFF080B14);
  static const Color cardColor = Color(0xFF111827);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color borderColor = Color(0xFF263548);
  static const Color secondaryTextColor = Color(0xFF9CA3AF);

  bool get isEditing => widget.existingMember != null;

  @override
  void initState() {
    super.initState();

    // Pre-fill the form when editing
    nameController = TextEditingController(
      text: widget.existingMember?['name'] ?? '',
    );

    relationController = TextEditingController(
      text: widget.existingMember?['relation'] ?? '',
    );

    aboutController = TextEditingController(
      text: widget.existingMember?['about'] ?? '',
    );

    imageController = TextEditingController(
      text: widget.existingMember?['image'] ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    relationController.dispose();
    aboutController.dispose();
    imageController.dispose();

    super.dispose();
  }

  void _saveFamilyMember() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final member = <String, String>{
      'name': nameController.text.trim(),
      'relation': relationController.text.trim(),
      'about': aboutController.text.trim(),
      'image': imageController.text.trim(),
    };

    // Return the member to the previous screen
    Navigator.pop(context, member);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        title: Text(
          isEditing ? 'Edit Family Member' : 'Add Family Member',
          style: const TextStyle(
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HEADER =================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: borderColor,
                    ),
                  ),

                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: accentColor,
                        size: 45,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        isEditing
                            ? 'Update Family Member'
                            : 'Add Someone Special',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        isEditing
                            ? 'Update the information of your loved one.'
                            : 'Add your loved ones and preserve their precious memories.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Member Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                // ================= NAME =================

                _buildTextField(
                  controller: nameController,
                  label: 'Full Name',
                  hint: 'Enter family member name',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ================= RELATIONSHIP =================

                _buildTextField(
                  controller: relationController,
                  label: 'Relationship',
                  hint: 'Example: Mother, Father, Sister',
                  icon: Icons.family_restroom_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the relationship';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ================= ABOUT =================

                _buildTextField(
                  controller: aboutController,
                  label: 'About',
                  hint: 'Write something about this family member',
                  icon: Icons.description_outlined,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write something about them';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ================= IMAGE URL =================

                _buildTextField(
                  controller: imageController,
                  label: 'Profile Image URL (Optional)',
                  hint: 'Paste an image URL if available',
                  icon: Icons.image_outlined,
                  validator: null,
                ),

                const SizedBox(height: 35),

                // ================= SAVE BUTTON =================

                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton.icon(
                    onPressed: _saveFamilyMember,

                    icon: Icon(
                      isEditing
                          ? Icons.save_rounded
                          : Icons.check_circle_outline_rounded,
                    ),

                    label: Text(
                      isEditing
                          ? 'Save Changes'
                          : 'Add Family Member',
                      style: const TextStyle(
                        fontSize: 17,
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

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TEXT FIELD =================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,

          style: const TextStyle(
            color: Colors.white,
          ),

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: const TextStyle(
              color: secondaryTextColor,
              fontSize: 14,
            ),

            prefixIcon: Icon(
              icon,
              color: accentColor,
            ),

            filled: true,
            fillColor: cardColor,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: borderColor,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: borderColor,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: accentColor,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}