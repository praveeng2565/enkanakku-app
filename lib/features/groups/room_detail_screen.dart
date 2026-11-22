import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/room_model.dart';
import '../../models/user_profile.dart';
import '../../repositories/room_repository.dart';
import '../../repositories/user_session.dart';
import '../../repositories/users_repository.dart';
import '../../services/snackbar_service.dart';
import '../../utils/currency_formatter.dart';
import '../friends/find_friends.dart';
import 'room_detail_view_model.dart';
import 'settle_up.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
String _fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

BoxDecoration _cardDecoration(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  return BoxDecoration(
    color: scheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: scheme.outlineVariant),
  );
}

void _openFindFriends(BuildContext context, String roomId) {
  //TODO:
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => FindFriendsScreen(roomIdToAddTo: roomId)),
  );
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          RoomDetailViewModel(roomId, RoomRepository(), UsersRepository()),
      builder: (BuildContext context, Widget? child) => const RoomDetails(),
    );
  }
}

class RoomDetails extends StatelessWidget {
  const RoomDetails({super.key});

  void _showAddExpense(
    BuildContext context,
    RoomDetailViewModel vm,
    String uid,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      // The sheet sits above the provider in the widget tree, so the
      // ViewModel is passed in directly instead of read from context.
      builder: (_) => _AddExpenseSheet(vm: vm, currentUid: uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RoomDetailViewModel>(context, listen: false);
    return Consumer<RoomDetailViewModel>(
      builder: (context, _, _) {
        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final room = vm.room;
        if (vm.notFound || room == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  "This group doesn't exist, or you're not a member of it.",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final uid = UserSession.instance.uniqueId;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(room.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      room.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Add member',
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  onPressed: () => _openFindFriends(context, room.id),
                ),
              ],
            ),
            body: Column(
              children: [
                _SummaryCard(vm: vm, uid: uid),
                const TabBar(
                  tabs: [
                    Tab(text: 'Expenses'),
                    Tab(text: 'Settle up'),
                    Tab(text: 'Members'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _ExpensesTab(vm: vm),
                      _SettleUpTab(vm: vm, room: room),
                      _MembersTab(vm: vm, room: room),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showAddExpense(context, vm, uid),
              icon: const Icon(Icons.add),
              label: const Text('Add expense'),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Summary card
// ---------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.vm, required this.uid});
  final RoomDetailViewModel vm;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final balance = vm.balances[uid] ?? 0;

    final String line;
    if (balance > 0) {
      line = 'You are owed ${formatPaise(balance)}';
    } else if (balance < 0) {
      line = 'You owe ${formatPaise(-balance)}';
    } else {
      line = 'You are all settled up';
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total spent',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatPaise(vm.totalSpentPaise),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  line,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Icon(Icons.groups_outlined, color: scheme.onPrimaryContainer),
              const SizedBox(height: 4),
              Text(
                '${vm.room!.memberIds.length} members',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Expenses tab
// ---------------------------------------------------------------------------

class _ExpensesTab extends StatelessWidget {
  const _ExpensesTab({required this.vm});
  final RoomDetailViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (vm.expenses.isEmpty) {
      return const _EmptyState(
        icon: Icons.receipt_long_outlined,
        text: 'No expenses yet.\nTap "Add expense" to log the first one.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: vm.expenses.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final e = vm.expenses[i];
        return Container(
          decoration: _cardDecoration(context),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: scheme.secondaryContainer,
              child: Icon(
                Icons.receipt_long_outlined,
                color: scheme.onSecondaryContainer,
              ),
            ),
            title: Text(
              e.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Paid by ${vm.nameOf(e.paidBy)} • ${_fmtDate(e.date)}\n'
              'Split ${e.splitAmong.length} ways',
            ),
            isThreeLine: true,
            trailing: Text(
              formatPaise(e.amountInPaise),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Settle up tab
// ---------------------------------------------------------------------------

class _SettleUpTab extends StatelessWidget {
  const _SettleUpTab({required this.vm, required this.room});
  final RoomDetailViewModel vm;
  final RoomModel room;

  Future<void> _confirmSettle(BuildContext context, Transfer t) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record payment?'),
        content: Text(
          '${vm.nameOf(t.from)} paid ${vm.nameOf(t.to)} ${formatPaise(t.paise)}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    final ok = await vm.settle(t);
    if (!ok) SnackbarService.showErrorMessage('Could not record the payment');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final transfers = vm.transfers;

    // Current members, plus anyone who left but still has a balance.
    final entries =
        vm.balances.entries
            .where((e) => room.memberIds.contains(e.key) || e.value != 0)
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        Text('Balances', style: _sectionStyle(scheme)),
        const SizedBox(height: 10),
        ...entries.map((entry) {
          final paise = entry.value;
          final Color color;
          final String label;
          if (paise > 0) {
            color = Colors.green.shade600;
            label = 'gets back ${formatPaise(paise)}';
          } else if (paise < 0) {
            color = scheme.error;
            label = 'owes ${formatPaise(-paise)}';
          } else {
            color = scheme.outline;
            label = 'settled';
          }
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: _cardDecoration(context),
            child: ListTile(
              leading: _Avatar(vm.members[entry.key]),
              title: Text(
                vm.nameOf(entry.key),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w700, color: color),
              ),
            ),
          );
        }),
        const SizedBox(height: 14),
        Text('Suggested payments', style: _sectionStyle(scheme)),
        const SizedBox(height: 10),
        if (transfers.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(context),
            child: const Center(
              child: Text(
                'All settled up 🎉',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          )
        else
          ...transfers.map(
            (t) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
              decoration: _cardDecoration(context),
              child: Column(
                children: [
                  Row(
                    children: [
                      _Avatar(vm.members[t.from], radius: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${vm.nameOf(t.from)} pays ${vm.nameOf(t.to)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        formatPaise(t.paise),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _confirmSettle(context, t),
                      child: const Text('Mark as paid'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  TextStyle _sectionStyle(ColorScheme scheme) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: scheme.onSurfaceVariant,
  );
}

// ---------------------------------------------------------------------------
// Members tab
// ---------------------------------------------------------------------------

class _MembersTab extends StatelessWidget {
  const _MembersTab({required this.vm, required this.room});
  final RoomDetailViewModel vm;
  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        ...room.memberIds.map((id) {
          final profile = vm.members[id];
          final tag = UserSession.instance.uniqueId;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: _cardDecoration(context),
            child: ListTile(
              leading: _Avatar(profile),
              title: Text(
                vm.nameOf(id),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: tag.isEmpty ? null : Text('#$tag'),
              trailing: id == room.createdBy
                  ? const Chip(
                      label: Text('Admin'),
                      visualDensity: VisualDensity.compact,
                    )
                  : null,
            ),
          );
        }),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          onPressed: () => _openFindFriends(context, room.id),
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: const Text('Add member by player tag'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Add expense bottom sheet (equal split)
// ---------------------------------------------------------------------------

class _AddExpenseSheet extends StatefulWidget {
  const _AddExpenseSheet({required this.vm, required this.currentUid});
  final RoomDetailViewModel vm;
  final String currentUid;

  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  late String _paidBy;
  late Set<String> _splitAmong;
  bool _saving = false;
  String? _error;

  List<String> get _ids => widget.vm.room!.memberIds;

  @override
  void initState() {
    super.initState();
    _paidBy = _ids.contains(widget.currentUid) ? widget.currentUid : _ids.first;
    _splitAmong = {..._ids};
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      setState(() => _error = 'Enter what it was for and a valid amount');
      return;
    }
    if (_splitAmong.isEmpty) {
      setState(() => _error = 'Pick at least one person to split with');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    final ok = await widget.vm.addExpense(
      title: title,
      amount: amount,
      paidBy: _paidBy,
      splitAmong: _splitAmong.toList(),
    );

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = 'Could not save. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add expense',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'What was it for?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _paidBy,
              decoration: InputDecoration(
                labelText: 'Paid by',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _ids
                  .map(
                    (id) => DropdownMenuItem(
                      value: id,
                      child: Text(widget.vm.nameOf(id)),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _paidBy = v);
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Split equally between',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _ids.map((id) {
                return FilterChip(
                  label: Text(widget.vm.nameOf(id)),
                  selected: _splitAmong.contains(id),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _splitAmong.add(id);
                    } else {
                      _splitAmong.remove(id);
                    }
                  }),
                );
              }).toList(),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _error!,
                  style: TextStyle(color: scheme.error, fontSize: 13),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small shared pieces
// ---------------------------------------------------------------------------

class _Avatar extends StatelessWidget {
  const _Avatar(this.profile, {this.radius = 20});
  final UserProfile? profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final name = profile?.name ?? '';
    final photo = profile?.photoUrl ?? '';

    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.secondaryContainer,
      backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
      child: photo.isEmpty
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: scheme.onSecondaryContainer,
              ),
            )
          : null,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: scheme.outline),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
