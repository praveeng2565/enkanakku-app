import 'constants.dart';

class AppException implements Exception {
  AppException([
    this.message = AppConstants.emptyString,
    this.prefix,
    this.url,
  ]);
  final String message;
  final String? prefix;
  final String? url;
  @override
  String toString() {
    return '$prefix$message';
  }
}

class ConcurrentEditException implements Exception {
  ConcurrentEditException([
    this.message =
        'This expense was updated by someone else. Please refresh and try again.',
  ]);
  final String message;
}

class ExpenseNotFoundException implements Exception {
  ExpenseNotFoundException([this.message = 'This expense no longer exists.']);
  final String message;
}
