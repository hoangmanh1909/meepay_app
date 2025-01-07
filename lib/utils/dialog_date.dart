import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:meepay_app/utils/color_mp.dart';

dialogDate(BuildContext context) {
  // ignore: no_leading_underscores_for_local_identifiers
  List<DateTime> _dates = [];
  // show the dialog
  return showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
        daySplashColor: Colors.white,
        calendarType: CalendarDatePicker2Type.range,
        okButton: const Text(
          "Đồng ý",
          style: TextStyle(
              color: ColorMP.ColorSuccess, fontWeight: FontWeight.w600),
        ),
        cancelButton: const Text(
          "Hủy",
          style: TextStyle(
              color: ColorMP.ColorAccent, fontWeight: FontWeight.w600),
        )),
    dialogSize: const Size(325, 400),
    value: _dates,
    borderRadius: BorderRadius.circular(15),
  );
}
