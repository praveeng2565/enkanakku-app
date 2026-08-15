import 'package:flutter/material.dart';

import '../../utils/base_page.dart';
import '../../widgets/custom_button.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BasePage(
        title: 'Groups',
        showNotifications: true,
        floatingActionButton: CustomButton(
          inputText: 'CREATE GROUP',
          onTap: () {
            Navigator.pushNamed(context, '/CreateGroup');
          },
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: _GroupTile(
                      name: 'Test',
                      status: 'Pending',
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.name,
    required this.status,
    required this.onTap,
  });

  final String name;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 41,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE5E0E2), width: 0.8),
          ),
          child: Row(
            children: [
              // Group icon
              Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEBE5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 14,
                  color: Color(0xFF94B2A7),
                ),
              ),

              const SizedBox(width: 9),

              // Group name
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF303030),
                  ),
                ),
              ),

              // Status
              Text(
                status,
                style: TextStyle(
                  fontSize: 8,
                  color: status == 'settled up'
                      ? const Color(0xFFB0B0B0)
                      : const Color(0xFFD06B5F),
                ),
              ),

              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
