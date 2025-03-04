// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meepay_app/controller/user_controller.dart';
import 'package:meepay_app/models/request/change_password.dart';
import 'package:meepay_app/models/request/dialog_login.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/dimen.dart';

class AddpasswordView extends StatefulWidget {
  const AddpasswordView({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;
  @override
  State<AddpasswordView> createState() => _AddpasswordViewState();
}

class _AddpasswordViewState extends State<AddpasswordView> {
  final UserController con = UserController();

  bool _showPassword1 = true;
  final TextEditingController passwordAgain = TextEditingController();
  final TextEditingController passwordNew = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onOk() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (passwordNew.text != passwordAgain.text) {
      showMessage("Mật khẩu mới không khớp", "99", 3);
      return;
    }
    ChangePasswordRequest req = ChangePasswordRequest();
    req.password = passwordNew.text;
    req.phoneNumber = widget.phoneNumber;
    if (mounted) showProcess(context);

    ResponseObject res = await con.addPassword(req);
    if (mounted) Navigator.pop(context);
    if (res.code == "00") {
      if (mounted) {
        dialogBuilderLogin(context, "Đổi mật khẩu thành công",
            "Bạn cần đăng nhập để tiếp tục sử dụng dịch vụ");
      }
    } else {
      showMessage(res.message!, "01", 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorMP.ColorPrimary,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          title: const Text('Đổi mật khẩu'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Form(
          key: formKey,
          child: Container(
            margin: EdgeInsets.all(Dimen.marginDefault),
            padding: EdgeInsets.all(Dimen.padingDefault),
            decoration: decorationMP(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: _showPassword1,
                    controller: passwordNew,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() => _showPassword1 = !_showPassword1);
                        },
                        child: Icon(
                          _showPassword1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: ColorMP.ColorAccent,
                        ),
                      ),
                      labelText: "Mật khẩu mới*",
                      hintText: "Mật khẩu mới*",
                      counterText: "",
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Vui lòng nhập mật khẩu mới";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: _showPassword1,
                    controller: passwordAgain,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() => _showPassword1 = !_showPassword1);
                        },
                        child: Icon(
                          _showPassword1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: ColorMP.ColorAccent,
                        ),
                      ),
                      labelText: "Nhập lại mật khẩu mới*",
                      hintText: "Nhập lại mật khẩu mới*",
                      counterText: "",
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Vui lòng nhập lại mật khẩu";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onOk,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorMP.ColorPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12)),
                          child: const Text(
                            "Cập nhật",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // spinkit
                ],
              ),
            ),
          ),
        ));
  }
}
