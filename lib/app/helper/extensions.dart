import '../utils/strings_manager.dart';

extension StringCasingExtension on String {
  String _toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str._toCapitalized())
      .join(' ');
}
extension DateConversion on DateTime {
  String toHourMark() {
    int hour = this.hour;
    if (hour > 12) {
      return AppStrings.goodNight;
    } else if (hour > 24) {
      return AppStrings.goodMorning;
    } else {
      return AppStrings.goodMorning;
    }
  }
}
