/// The stored tag is 8 characters with no symbols, e.g. "7F3KQ9P2".
/// It is shown to people as "ENK-7F3K-Q9P2", which is easier to read and
/// to say aloud. The prefix and dashes exist only for display and for
/// typing; they are never stored in Firestore.
class PlayerTag {
  PlayerTag._();

  /// Change this if you want a different prefix on the displayed ID.
  static const String prefix = 'ENK';

  static const int length = 8;

  /// "7F3KQ9P2" -> "ENK-7F3K-Q9P2". Returns "—" while the tag is not
  /// assigned yet (the Cloud Function writes it just after signup).
  static String format(String tag) {
    if (tag.isEmpty) return '—';
    if (tag.length != length) return tag;
    return '$prefix-${tag.substring(0, 4)}-${tag.substring(4)}';
  }

  /// Accepts "ENK-7F3K-Q9P2", "#7F3KQ9P2", "7f3k q9p2" and similar,
  /// and returns the stored form "7F3KQ9P2".
  static String normalize(String input) {
    var s = input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (s.length == length + prefix.length && s.startsWith(prefix)) {
      s = s.substring(prefix.length);
    }
    return s;
  }
}
