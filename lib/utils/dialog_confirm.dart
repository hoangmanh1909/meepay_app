// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/dimen.dart';

dialogConfirm(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: ColorMP.ColorBackground,
        surfaceTintColor: Colors.transparent,
        // titlePadding: EdgeInsets.all(10),
        // contentPadding: EdgeInsets.all(10),
        // actionsPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: message != ""
            ? Text(
                message,
                textAlign: TextAlign.center,
              )
            : SizedBox.shrink(),
        actions: <Widget>[
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => {Navigator.of(context).pop(false)},
                  child: Container(
                    alignment: Alignment.center,
                    height: Dimen.buttonHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Dimen.radiusBorderButton)),
                        border: Border.all(color: Colors.red, width: 1)),
                    child: Text(
                      "Đóng",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: InkWell(
                onTap: () => {Navigator.of(context).pop(true)},
                child: Container(
                  alignment: Alignment.center,
                  height: Dimen.buttonHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Dimen.radiusBorderButton)),
                      border:
                          Border.all(color: ColorMP.ColorSuccess, width: 1)),
                  child: Text(
                    "Đồng ý",
                    style: TextStyle(color: ColorMP.ColorSuccess),
                  ),
                ),
              ))
            ],
          )
        ],
      );
    },
  );
}
