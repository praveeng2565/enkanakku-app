import 'package:enkanakku_app/utils/app_constants.dart';

String getNewID() {
  final date = DateTime.now();
  return date.year.toString() +
      date.month.toString() +
      date.day.toString() +
      AppConstants.hash +
      date.hour.toString() +
      date.minute.toString() +
      date.second.toString();
}
