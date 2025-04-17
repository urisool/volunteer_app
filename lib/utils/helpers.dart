// ignore: depend_on_referenced_packages
import 'package:volunteer_app/utils/constants.dart';

class AppHelpers {
  // تنسيق التاريخ
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(date);
  }

  // تقصير النص مع إضافة ...
  static String truncateText(String text, {int maxLength = 30}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // تحويل الدقائق إلى تنسيق ساعة:دقيقة
  static String minutesToTime(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  // معالجة الأخطاء
  static String getErrorMessage(dynamic error) {
    if (error is String) return error;
    return AppConstants.defaultErrorMessage;
  }
}

class DateFormat {
  final String pattern;

  // Constructor for the DateFormat class
  DateFormat(this.pattern);

  // Implement the format method to return a valid string
  String format(DateTime date) {
    // You can implement a simple date formatting here or use a package like intl.
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} – ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
