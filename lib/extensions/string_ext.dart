import 'package:table_calendar/table_calendar.dart';

extension StringExtension on String {
  bool get checkIsVietNam {
    List<String> days = [
      'Thứ hai',
      'Thứ ba',
      'Thứ tư',
      'Thứ năm',
      'Thứ sáu',
      'Thứ bảy',
      'Chủ nhật',
    ];
    if (days.contains(this)) {
      return true;
    }
    return false;
  }

  String get convertVietNam {
    switch (this) {
      case 'Monday':
        return 'Thứ hai';

      case 'Tuesday':
        return 'Thứ ba';

      case 'Wednesday':
        return 'Thứ tư';

      case 'Thursday':
        return 'Thứ năm';

      case 'Friday':
        return 'Thứ sáu';

      case 'Saturday':
        return 'Thứ bảy';

      default:
        return 'Chủ nhật';
    }
  }

  String get convertEnglish {
    switch (this) {
      case 'Thứ hai':
        return 'Monday';

      case 'Thứ ba':
        return 'Tuesday';

      case 'Thứ tư':
        return 'Wednesday';

      case 'Thứ năm':
        return 'Thursday';

      case 'Thứ sáu':
        return 'Friday';

      case 'Thứ bảy':
        return 'Saturday';

      default:
        return 'Sunday';
    }
  }

  StartingDayOfWeek get getStartingDayOfWeek {
    switch (this) {
      case 'Monday':
        return StartingDayOfWeek.monday;
      case 'Thứ hai':
        return StartingDayOfWeek.monday;
      case 'Tuesday':
        return StartingDayOfWeek.tuesday;
      case 'Thứ ba':
        return StartingDayOfWeek.tuesday;
      case 'Wednesday':
        return StartingDayOfWeek.wednesday;
      case 'Thứ tư':
        return StartingDayOfWeek.wednesday;
      case 'Thursday':
        return StartingDayOfWeek.thursday;
      case 'Thứ năm':
        return StartingDayOfWeek.thursday;
      case 'Friday':
        return StartingDayOfWeek.friday;
      case 'Thứ sáu':
        return StartingDayOfWeek.friday;
      case 'Saturday':
        return StartingDayOfWeek.saturday;
      case 'Thứ bảy':
        return StartingDayOfWeek.saturday;
      case 'Sunday':
        return StartingDayOfWeek.sunday;
      default:
        return StartingDayOfWeek.sunday;
    }
  }
}
