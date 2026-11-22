import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/room_model.dart';
import '../../repositories/room_repository.dart';
import '../../repositories/user_session.dart';
import '../../services/snackbar_service.dart';

/// Backs the Groups tab (list) and the Create Group screen.
/// Provide it above both screens, e.g. in main.dart's MultiProvider.
class RoomViewModel extends ChangeNotifier {
  RoomViewModel(this._repo);
  final RoomRepository _repo;
  StreamSubscription<List<RoomModel>>? _sub;

  List<RoomModel> myRooms = [];
  bool isLoading = true;
  bool isCreating = false;

  void refresh() {
    notifyListeners();
  }

  /// Call once the user is signed in (e.g. from the Groups screen's initState).
  void start() {
    final uid = UserSession.instance.uniqueId;
    _sub?.cancel();
    isLoading = true;
    _sub = _repo
        .watchMyRooms(uid)
        .listen(
          (rooms) {
            myRooms = rooms;
            isLoading = false;
            refresh();
          },
          onError: (_) {
            isLoading = false;
            refresh();
          },
        );
  }

  /// Call on sign-out so the next user never sees the previous user's groups.
  void stop() {
    _sub?.cancel();
    _sub = null;
    myRooms = [];
    isLoading = true;
    refresh();
  }

  /// Returns the new group's id, or null if creation failed.
  Future<String?> createRoom({
    required String uid,
    required String name,
    String description = '',
    required String emoji,
  }) async {
    isCreating = true;
    refresh();
    try {
      return await _repo.createRoom(
        uid: uid,
        name: name,
        description: description,
        emoji: emoji,
      );
    } catch (_) {
      SnackbarService.showErrorMessage(
        'Could not create the group. Try again.',
      );
      return null;
    } finally {
      isCreating = false;
      refresh();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
