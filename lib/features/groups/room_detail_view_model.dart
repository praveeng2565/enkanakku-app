import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/room_expense_model.dart';
import '../../models/room_model.dart';
import '../../models/settlement_model.dart';
import '../../models/user_profile.dart';
import '../../repositories/room_repository.dart';
import '../../repositories/users_repository.dart';
import 'settle_up.dart';

/// Route-scoped: created when a group is opened and disposed when you
/// leave it, so its three Firestore listeners never outlive the screen.
class RoomDetailViewModel extends ChangeNotifier {
  RoomDetailViewModel(this.roomId, this._roomRepo, this._userRepo) {
    _listen();
  }
  final String roomId;
  final RoomRepository _roomRepo;
  final UsersRepository _userRepo;

  RoomModel? room;
  List<RoomExpenseModel> expenses = [];
  List<SettlementModel> settlements = [];
  final Map<String, UserProfile> members = {};

  bool isLoading = true;
  bool notFound = false; // deleted, or the current user is not a member

  StreamSubscription<RoomModel?>? _roomSub;
  StreamSubscription<List<RoomExpenseModel>>? _expenseSub;
  StreamSubscription<List<SettlementModel>>? _settlementSub;
  bool _disposed = false;

  void _listen() {
    _roomSub = _roomRepo
        .watchRoom(roomId)
        .listen(
          (r) {
            room = r;
            isLoading = false;
            notFound = r == null;
            notifyListeners();
            if (r != null) _loadMissingProfiles(r.memberIds);
          },
          onError: (_) {
            // Firestore rules deny reads for non-members.
            isLoading = false;
            notFound = true;
            notifyListeners();
          },
        );

    _expenseSub = _roomRepo.watchExpenses(roomId).listen((list) {
      expenses = list;
      notifyListeners();
    }, onError: (_) {});

    _settlementSub = _roomRepo.watchSettlements(roomId).listen((list) {
      settlements = list;
      notifyListeners();
    }, onError: (_) {});
  }

  Future<void> _loadMissingProfiles(List<String> ids) async {
    final missing = ids.where((id) => !members.containsKey(id)).toList();
    if (missing.isEmpty) return;

    final profiles = await Future.wait(missing.map(_userRepo.getUserData));
    for (var i = 0; i < missing.length; i++) {
      final profile = profiles[i];
      if (profile != null) members[missing[i]] = profile;
    }
    notifyListeners();
  }

  // ---- derived values -------------------------------------------------

  Map<String, int> get balances => SettleUp.balances(
    memberIds: room?.memberIds ?? const [],
    expenses: expenses,
    settlements: settlements,
  );

  List<Transfer> get transfers => SettleUp.minimizeTransfers(balances);

  int get totalSpentPaise =>
      expenses.fold(0, (sum, e) => sum + e.amountInPaise);

  String nameOf(String uid) {
    final name = members[uid]?.name ?? '';
    return name.isNotEmpty ? name : 'Member';
  }

  // ---- actions (return true on success) --------------------------------

  Future<bool> addExpense({
    required String title,
    required double amount,
    required String paidBy,
    required List<String> splitAmong,
  }) async {
    try {
      await _roomRepo.addExpense(
        roomId,
        RoomExpenseModel(
          id: '',
          title: title,
          amount: amount,
          paidBy: paidBy,
          splitAmong: splitAmong,
          date: DateTime.now(),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> settle(Transfer t) async {
    try {
      await _roomRepo.addSettlement(
        roomId,
        SettlementModel(
          id: '',
          fromUid: t.from,
          toUid: t.to,
          amount: t.paise / 100,
          createdAt: DateTime.now(),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---- lifecycle -------------------------------------------------------

  @override
  void notifyListeners() {
    // Profile loading is async and can finish after the screen is closed.
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _roomSub?.cancel();
    _expenseSub?.cancel();
    _settlementSub?.cancel();
    super.dispose();
  }
}
