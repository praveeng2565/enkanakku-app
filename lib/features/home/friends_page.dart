import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FriendsSplitPage extends StatelessWidget {
  const FriendsSplitPage({super.key});

  final List<FriendSplitModel> friends = const [
    FriendSplitModel(
      id: '1',
      name: 'Arun',
      customId: '#CCDRTF34',
      avatar: 'A',
      youPaid: 1250,
      theyPaid: 800,
      lastActivity: '2026-08-14T18:30:00',
    ),
    FriendSplitModel(
      id: '2',
      name: 'Karthik',
      customId: '#A7KDF82P',
      avatar: 'K',
      youPaid: 420,
      theyPaid: 980,
      lastActivity: '2026-08-12T13:15:00',
    ),
    FriendSplitModel(
      id: '3',
      name: 'Priya',
      customId: '#X92PLK71',
      avatar: 'P',
      youPaid: 750,
      theyPaid: 750,
      lastActivity: '2026-08-09T20:10:00',
    ),
    FriendSplitModel(
      id: '4',
      name: 'Vijay',
      customId: '#Q8TR56FD',
      avatar: 'V',
      youPaid: 1200,
      theyPaid: 400,
      lastActivity: '2026-08-03T19:45:00',
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
            Text(
              'Friends Split',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              'Split expenses directly with friends',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              onPressed: () {
                // Add friend / find friend
              },
              icon: const Icon(Icons.person_add_alt_1_rounded),
              tooltip: 'Add friend',
            ),
          ),
        ],
      ),

      body: friends.isEmpty
          ? const _EmptyFriends()
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
                          itemCount: friends.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final friend = friends[index];

                            return _FriendCard(
                              friend: friend,
                              onTap: () {
                                // Open friend split details
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
          // Find / add friend
        },
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add Friend'),
        heroTag: 'friends_page',
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
            child: Icon(
              Icons.people_alt_rounded,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${friends.length} ${friends.length == 1 ? 'Friend' : 'Friends'}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Track shared expenses with your friends',
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

class _FriendCard extends StatelessWidget {
  const _FriendCard({required this.friend, required this.onTap});
  final FriendSplitModel friend;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final balance = friend.youPaid - friend.theyPaid;

    final lastActivity = DateTime.tryParse(friend.lastActivity);

    final formattedDate = lastActivity == null
        ? friend.lastActivity
        : DateFormat('dd MMM yyyy').format(lastActivity);

    final bool youGet = balance > 0;
    // final bool youOwe = balance < 0;
    final bool settled = balance == 0;

    String balanceText;

    if (settled) {
      balanceText = 'Settled up';
    } else if (youGet) {
      balanceText = 'You get ₹${_formatAmount(balance.abs())}';
    } else {
      balanceText = 'You owe ₹${_formatAmount(balance.abs())}';
    }

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
              // Avatar
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  friend.avatar,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Friend information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      friend.customId,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 11),

                    Row(
                      children: [
                        Icon(
                          settled
                              ? Icons.check_circle_outline_rounded
                              : youGet
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          size: 16,
                          color: settled
                              ? theme.colorScheme.onSurfaceVariant
                              : youGet
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            balanceText,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: settled
                                  ? theme.colorScheme.onSurfaceVariant
                                  : youGet
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Last split · $formattedDate',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

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

  static String _formatAmount(double value) {
    return NumberFormat('#,##,###.##', 'en_IN').format(value);
  }
}

class _EmptyFriends extends StatelessWidget {
  const _EmptyFriends();

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
                Icons.people_alt_rounded,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'No friends yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Add a friend to start splitting expenses directly.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () {
                // Add friend
              },
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Add Friend'),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendSplitModel {
  const FriendSplitModel({
    required this.id,
    required this.name,
    required this.customId,
    required this.avatar,
    required this.youPaid,
    required this.theyPaid,
    required this.lastActivity,
  });
  final String id;
  final String name;
  final String customId;
  final String avatar;

  /// Total amount paid by you towards shared expenses.
  final double youPaid;

  /// Total amount paid by your friend towards shared expenses.
  final double theyPaid;

  final String lastActivity;
}
