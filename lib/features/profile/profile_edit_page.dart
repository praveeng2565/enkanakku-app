import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/progress_service.dart';
import '../../services/snackbar_service.dart';
import '../../utils/base_page.dart';
import '../../widgets/custom_text_field.dart';
import 'profile_view_model.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key, required this.vm});
  final ProfileViewModel vm;
  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _pickedImage;
  late UserProfile profile;
  late bool isEdited;
  @override
  void initState() {
    super.initState();
    isEdited = false;
    profile = widget.vm.profile!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    // final picked = await ImagePicker().pickImage(
    //   source: ImageSource.gallery,
    //   maxWidth: 512,
    //   maxHeight: 512,
    //   imageQuality: 80,
    // );
    // if (picked != null) {
    //   isEdited = true;
    //   setState(() => _pickedImage = File(picked.path));
    // }
    SnackbarService.showInfoMessage(
      'Oops! Image uploads are temporarily unavailable.',
    );
  }

  Future<void> _save() async {
    ProgressService.show(context);
    // String photoUrl = profile.photoUrl;
    // if (_pickedImage != null) {
    //   final uploadedUrl = await widget.vm.uploadProfilePhoto(_pickedImage!);
    //   if (uploadedUrl != null) photoUrl = uploadedUrl;
    // }
    // profile.photoUrl = photoUrl;
    final success = await widget.vm.updateProfile(profile);
    ProgressService.hide(context);
    if (success) {
      Navigator.pop(context);
      SnackbarService.showInfoMessage('Profile Updated');
    } else {
      SnackbarService.showInfoMessage('Failed to save profile. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Edit Profile',
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                              : (profile.photoUrl.isNotEmpty
                                    ? NetworkImage(profile.photoUrl)
                                    : null),
                          child:
                              (_pickedImage == null &&
                                  (profile.photoUrl.isEmpty))
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
                  CustomTextField(
                    label: 'Full Name',
                    initialValue: profile.name,
                    onChanged: (String p0) {
                      profile.name = p0;
                      if (!isEdited) {
                        isEdited = true;
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    label: 'Mobile number',
                    initialValue: profile.mobileno,
                    keyboardType: TextInputType.number,
                    onChanged: (String p0) {
                      profile.mobileno = p0;
                      if (!isEdited) {
                        isEdited = true;
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    label: 'Email',
                    initialValue: profile.email,
                    keyboardType: TextInputType.number,
                    isDisabled: true,
                    suffixIcon: const Icon(Icons.lock_outline, size: 18),
                    onChanged: (String p0) {
                      profile.email = p0;
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "*Email is tied to your sign-in and can't be changed here",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(
                      color: Color(0xFF1E3A8A),
                      width: 2.0,
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                if (isEdited)
                  ElevatedButton(
                    onPressed: () {
                      _save();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
