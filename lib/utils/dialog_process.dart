// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meepay_app/utils/color_mp.dart';

showProcess(BuildContext context) {
  final spinkit = SpinKitPouringHourGlassRefined(color: ColorMP.ColorPrimary);

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return spinkit;
    },
  );
}
