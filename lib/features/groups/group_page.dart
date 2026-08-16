import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  // Replace this with your Firestore data later.
  final List<GroupModel> groups = const [
    GroupModel(
      id: '1',
      name: 'Goa Trip',
      description: 'Expenses for our Goa trip',
      emoji: '🏖️',
      members: 6,
      createdAt: '2026-08-14T10:30:00',
    ),
    GroupModel(
      id: '2',
      name: 'Flat Expenses',
      description: 'Monthly room and grocery expenses',
      emoji: '🏠',
      members: 4,
      createdAt: '2026-08-10T18:20:00',
    ),
    GroupModel(
      id: '3',
      name: 'Office Lunch',
      description: 'Team lunch expense sharing',
      emoji: '🍕',
      members: 8,
      createdAt: '2026-08-05T13:15:00',
    ),
    GroupModel(
      id: '4',
      name: 'Chennai Trip',
      description: 'Trip expenses with friends',
      emoji: '🚗',
      members: 5,
      createdAt: '2026-07-28T09:45:00',
    ),
    GroupModel(
      id: '4',
      name: 'Ooty Trip',
      description: 'Trip expenses with friends',
      emoji: '🚗',
      members: 5,
      createdAt: '2026-07-28T09:45:00',
    ),
    GroupModel(
      id: '4',
      name: 'Erode Trip',
      description: 'Trip expenses with friends',
      emoji: '🚗',
      members: 5,
      createdAt: '2026-07-28T09:45:00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                // Create group
              },
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Create group',
            ),
          ),
        ],
      ),

      body: groups.isEmpty
          ? _EmptyGroups()
          : Column(
              children: [
                _buildHeader(theme),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                        sliver: SliverList.separated(
                          itemCount: groups.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final group = groups[index];

                            return _GroupCard(
                              group: group,
                              onTap: () {
                                // Open group
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Create group
        },
        icon: const Icon(Icons.group_add_rounded),
        label: const Text('New Group'),
        heroTag: 'group_page',
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
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
                  '${groups.length} ${groups.length == 1 ? 'Group' : 'Groups'}',
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
  final GroupModel group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final createdDate = DateTime.tryParse(group.createdAt);

    final formattedDate = createdDate == null
        ? group.createdAt
        : DateFormat('dd MMM yyyy').format(createdDate);

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
                              '${group.members} ${group.members == 1 ? 'member' : 'members'}',
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
                // Create group
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
