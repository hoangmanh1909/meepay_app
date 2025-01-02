// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meepay_app/controller/user_controller.dart';
import 'package:meepay_app/models/request/login_request.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/models/response/token_response.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
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

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  login() async {
    mobileNumber.text = "0936062990";
    password.text = "1";
    if (mobileNumber.text == "") {
      showMessage("Vui lòng nhập số điện thoại", "99", 3);
      return;
    }

    if (password.text == "") {
      showMessage("Vui lòng nhập mật khẩu", "99", 3);
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
                          ),
                          SizedBox(height: size.height * 0.03),
                          TextFormField(
                            obscureText: _showPassword,
                            controller: password,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
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
                                  color: const Color.fromARGB(255, 80, 44, 44),
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
                          ),
                          SizedBox(height: size.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             RegisterView(type: 2)));
                              },
                              child: Text(
                                "Quên mật khẩu?",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
                              ),
                            ),
                          ),
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
}
