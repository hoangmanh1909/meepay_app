// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meepay_app/controller/user_controller.dart';
import 'package:meepay_app/models/request/dialog_notify_sucess.dart';
import 'package:meepay_app/models/request/login_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/models/response/token_response.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/bottom_sheet_miss_password.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/dialog_confirm.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:meepay_app/view/account/otp_view.dart';
import 'package:meepay_app/view/account/register_view.dart';
import 'package:meepay_app/view/main/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserController con = UserController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _showPassword = true;
  UserProfile? userProfile;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    String? userMap = prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        userProfile = UserProfile.fromJson(jsonDecode(userMap));
        mobileNumber.text = userProfile!.phoneNumber!;
      });
    }
  }

  login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    LoginRequest loginRequest = LoginRequest();
    loginRequest.password = password.text;
    loginRequest.phoneNumber = mobileNumber.text;
    if (mounted) showProcess(context);

    ResponseObject res = await con.login(loginRequest);
    if (mounted) Navigator.pop(context);
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
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: Stack(children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(height: size.height * 0.08),
                          Center(
                            child: Image(
                              image: const AssetImage('assets/img/logo.png'),
                              width: 200,
                              height: 100,
                            ),
                          ),
                          SizedBox(height: size.height * 0.06),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: mobileNumber,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Số điện thoại",
                              labelText: "Số điện thoại",
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: _showPassword,
                            controller: password,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(
                                      () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                          SizedBox(height: size.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorMP.ColorPrimary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 12)),
                                  child: const Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                bottomSheetMissPassword(context);
                              },
                              child: Text(
                                "Quên mật khẩu?",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buidRegister()
                          // spinkit
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterView()));
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
