// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meepay_app/controller/user_controller.dart';
import 'package:meepay_app/models/request/login_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/models/response/token_response.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/dimen.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:meepay_app/view/main/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserController con = UserController();
  final TextEditingController name = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordAgain = TextEditingController();

  bool _showPassword = true;
  bool _showPassword1 = true;

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mobileNumber.text = "0936062990";
    password.text = "123456aA@";
    prefs = await SharedPreferences.getInstance();
  }

  register() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    LoginRequest loginRequest = LoginRequest();
    loginRequest.password = password.text;
    loginRequest.phoneNumber = mobileNumber.text;
    if (mounted) showProcess(context);

    ResponseObject res = await con.login(loginRequest);
    if (context.mounted) Navigator.pop(context);
    if (res.code == "00") {
      UserProfile userProfile = UserProfile.fromJson(jsonDecode(res.data!));

      String user = jsonEncode(userProfile);
      prefs!.setString('user', user);
      TokenResponse token = TokenResponse.fromJson(jsonDecode(res.token!));
      prefs!.setString('accessToken', token.accessToken!);
      prefs!.setString('mobileNumber', userProfile.phoneNumber ?? "");
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MainView()),
            (Route<dynamic> route) => false);
      }
    } else {
      if (context.mounted) showMessage(res.message!, "99", 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorMP.ColorBackground,
      appBar: AppBar(
        backgroundColor: ColorMP.ColorPrimary,
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        title: const Text("Đăng ký"),
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
                  controller: name,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Tên Doanh nghiệp/Hộ KD *",
                    labelText: "Tên Doanh nghiệp/Hộ KD *",
                    counterText: "",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Tên Doanh nghiệp/Hộ KD";
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: mobileNumber,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Số điện thoại *",
                    labelText: "Số điện thoại *",
                    counterText: "",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Vui lòng nhập số điện thoại";
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _showPassword,
                  controller: password,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                      child: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: ColorMP.ColorAccent,
                      ),
                    ),
                    labelText: "Mật khẩu",
                    hintText: "Mật khẩu",
                    counterText: "",
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: _showPassword1,
                  controller: password,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
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
                    labelText: "Nhập lại mật khẩu",
                    hintText: "Nhập lại mật khẩu",
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
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorMP.ColorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12)),
                        child: const Text(
                          "Đăng ký",
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
      ),
    );
  }

  Widget buidRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Bạn chưa có tài khoản?"),
        SizedBox(
          width: 4,
        ),
        InkWell(
          onTap: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => RegisterView()));
          },
          child: Text(
            "Đăng ký",
            style: TextStyle(color: ColorMP.ColorPrimary),
          ),
        )
      ],
    );
  }
}
