// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/dimen.dart';
import 'package:meepay_app/view/main/main_view.dart';

dialogBuilderSucess(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: ColorMP.ColorBackground,
        surfaceTintColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          Icons.check_circle,
          color: ColorMP.ColorSuccess,
          size: 70,
        ),
        content: message != ""
            ? Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              )
            : SizedBox.shrink(),
        actions: <Widget>[
          InkWell(
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainView()),
                  (Route<dynamic> route) => false)
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                  color: ColorMP.ColorSuccess,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimen.radiusBorder)),
                  border: Border.all(color: ColorMP.ColorSuccess, width: 1)),
              child: Text(
                "Đồng ý",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      );
    },
  );
}
