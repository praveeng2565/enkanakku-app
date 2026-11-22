import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/user_session.dart';
import 'room_view_model.dart';

class RoomCreateScreen extends StatefulWidget {
  const RoomCreateScreen({super.key});

  @override
  State<RoomCreateScreen> createState() => _RoomCreateScreenState();
}

class _RoomCreateScreenState extends State<RoomCreateScreen> {
  static const _emojis = [
    '🏖️',
    '🏠',
    '🍕',
    '🚗',
    '✈️',
    '🎉',
    '🛒',
    '💼',
    '🎬',
    '⚽',
    '☕',
    '🎓',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _emoji = _emojis.first;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    // final uid = context.read<AuthViewModel>().uid;
    // if (uid == null) {
    //   SnackbarService.show('Please sign in again', isError: true);
    //   return;
    // }

    final roomId = await context.read<RoomViewModel>().createRoom(
      uid: UserSession.instance.uniqueId,
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      emoji: _emoji,
    );

    if (roomId != null && mounted) {
      // Replace this screen so Back returns to the list, not to the form.
      Navigator.pushReplacementNamed(
        context,
        '/RoomDetailScreen',
        arguments: {'roomId': roomId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCreating = context.watch<RoomViewModel>().isCreating;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Group',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildPreview(scheme),
            const SizedBox(height: 24),
            Text('Pick an icon', style: _labelStyle(scheme)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _emojis
                  .map((e) => _buildEmojiChoice(e, scheme))
                  .toList(),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameCtrl,
              maxLength: 30,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
              decoration: _decoration('Group name', 'e.g. Goa Trip'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Give your group a name'
                  : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLength: 60,
              onChanged: (_) => setState(() {}),
              decoration: _decoration(
                'Description (optional)',
                'What is this group for?',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: isCreating ? null : _create,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Create Group',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle(ColorScheme scheme) => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: scheme.onSurfaceVariant,
  );

  InputDecoration _decoration(String label, String hint) => InputDecoration(
    labelText: label,
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  );

  /// Live preview, styled like a card on the Groups list.
  Widget _buildPreview(ColorScheme scheme) {
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(_emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Group name' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: name.isEmpty ? scheme.outline : scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc.isEmpty ? 'Add a short description' : desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1 member',
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiChoice(String emoji, ColorScheme scheme) {
    final selected = emoji == _emoji;
    return GestureDetector(
      onTap: () => setState(() => _emoji = emoji),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? scheme.primaryContainer
              : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
