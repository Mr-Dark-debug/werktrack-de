import 'package:intl/intl.dart';

/// Decimal user input to integer cents; no floating-point conversion.
int? parseEuroCents(String input) {
  final value = input.trim().replaceAll(',', '.');
  if (!RegExp(r'^\d+(?:\.\d{1,2})?$').hasMatch(value)) return null;
  final parts = value.split('.');
  final euros = int.tryParse(parts.first);
  if (euros == null || euros > 999999999) return null;
  final cents = parts.length == 1 ? 0 : int.parse(parts[1].padRight(2, '0'));
  return euros * 100 + cents;
}

String formatMoney(int cents, {String locale = 'en'}) =>
    NumberFormat.currency(locale: locale, symbol: '€').format(cents / 100);

String formatDuration(Duration duration) {
  final hours = duration.inMinutes ~/ 60;
  final minutes = duration.inMinutes.remainder(60);
  return minutes == 0 ? '${hours}h' : '${hours}h ${minutes}m';
}

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
