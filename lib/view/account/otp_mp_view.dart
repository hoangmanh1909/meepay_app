// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:meepay_app/controller/account_controller.dart';
import 'package:meepay_app/controller/user_controller.dart';
import 'package:meepay_app/models/request/change_password.dart';
import 'package:meepay_app/models/request/verify_otp_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:meepay_app/view/account/add_password.dart';

class OTPMpView extends StatefulWidget {
  const OTPMpView({
    Key? key,
    required this.phoneNumber,
    required this.secondCountdown,
  }) : super(key: key);

  final String phoneNumber;
  final int secondCountdown;
  @override
  State<OTPMpView> createState() => _OTPMpViewState();
}

class _OTPMpViewState extends State<OTPMpView> {
  UserController conAcc = UserController();
  String otp = "";
  int secondCountdown = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    secondCountdown = widget.secondCountdown;
    startTimer();
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  verifyOTP() async {
    if (otp.isNotEmpty) {
      if (otp.length == 6) {
        VerifyOTPRequest req = VerifyOTPRequest();
        req.phoneNumber = widget.phoneNumber;
        req.otp = otp;
        if (mounted) showProcess(context);
        ResponseObject res = await conAcc.verifyOTP(req);
        if (mounted) Navigator.pop(context);
        if (res.code == "00") {
          if (mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddpasswordView(
                          phoneNumber: widget.phoneNumber,
                        )));
          }
        } else {
          if (mounted) {
            showMessage(res.message!, "99", 5);
          }
        }
      } else {
        showMessage("Mã xác nhận không hợp lệ", "99", 4);
      }
    } else {
      showMessage("Vui lòng nhập mã xác nhận", "99", 4);
    }
  }

  String padLeftTwo(int n) => n.toString().padLeft(2, '0');
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
                  "Vui lòng nhập mã xác nhận được gửi về số điện thoại ${widget.phoneNumber} của bạn",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 30,
                ),
                OtpTextField(
                    autoFocus: true,
                    numberOfFields: 6,
                    cursorColor: ColorMP.ColorAccent,
                    focusedBorderColor: ColorMP.ColorAccent,
                    showFieldAsBox: false,
                    borderWidth: 4.0,
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here if necessary
                      otp = "";
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      otp = verificationCode;
                    }),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Không nhận được mã OTP? "),
                    countDown(),
                  ],
                ),
                InkWell(
                    onTap: verifyOTP,
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

  startTimer() {
    Duration oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (secondCountdown == 0) {
        } else {
          setState(() {
            secondCountdown--;
          });
        }
      },
    );
  }

  Widget countDown() {
    if (secondCountdown > 0) {
      Duration duration = Duration(seconds: secondCountdown);
      return Text(
        "Gửi lại sau ${padLeftTwo(duration.inMinutes.remainder(60))}:${padLeftTwo(duration.inSeconds.remainder(60))}",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
      );
    } else {
      return InkWell(
          onTap: () async {
            UserController user = UserController();
            ChangePasswordRequest req = ChangePasswordRequest();
            req.phoneNumber = widget.phoneNumber;
            if (mounted) showProcess(context);
            ResponseObject res = await user.missPassword(req);
            if (mounted) Navigator.of(context).pop();
            if (res.code == "00") {
              int expiresIn = jsonDecode(res.data!)["ExpiresIn"];
              setState(() {
                secondCountdown = expiresIn;
              });
            } else {
              showMessage(res.message!, "01", 10);
            }
          },
          child: Text(" Gửi lại",
              style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.w700)));
    }
  }
}
