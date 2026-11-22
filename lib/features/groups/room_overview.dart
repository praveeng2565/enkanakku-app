import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/room_model.dart';
import '../../repositories/user_session.dart';
import 'room_view_model.dart';

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
String _fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

/// The "Group Split" tab. It is a tab body, so the bottom navigation bar
/// belongs to your app shell, not to this screen.
class RoomsOverViewScreen extends StatefulWidget {
  const RoomsOverViewScreen({super.key});

  @override
  State<RoomsOverViewScreen> createState() => _RoomsOverViewScreenState();
}

class _RoomsOverViewScreenState extends State<RoomsOverViewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final uid = UserSession.instance.uniqueId;
      context.read<RoomViewModel>().start(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoomViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              onAdd: () {
                Navigator.pushNamed(context, '/CreateGroup');
              },
            ),
            Expanded(child: _buildBody(context, vm)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/CreateGroup'),
        icon: const Icon(Icons.group_add_outlined),
        label: const Text('New Group'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, RoomViewModel vm) {
    return Consumer<RoomViewModel>(
      builder: (context, _, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final rooms = vm.myRooms;
        if (rooms.isEmpty) {
          return _EmptyState(
            onCreate: () => Navigator.pushNamed(context, '/CreateGroup'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          itemCount: rooms.length + 1, // +1 for the summary card at the top
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            if (i == 0) return _SummaryCard(count: rooms.length);
            final room = rooms[i - 1];
            return _RoomCard(
              room: room,
              onTap: () => Navigator.pushNamed(
                context,
                '/RoomDetailScreen',
                arguments: {'roomId': room.id},
              ),
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Header: title, subtitle and the round "+" button
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Group Split',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage shared expenses',
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onAdd,
            tooltip: 'New group',
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "6 Groups" summary card
// ---------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.groups_rounded, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count ${count == 1 ? 'Group' : 'Groups'}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Split expenses with friends and family',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// One group card: emoji tile, name, description, members, created date
// ---------------------------------------------------------------------------

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, required this.onTap});
  final RoomModel room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final members = room.memberIds.length;

    return Material(
      color: scheme.surfaceContainerLow,
      clipBehavior:
          Clip.antiAlias, // keeps the tap ripple inside the rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(room.emoji, style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (room.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        room.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 14,
                      runSpacing: 4,
                      children: [
                        _Meta(
                          icon: Icons.group_outlined,
                          text:
                              '$members ${members == 1 ? 'member' : 'members'}',
                        ),
                        _Meta(
                          icon: Icons.calendar_today_outlined,
                          text: 'Created ${_fmtDate(room.createdAt)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shown when the user is not in any group yet
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.groups_outlined, size: 56, color: scheme.outline),
            const SizedBox(height: 14),
            const Text(
              'No groups yet',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Create a group to start splitting expenses with friends and family.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('Create a group'),
            ),
          ],
        ),
      ),
    );
  }
}
