import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
import 'profile_view_model.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileViewModel>().profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _mobileController = TextEditingController(text: profile?.mobileno ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // final picked = await ImagePicker().pickImage(
    //   source: ImageSource.gallery,
    //   imageQuality: 80,
    // );
    // if (picked != null) {
    //   setState(() => _pickedImage = File(picked.path));
    // }
  }

  Future<void> _save() async {
    // final vm = context.read<ProfileViewModel>();
    // final currentProfile = vm.profile;
    // if (currentProfile == null) return;

    // String photoUrl = currentProfile.photoUrl;
    // if (_pickedImage != null) {
    //   final uploadedUrl = await vm.uploadProfilePhoto( _pickedImage!);
    //   if (uploadedUrl != null) photoUrl = uploadedUrl;
    // }

    // final updated = UserProfile(
    //   id: currentProfile.id,
    //   name: _nameController.text.trim(),
    //   email: currentProfile.email,
    //   mobileno: _mobileController.text.trim(),
    //   photoUrl: photoUrl,
    //   roomList: currentProfile.roomList,
    //   notificationList: currentProfile.notificationList,
    //   dataSharing: currentProfile.dataSharing,
    // );

    // final success = await vm.updateProfile(updated);

    // if (mounted) {
    //   if (success) {
    //     Navigator.pop(context);
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Failed to save profile. Try again.')),
    //     );
    //   }
    // }
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFEFF1F5),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    final profile = vm.profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: vm.isSaving ? null : _save,
            child: vm.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: const Color(0xFFEFF1F5),
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!) as ImageProvider
                        : (profile != null && profile.photoUrl.isNotEmpty
                              ? NetworkImage(profile.photoUrl)
                              : null),
                    child:
                        (_pickedImage == null &&
                            (profile == null || profile.photoUrl.isEmpty))
                        ? const Icon(
                            Icons.person,
                            size: 44,
                            color: Colors.black26,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E3A8A),
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Full name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: _fieldDecoration('Enter your name'),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mobile number',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: _fieldDecoration('Enter your mobile number'),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false,
              controller: TextEditingController(text: profile?.email ?? ''),
              decoration: _fieldDecoration('Email').copyWith(
                fillColor: const Color(0xFFE5E7EB),
                suffixIcon: const Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: Colors.black38,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email is tied to your sign-in and can't be changed here",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
