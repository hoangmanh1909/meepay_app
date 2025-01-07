import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:meepay_app/controller/account_controller.dart';
import 'package:meepay_app/models/request/account_search_request.dart';
import 'package:meepay_app/models/request/change_link_request.dart';
import 'package:meepay_app/models/response/account_search_response.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:meepay_app/view/account/add_link_view.dart';
import 'package:meepay_app/view/account/user_info_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopView extends StatefulWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  final AccountController con = AccountController();
  SharedPreferences? prefs;
  UserProfile? userProfile;
  List<AccountSearchResponse> accounts = [];

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
      accountSearch();
    }
  }

  accountSearch() async {
    AccountSearchRequest req = AccountSearchRequest();
    req.merchantID = userProfile!.merchantID;
    req.shopID = userProfile!.shopID;

    if (mounted) showProcess(context);
    ResponseObject res = await con.search(req);
    if (res.code == "00") {
      setState(() {
        accounts = List<AccountSearchResponse>.from((jsonDecode(res.data!)
            .map((model) => AccountSearchResponse.fromJson(model))));
      });
      AccountSearchResponse item = accounts[0];
      if (item.device!.isLink == "N") {
        isNotify = false;
      }
    } else {
      showMessage(res.message!, "99", 4);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  changeLink(int deviceID, String isLink, bool value) async {
    ChangeLinkRequest req = ChangeLinkRequest();
    req.deviceID = deviceID;
    req.isLink = isLink;

    if (mounted) showProcess(context);
    ResponseObject res = await con.changeLink(req);
    if (res.code == "00") {
      setState(() {
        isNotify = value;
      });
    } else {
      showMessage(res.message!, "99", 4);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: ColorMP.ColorPrimary,
            automaticallyImplyLeading: false,
            centerTitle: true,
            titleTextStyle: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            title: const Text("Tài khoản liên kết"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Ionicons.person_circle_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserView()));
                  });
                },
              )
            ]),
        body: Column(
          children: [buildAccount(), buildLink()],
        ));
  }

  bool isNotify = true;
  Widget buildAccount() {
    if (accounts.isNotEmpty) {
      AccountSearchResponse item = accounts[0];

      return Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [boxShadow()],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_outlined,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    textLabel("Ngân hàng"),
                  ],
                ),
                textValue(item.bankName!)
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Ionicons.card_outline,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    textLabel("Số tài khoản"),
                  ],
                ),
                textValue(item.accoumtNumber!)
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Ionicons.person_outline,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    textLabel("Chủ tài khoản"),
                  ],
                ),
                textValue(item.name!)
              ],
            ),
            const Divider(
              height: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Ionicons.megaphone_outline,
                      size: 20,
                      color: ColorMP.ColorAccent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    textLabel("Nhận thông báo"),
                  ],
                ),
                Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Icon(Icons.check);
                      }
                      return const Icon(Icons.close);
                    },
                  ),
                  value: isNotify,
                  activeColor: ColorMP.ColorAccent,
                  onChanged: (bool value) {
                    String isLink = "Y";
                    if (!value) isLink = "N";
                    changeLink(item.device!.iD!, isLink, value);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildLink() {
    return InkWell(
      onTap: () {
        Future.delayed(Duration.zero, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddLinkView()));
        });
      },
      child: Container(
          alignment: Alignment.center,
          height: 40,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorMP.ColorAccent)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Ionicons.add_outline,
                color: ColorMP.ColorAccent,
              ),
              Text("Thêm liên kết ngân hàng",
                  style: TextStyle(
                      color: ColorMP.ColorAccent, fontWeight: FontWeight.w600))
            ],
          )),
    );
  }
}
