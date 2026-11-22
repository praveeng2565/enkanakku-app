/// Formats paise as rupees with Indian digit grouping.
/// 123456700 -> ₹12,34,567     150 -> ₹1.50     -5000 -> -₹50
String formatPaise(int paise) {
  final negative = paise < 0;
  final abs = paise.abs();
  final rupees = abs ~/ 100;
  final fraction = abs % 100;

  var digits = rupees.toString();
  if (digits.length > 3) {
    final lastThree = digits.substring(digits.length - 3);
    var rest = digits.substring(0, digits.length - 3);
    final groups = <String>[];
    while (rest.length > 2) {
      groups.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) groups.insert(0, rest);
    digits = '${groups.join(',')},$lastThree';
  }

  final decimals = fraction == 0
      ? ''
      : '.${fraction.toString().padLeft(2, '0')}';
  return '${negative ? '-' : ''}₹$digits$decimals';
}
