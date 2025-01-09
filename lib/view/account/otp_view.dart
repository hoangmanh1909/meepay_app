// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';

class OTPView extends StatefulWidget {
  const OTPView({Key? key}) : super(key: key);

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorMP.ColorBackground,
        appBar: AppBar(
          backgroundColor: ColorMP.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text("Mã xác nhận"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [boxShadow()],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Vui lòng nhập mã xác nhận được ngân hàng gửi về số điện thoại của bạn",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                OtpTextField(
                    autoFocus: true,
                    numberOfFields: 8,
                    cursorColor: ColorMP.ColorAccent,
                    focusedBorderColor: ColorMP.ColorAccent,
                    showFieldAsBox: false,
                    borderWidth: 4.0,
                    textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here if necessary
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {}),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: () {},
                    child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: ColorMP.ColorAccent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ColorMP.ColorAccent)),
                        child: Text("Xác nhận",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))))
              ],
            )));
  }
}
