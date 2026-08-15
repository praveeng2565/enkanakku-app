import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/users_repository.dart';
import '../../services/login_auth.dart';
import '../../theme/color.dart';
import '../../utils/common.dart';
import '../../widgets/custom_bottom_sheet.dart';
import 'profile_edit_page.dart';
import 'profile_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfileViewModel(UsersRepository()),
      builder: (BuildContext context, Widget? child) => const Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileViewModel profileViewModel;
  @override
  void initState() {
    super.initState();
    profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileViewModel.loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (BuildContext context, ProfileViewModel vm, Widget? child) {
        final profile = vm.profile;

        if (vm.isLoading || profile == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context, profile)),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -3),
                  child: _buildStatsRow(profile),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    children: [
                      _SectionCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.phone_outlined,
                            title: 'Mobile number',
                            subtitle: profile.mobileno.isEmpty
                                ? 'Not added'
                                : profile.mobileno,
                          ),
                          _SettingsTile(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            subtitle: profile.email,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.groups_outlined,
                            title: 'Groups',
                            subtitle: '${profile.roomList.length} joined',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            subtitle:
                                '${profile.notificationList.length} active',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Data & privacy sharing',
                            subtitle:
                                '${profile.dataSharing.length} permissions granted',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.logout,
                            title: 'Sign out',
                            subtitle: 'Tap to log out from application',
                            titleColor: Colors.red,
                            iconColor: Colors.red,
                            showChevron: false,
                            onTap: () async {
                              showProgressCircle(context);
                              await AuthService().logout();
                              removeProgressCircle(context);
                              Navigator.pushReplacementNamed(context, '/Login');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, profile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 64),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.primaryColor, Color.fromARGB(255, 50, 93, 194)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      CustomBottomSheet.show(
                        context,
                        ProfileEditScreen(vm: profileViewModel),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.white,
              backgroundImage: profile.photoUrl.isNotEmpty
                  ? NetworkImage(profile.photoUrl)
                  : null,
              child: profile.photoUrl.isEmpty
                  ? Text(
                      profile.name.isNotEmpty
                          ? profile.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E3A8A),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            Text(
              profile.name.isEmpty ? 'No name set' : profile.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              profile.email,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: '${profile.roomList.length}',
              label: 'Groups',
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              value: '${profile.notificationList.length}',
              label: 'Alerts',
            ),
          ),
          _StatDivider(),
          Expanded(
            child: _StatItem(
              value: '${profile.dataSharing.length}',
              label: 'Shared',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: Colors.black12);
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.iconColor,
    this.showChevron = true,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Color? iconColor;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: (iconColor ?? Palette.primaryColor).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Palette.primaryColor,
              size: 19,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
          trailing: showChevron
              ? const Icon(Icons.chevron_right, color: Colors.black26, size: 20)
              : null,
        ),
      ),
    );
  }
}
