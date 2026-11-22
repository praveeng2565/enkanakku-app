import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/room_model.dart';
import 'room_view_model.dart';

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
      context.read<RoomViewModel>().start();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoomViewModel>();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Group Split', style: TextStyle(fontWeight: FontWeight.w700)),
            Text(
              'Manage shared expenses',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              onPressed: () {
                Navigator.pushNamed(context, '/CreateRoom');
              },
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Create group',
            ),
          ),
        ],
      ),
      body: _buildBody(context, vm),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/CreateRoom');
        },
        icon: const Icon(Icons.group_add_rounded),
        label: const Text('New Group'),
        heroTag: 'group_page',
      ),
    );
  }

  Widget _buildBody(BuildContext context, RoomViewModel vm) {
    final theme = Theme.of(context);
    return Consumer<RoomViewModel>(
      builder: (context, _, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final rooms = vm.myRooms;
        return rooms.isEmpty
            ? _EmptyGroups()
            : Column(
                children: [
                  _buildHeader(theme, rooms.length),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                          sliver: SliverList.separated(
                            itemCount: rooms.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final room = rooms[index];
                              return _GroupCard(
                                group: room,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/RoomDetailScreen',
                                  arguments: {'roomId': room.id},
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, int length) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.groups_rounded, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$length ${length == 1 ? 'Group' : 'Groups'}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Split expenses with friends and family',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group, required this.onTap});
  final RoomModel group;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final members = group.memberIds.length;
    final formattedDate = DateFormat('dd MMM yyyy').format(group.createdAt);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group icon
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(17),
                ),
                alignment: Alignment.center,
                child: Text(group.emoji, style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      group.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.35,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 14,
                      runSpacing: 6,
                      children: [
                        _InfoItem(
                          icon: Icons.people_outline_rounded,
                          text:
                              '$members ${members == 1 ? 'member' : 'members'}',
                        ),
                        _InfoItem(
                          icon: Icons.calendar_today_outlined,
                          text: 'Created $formattedDate',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Arrow
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 5),
        Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EmptyGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 82,
              width: 82,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_rounded,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No groups yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a group to start splitting expenses with friends and family.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/CreateRoom');
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupModel {
  const GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.members,
    required this.createdAt,
  });
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int members;
  final String createdAt;
}
