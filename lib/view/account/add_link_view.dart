// ignore_for_file: prefer_const_constructors, unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:meepay_app/controller/account_controller.dart';
import 'package:meepay_app/controller/dictionary_controller.dart';
import 'package:meepay_app/models/request/account_add_request.dart';
import 'package:meepay_app/models/response/dictionary_response.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/dialog_widget_bank.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:meepay_app/view/account/otp_view.dart';
import 'package:meepay_app/view/account/rule_view.dart';
import 'package:meepay_app/view/main/scanqr_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLinkView extends StatefulWidget {
  const AddLinkView({Key? key}) : super(key: key);

  @override
  State<AddLinkView> createState() => _AddLinkViewState();
}

class _AddLinkViewState extends State<AddLinkView> {
  final DictionaryController con = DictionaryController();
  final AccountController conAcc = AccountController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _accMobile = TextEditingController();
  final TextEditingController _accNumber = TextEditingController();
  final TextEditingController _accNameNumber = TextEditingController();
  final TextEditingController _accPIDNumber = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _serial = TextEditingController();
  final TextEditingController _accVirtual = TextEditingController();

  SharedPreferences? prefs;
  UserProfile? userProfile;
  DictionaryResponse? selectedBank;
  List<DictionaryResponse>? bankModels;
  bool isChecked = false;
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
        _accMobile.text = userProfile!.phoneNumber!;
      });
      getBank();
    }
  }

  getBank() async {
    if (mounted) showProcess(context);

    ResponseObject res = await con.getBank();
    if (res.code == "00") {
      List<DictionaryResponse> b = List<DictionaryResponse>.from(
          (jsonDecode(res.data!)
              .map((model) => DictionaryResponse.fromJson(model))));
      setState(() {
        bankModels = b.where((test) => test.iD == 1).toList();
      });
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  addLink() async {
    if (selectedBank == null) {
      showMessage("Vui lòng chọn ngân hàng", "99", 3);
      return;
    }
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!isChecked) {
      showMessage("Bạn chưa đồng ý điều kiện và điều khoản", "99", 3);
      return;
    }
    AccountAddNewRequest req = AccountAddNewRequest();
    req.accountNumber = _accNumber.text;
    req.bankID = selectedBank!.iD;
    req.merchantID = userProfile!.merchantID;
    req.email = _email.text;
    req.mobileNumber = _accMobile.text;
    req.name = _accNameNumber.text;
    req.pIDNumber = _accPIDNumber.text;
    req.serial = _serial.text;
    req.va = _accVirtual.text;
    if (mounted) showProcess(context);

    ResponseObject res = await conAcc.addLink(req);
    if (mounted) Navigator.pop(context);
    if (res.code == "00") {
      if (mounted) {
        final v = jsonDecode(res.data!);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => OTPView(
                    code: v["Code"],
                    bankID: selectedBank!.iD!,
                  )),
        );
        // dialogBuilderSucess(
        // context, "Thông báo", "Thêm mới liên kết tài khoản thành công");
      }
    } else {
      if (mounted) {
        showMessage(res.message!, "99", 5);
      }
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
          title: const Text("Liên kết tài khoản"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [boxShadow()],
                      ),
                      child: buildAccount(),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8, left: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [boxShadow()],
                      ),
                      child: buildDevice(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              Flexible(
                                  child: Text(
                                "Đồng ý với ",
                                textAlign: TextAlign.left,
                                softWrap: true,
                              )),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RuleView()));
                                },
                                child: Text(
                                  "Điều kiện và điều khoản",
                                  softWrap: true,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: addLink,
                        child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: ColorMP.ColorAccent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: ColorMP.ColorAccent)),
                            child: Text("Cập nhật",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600))))
                  ],
                ),
              )
            ],
          ),
        ));
  }

  openDialog() async {
    DictionaryResponse? bankModel =
        await Navigator.of(context).push(MaterialPageRoute<DictionaryResponse>(
            builder: (BuildContext context) {
              return BankDialog(
                banks: bankModels ?? [],
              );
            },
            fullscreenDialog: true));
    if (bankModel != null) {
      setState(() {
        selectedBank = bankModel;
      });
    }
  }

  Widget buildAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textValue("Thông tin tài khoản"),
        SizedBox(
          height: 4,
        ),
        textLabelRequired("Ngân hàng"),
        SizedBox(
          height: 4,
        ),
        InkWell(
          onTap: openDialog,
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: const BorderRadius.all(
                Radius.circular(6.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      selectedBank != null
                          ? selectedBank!.shortName!
                          : "Chọn ngân hàng",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.0,
                        color: Colors.black54,
                      )),
                  Icon(
                    Icons.expand_more,
                    color: Colors.black54,
                  ),
                ]),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        textLabelRequired("Số điện thoại"),
        SizedBox(
          height: 4,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _accMobile,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Số điện thoại",
            contentPadding: EdgeInsets.all(10),
            isDense: true,
          ),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Vui lòng nhập Số điện thoại";
            }
            return null;
          },
        ),
        SizedBox(
          height: 10,
        ),
        textLabelRequired("Số tài khoản"),
        SizedBox(
          height: 4,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _accNumber,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Số tài khoản",
            contentPadding: EdgeInsets.all(10),
            isDense: true,
          ),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Vui lòng nhập số tài khoản";
            }
            return null;
          },
        ),
        SizedBox(
          height: 10,
        ),
        textLabelRequired("Chủ tài khoản"),
        SizedBox(
          height: 4,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _accNameNumber,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Chủ tài khoản",
              contentPadding: EdgeInsets.all(10),
              isDense: true),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Vui lòng nhập chủ tài khoản";
            }
            return null;
          },
        ),
        SizedBox(
          height: 10,
        ),
        textLabelRequired("CCCD/Hộ chiếu"),
        SizedBox(
          height: 4,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _accPIDNumber,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "CCCD/Hộ chiếu",
              contentPadding: EdgeInsets.all(10),
              isDense: true),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return "Vui lòng nhập CCCD/Hộ chiếu";
            }
            return null;
          },
        ),
        SizedBox(
          height: 10,
        ),
        Text("Email"),
        SizedBox(
          height: 4,
        ),
        TextField(
            controller: _email,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Email",
                contentPadding: EdgeInsets.all(10),
                isDense: true))
      ],
    );
  }

  Widget buildDevice() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textValue("Thông tin thiết bị"),
          SizedBox(
            height: 4,
          ),
          textLabelRequired("Mã thiết bị (Serial)"),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _serial,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Mã thiết bị (Serial)",
                    contentPadding: EdgeInsets.all(10),
                    isDense: true),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Vui lòng nhập Mã thiết bị";
                  }
                  return null;
                },
              )),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScanQRCode(
                                onCallBack: (value) {
                                  _serial.text = value;
                                  _accVirtual.text = value;
                                  setState(() {});
                                },
                              )));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 4),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: ColorMP.ColorAccent,
                      borderRadius: BorderRadius.circular(4)),
                  child: Icon(
                    Ionicons.qr_code_outline,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          textLabel("Số tài khoản ảo"),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _accVirtual,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Số tài khoản ảo",
                contentPadding: EdgeInsets.all(10),
                isDense: true),
          ),
        ]);
  }
}
