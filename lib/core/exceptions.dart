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
