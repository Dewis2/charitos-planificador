import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static final _storage = DateFormat('yyyy-MM-dd');
  static final _display = DateFormat('dd/MM/yyyy');

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
  static String toStorage(DateTime value) => _storage.format(value);
  static String toDisplay(DateTime value) => _display.format(value);
  static DateTime parse(String value) => _storage.parseStrict(value);
  static DateTime? tryParse(String value) {
    try {
      return parse(value.trim());
    } catch (_) {
      return null;
    }
  }
}
