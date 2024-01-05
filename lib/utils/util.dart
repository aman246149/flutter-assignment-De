import 'package:intl/intl.dart';

String formattedCurrency(num data) =>
    NumberFormat.currency(symbol: "\$").format(data);
