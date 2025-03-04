import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meepay_app/controller/user_controller.dart';
import 'package:meepay_app/models/request/change_password.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:meepay_app/view/account/otp_mp_view.dart';

bottomSheetMissPassword(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      final TextEditingController accMobileMiss = TextEditingController();
      double initc = 0.3;
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        initc = 0.45;
      }
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: DraggableScrollableSheet(
              initialChildSize: initc,
              snap: true,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Quên mật khẩu",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      textLabelRequired("Số điện thoại"),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: accMobileMiss,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Nhập số điện thoại",
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                          onTap: () async {
                            if (accMobileMiss.text.isEmpty) {
                              showMessage(
                                  "Vui lòng nhập số điện thoại", "01", 5);
                              return;
                            } else {
                              if (accMobileMiss.text.length != 10) {
                                showMessage(
                                    "Số điện thoại không hợp lệ", "01", 5);
                                return;
                              }
                              UserController user = UserController();
                              ChangePasswordRequest req =
                                  ChangePasswordRequest();
                              req.phoneNumber = accMobileMiss.text;
                              if (context.mounted) showProcess(context);
                              ResponseObject res = await user.missPassword(req);
                              if (context.mounted) Navigator.pop(context);
                              if (res.code == "00") {
                                if (context.mounted) {
                                  int expiresIn =
                                      jsonDecode(res.data!)["ExpiresIn"];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OTPMpView(
                                                phoneNumber: accMobileMiss.text,
                                                secondCountdown: expiresIn,
                                              )));
                                }
                              } else {
                                if (context.mounted) {
                                  showMessage(res.message!, "01", 10);
                                }
                              }
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: ColorMP.ColorAccent,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: ColorMP.ColorAccent)),
                              child: const Text("Quên mật khẩu",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600))))
                    ],
                  ),
                );
              }));
    },
  );
}
