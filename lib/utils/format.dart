import 'package:intl/intl.dart';

String formatRupiah(num value) {
  final f = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return f.format(value);
}
