import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:meepay_app/utils/dimen.dart';

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

Widget textLabel(String mes) {
  return Text(
    mes,
    style: const TextStyle(fontSize: Dimen.fontSizeLable),
  );
}

Widget textLabelRequired(String mes) {
  return Row(
    children: [
      Text(
        mes,
        style: const TextStyle(fontSize: Dimen.fontSizeLable),
      ),
      const SizedBox(
        width: 4,
      ),
      const Text(
        "*",
        style: TextStyle(fontSize: Dimen.fontSizeLable, color: Colors.red),
      )
    ],
  );
}

Widget textValue(String mes) {
  return Text(
    mes,
    style: const TextStyle(
        fontSize: Dimen.fontSizeValue, fontWeight: FontWeight.w600),
  );
}
