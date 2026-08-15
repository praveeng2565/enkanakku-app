import 'package:flutter/material.dart';

import '../../services/login_auth.dart';
import '../../utils/common.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final String name = 'Praveen Keerthana';
  final String email = 'lifeledgerappdev@gmail.com';
  final String mobile = '9698357997';

  final int groupCount = 0;
  final int alertCount = 0;
  final int sharedCount = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildProfileHeader(context)),

            SliverToBoxAdapter(child: _buildStats(context)),

            SliverToBoxAdapter(child: _buildSectionTitle(context, 'Personal')),

            SliverToBoxAdapter(child: _buildPersonalCard(context)),

            SliverToBoxAdapter(
              child: _buildSectionTitle(context, 'Your Activity'),
            ),

            SliverToBoxAdapter(child: _buildActivityCard(context)),

            SliverToBoxAdapter(child: _buildAccountCard(context)),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

      // bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // ---------------------------------------------------------------------------
  // PROFILE HEADER
  // ---------------------------------------------------------------------------

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Top bar
          Row(
            children: [
              Text(
                'Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              IconButton(
                onPressed: () {
                  // Open settings
                },
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimary.withValues(
                    alpha: 0.14,
                  ),
                ),
                icon: Icon(
                  Icons.settings_outlined,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Profile image
          Stack(
            children: [
              Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.onPrimary,
                    width: 3,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _getInitial(name),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 29,
                  width: 29,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 14,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            email,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.75),
            ),
          ),

          const SizedBox(height: 16),

          // Edit profile
          FilledButton.tonalIcon(
            onPressed: () {
              // Navigate to edit profile
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.onPrimary.withValues(
                alpha: 0.14,
              ),
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            icon: const Icon(Icons.edit_outlined, size: 17),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATS
  // ---------------------------------------------------------------------------

  Widget _buildStats(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: const Offset(0, -1),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 4),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(value: '$groupCount', label: 'Groups'),
            ),

            _verticalDivider(context),

            Expanded(
              child: _StatItem(value: '$alertCount', label: 'Alerts'),
            ),

            _verticalDivider(context),

            Expanded(
              child: _StatItem(value: '$sharedCount', label: 'Shared'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION TITLE
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 9),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PERSONAL
  // ---------------------------------------------------------------------------

  Widget _buildPersonalCard(BuildContext context) {
    return _SectionCard(
      children: [
        _InfoTile(
          icon: Icons.phone_outlined,
          title: 'Mobile number',
          subtitle: mobile,
        ),

        const _CardDivider(),

        _InfoTile(icon: Icons.email_outlined, title: 'Email', subtitle: email),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIVITY
  // ---------------------------------------------------------------------------

  Widget _buildActivityCard(BuildContext context) {
    return _SectionCard(
      children: [
        _NavigationTile(
          icon: Icons.groups_rounded,
          title: 'Groups',
          subtitle: '$groupCount joined',
          onTap: () {
            // Open groups
          },
        ),

        const _CardDivider(),

        _NavigationTile(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          subtitle: '$alertCount active',
          onTap: () {
            // Open notifications
          },
        ),

        const _CardDivider(),

        _NavigationTile(
          icon: Icons.shield_outlined,
          title: 'Data & privacy',
          subtitle: 'Manage your data and permissions',
          onTap: () {
            // Open privacy
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ACCOUNT
  // ---------------------------------------------------------------------------

  Widget _buildAccountCard(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
      child: Material(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () {
            _showLogoutDialog(context);
          },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign out',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Tap to log out from this application',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out?'),
          content: const Text(
            'Are you sure you want to sign out from your account?',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                showProgressCircle(context);
                Navigator.pop(context);
                await AuthService().logout();
                removeProgressCircle(context);
                Navigator.pushReplacementNamed(context, '/Login');
              },
              child: const Text('Sign out'),
            ),
          ],
        );
      },
    );
  }

  String _getInitial(String value) {
    if (value.trim().isEmpty) {
      return '?';
    }

    return value.trim()[0].toUpperCase();
  }
}

// =============================================================================
// REUSABLE WIDGETS
// =============================================================================

class _StatItem extends StatelessWidget {

  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {

  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(children: children),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        height: 1,
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: 0.6),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          _IconContainer(icon: icon),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
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

class _NavigationTile extends StatelessWidget {

  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _IconContainer(icon: icon),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {

  const _IconContainer({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 19, color: theme.colorScheme.primary),
    );
  }
}
