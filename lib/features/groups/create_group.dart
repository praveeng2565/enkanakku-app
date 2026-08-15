import 'package:flutter/material.dart';

import '../../models/room.dart';
import '../../repositories/user_session.dart';
import '../../services/snackbar_service.dart';
import '../../utils/base_page.dart';
import '../../utils/common.dart';
import '../../widgets/custom_text_field.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  late Room _room;

  @override
  void initState() {
    super.initState();
    _room = Room(id: getNewID(), createdBy: UserSession.instance.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Create Group',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Name',
                      hintText: 'Enter the group name',
                      onChanged: (value) {
                        _room.name = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'About',
                      hintText: 'Say about group',
                      minLines: 2,
                      maxLines: 4,
                      prefixIcon: Icons.edit_note_rounded,
                      onChanged: (value) {
                        _room.note = value;
                      },
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _validateAndCreateGroup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Group',
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
      ),
    );
  }

  Future<void> _validateAndCreateGroup() async {
    hideKeyboard();
    final val = _validate();
    if (!val) return;
    showProgressCircle(context);
    //
  }

  bool _validate() {
    if (_room.name.isEmpty) {
      SnackbarService.showErrorMessage('Group name cannot be empty');
      return false;
    }
    return true;
  }
}
