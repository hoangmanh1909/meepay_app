// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:meepay_app/controller/account_controller.dart';
import 'package:meepay_app/models/request/dialog_notify_sucess.dart';
import 'package:meepay_app/models/request/verify_otp_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';

class OTPView extends StatefulWidget {
  const OTPView({Key? key, this.code}) : super(key: key);

  final String? code;
  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  AccountController conAcc = AccountController();
  String otp = "";
  verifyOTP() async {
    if (otp.isNotEmpty) {
      if (otp.length == 6) {
        VerifyOTPRequest req = VerifyOTPRequest();
        req.code = widget.code;
        req.oTP = otp;
        if (mounted) showProcess(context);
        ResponseObject res = await conAcc.verifyOtp(req);
        if (context.mounted) Navigator.pop(context);
        if (res.code == "00") {
          if (mounted) {
            dialogBuilderSucess(
                context, "Thông báo", "Thêm mới liên kết tài khoản thành công");
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
}
