import 'dart:math';
import '../../models/room_expense_model.dart';
import '../../models/settlement_model.dart';

/// "[from] should pay [to] [paise]".
class Transfer {
  const Transfer({required this.from, required this.to, required this.paise});
  final String from;
  final String to;
  final int paise;
}

class _Slot {
  _Slot(this.uid, this.amount);
  final String uid;
  int amount;
}

/// Pure Dart, no Flutter or Firebase imports, so it is easy to unit test.
class SettleUp {
  SettleUp._();

  /// Net balance per member in paise.
  /// Positive = the group owes them. Negative = they owe the group.
  /// All balances always add up to exactly zero.
  static Map<String, int> balances({
    required List<String> memberIds,
    required List<RoomExpenseModel> expenses,
    required List<SettlementModel> settlements,
  }) {
    final result = <String, int>{for (final id in memberIds) id: 0};

    for (final e in expenses) {
      if (e.splitAmong.isEmpty) continue;

      final total = e.amountInPaise;
      final people = [...e.splitAmong]..sort();
      final base = total ~/ people.length;
      var remainder = total - base * people.length;

      // The payer is credited the full amount...
      result[e.paidBy] = (result[e.paidBy] ?? 0) + total;

      // ...and everyone in the split is debited their share. Leftover
      // paise are handed out one each, so shares sum to the total exactly.
      for (final uid in people) {
        final extra = remainder > 0 ? 1 : 0;
        if (remainder > 0) remainder--;
        result[uid] = (result[uid] ?? 0) - (base + extra);
      }
    }

    // A recorded payment: the payer owes less, the receiver is owed less.
    for (final s in settlements) {
      final p = s.amountInPaise;
      result[s.fromUid] = (result[s.fromUid] ?? 0) + p;
      result[s.toUid] = (result[s.toUid] ?? 0) - p;
    }

    return result;
  }

  /// Greedy matching of the biggest debtor with the biggest creditor.
  /// Produces at most (people - 1) payments, instead of everyone paying
  /// everyone.
  static List<Transfer> minimizeTransfers(Map<String, int> balances) {
    int byAmountThenUid(_Slot a, _Slot b) {
      final c = b.amount.compareTo(a.amount);
      return c != 0 ? c : a.uid.compareTo(b.uid);
    }

    final creditors =
        balances.entries
            .where((e) => e.value > 0)
            .map((e) => _Slot(e.key, e.value))
            .toList()
          ..sort(byAmountThenUid);

    final debtors =
        balances.entries
            .where((e) => e.value < 0)
            .map((e) => _Slot(e.key, -e.value))
            .toList()
          ..sort(byAmountThenUid);

    final transfers = <Transfer>[];
    var i = 0;
    var j = 0;

    while (i < debtors.length && j < creditors.length) {
      final pay = min(debtors[i].amount, creditors[j].amount);
      transfers.add(
        Transfer(from: debtors[i].uid, to: creditors[j].uid, paise: pay),
      );

      debtors[i].amount -= pay;
      creditors[j].amount -= pay;

      if (debtors[i].amount == 0) i++;
      if (creditors[j].amount == 0) j++;
    }

    return transfers;
  }
}
