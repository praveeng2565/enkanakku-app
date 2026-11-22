import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../repositories/room_repository.dart';
import '../../repositories/users_repository.dart';
import '../../services/snackbar_service.dart';

class FindFriendsScreen extends StatefulWidget {
  // null if just searching, not adding

  const FindFriendsScreen({super.key, this.roomIdToAddTo});
  final String? roomIdToAddTo;

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final _tagController = TextEditingController();
  bool _isSearching = false;
  bool _searched = false;
  UserProfile? _result;

  Future<void> _search() async {
    final tag = _tagController.text.trim();
    if (tag.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searched = false;
      _result = null;
    });

    final profile = await UsersRepository().searchUserByTag(tag);

    setState(() {
      _result = profile;
      _isSearching = false;
      _searched = true;
    });
  }

  Future<void> _addToRoom() async {
    if (_result == null || widget.roomIdToAddTo == null) return;
    await RoomRepository().addMember(widget.roomIdToAddTo!, _result!.id);
    if (mounted) {
      SnackbarService.showSuccessMessage('${_result!.name} added to the room');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Find Friends',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter a player tag',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: '4X7K9QW2',
                      prefixIcon: const Icon(Icons.tag),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isSearching ? null : _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 28),
            if (_searched) _buildResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (_result == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
            'No player found with that tag',
            style: TextStyle(color: Colors.black45),
          ),
        ),
      );
    }

    final profile = _result!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFEFF1F5),
            backgroundImage: profile.photoUrl.isNotEmpty
                ? NetworkImage(profile.photoUrl)
                : null,
            child: profile.photoUrl.isEmpty
                ? Text(
                    profile.name.isNotEmpty
                        ? profile.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E3A8A),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.id,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
          if (widget.roomIdToAddTo != null)
            ElevatedButton(
              onPressed: _addToRoom,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}
