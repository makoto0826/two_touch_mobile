import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  DateTime toYmd() {
    final date = DateTime.parse(this.toString());
    final formatDate = DateFormat('yyyy-MM-dd').format(date);
    
    return DateTime.parse(formatDate);
  }
}
