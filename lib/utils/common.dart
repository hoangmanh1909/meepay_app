import 'package:intl/intl.dart' as intl;

String formatAmount(dynamic amount) {
  if (amount != null) {
    return "${intl.NumberFormat.decimalPattern().format(amount)}đ";
  } else {
    return "0đ";
  }
}

String formatNumber(dynamic amount) {
  if (amount != null) {
    return intl.NumberFormat.decimalPattern().format(amount);
  } else {
    return "";
  }
}
