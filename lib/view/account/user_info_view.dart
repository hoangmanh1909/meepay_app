// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/view/account/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  SharedPreferences? prefs;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      initPref();
    });
  }

  initPref() async {
    prefs = await SharedPreferences.getInstance();
    String? userMap = prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        userProfile = UserProfile.fromJson(jsonDecode(userMap));
      });
    }
  }

  logout() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    if (context.mounted) {
      sharedUser.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
        (Route<dynamic> route) => false,
      );
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
          title: const Text("Thông tin tài khoản"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Scaffold(
          backgroundColor: ColorMP.ColorBackground,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [boxShadow()],
                ),
                child: buildUser(),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                    height: 40,
                    width: size.width - 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [boxShadow()]),
                    child: Text("Đổi mật khẩu",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600))),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: logout,
                child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: size.width - 16,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [boxShadow()]),
                    child: Text(
                      "Đăng xuất",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    )),
              ),
            ],
          ),
        ));
  }

  Widget buildUser() {
    if (userProfile != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Ionicons.person_outline,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [textLabel("Tên"), textValue(userProfile!.name!)],
              )
            ],
          ),
          Divider(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Ionicons.call_outline,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textLabel("Số điện thoại"),
                  textValue(userProfile!.phoneNumber!)
                ],
              )
            ],
          ),
          Divider(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Ionicons.mail_outline,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [textLabel("Email"), textValue(userProfile!.email!)],
              )
            ],
          )
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
