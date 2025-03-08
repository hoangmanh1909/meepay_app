// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:d_chart/commons/axis/axis.dart';
import 'package:d_chart/commons/config_render/config_render.dart';
import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/commons/decorator/decorator.dart';
import 'package:d_chart/commons/layout_margin.dart';
import 'package:d_chart/commons/style/style.dart';
import 'package:d_chart/commons/tick/numeric_tick_provider.dart';
import 'package:d_chart/commons/viewport.dart';
import 'package:d_chart/d_chart.dart';
import 'package:d_chart/time/bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:meepay_app/controller/account_controller.dart';
import 'package:meepay_app/controller/notify_controller.dart';
import 'package:meepay_app/models/request/account_search_request.dart';
import 'package:meepay_app/models/request/notify_search_request.dart';
import 'package:meepay_app/models/response/account_search_response.dart';
import 'package:meepay_app/models/response/notify_general_response.dart';
import 'package:meepay_app/models/response/notify_search_response.dart';
import 'package:meepay_app/models/response/response_object.dart';
import 'package:meepay_app/models/response/user_profile.dart';
import 'package:meepay_app/utils/app_color.dart';
import 'package:meepay_app/utils/bottom_sheet.dart';
import 'package:meepay_app/utils/box_shadow.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_date.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:meepay_app/view/account/add_link_view.dart';
import 'package:meepay_app/view/account/user_info_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final NotifyController con = NotifyController();
  final AccountController conAcc = AccountController();
  SharedPreferences? prefs;
  UserProfile? userProfile;
  List<NotifySearchResponse>? notifies;
  List<AccountSearchResponse> accounts = [];
  List<NotifyGeneralResponse>? generals;
  List<OrdinalData> dataChart = [];
  String startDomain = "";

  AccountSearchResponse? account;
  int quantity = 0;
  int amount = 0;
  String fromDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: -22)));
  final Duration animDuration = const Duration(milliseconds: 250);
  String toDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      initPref();
    });
    super.initState();
  }

  initPref() async {
    prefs = await SharedPreferences.getInstance();
    String? userMap = prefs?.getString('user');
    if (userMap != null) {
      setState(() {
        userProfile = UserProfile.fromJson(jsonDecode(userMap));
      });

      await accountSearch();
    }
  }

  accountSearch() async {
    AccountSearchRequest req = AccountSearchRequest();
    req.merchantID = userProfile!.merchantID;
    req.shopID = userProfile!.shopID;

    if (mounted) showProcess(context);
    ResponseObject res = await conAcc.search(req);

    if (res.code == "00") {
      // List<AccountSearchResponse> r = List<AccountSearchResponse>.from(
      //     (jsonDecode(res.data!)
      //         .map((model) => AccountSearchResponse.fromJson(model))));
      // r.addAll(List<AccountSearchResponse>.from((jsonDecode(res.data!)
      //     .map((model) => AccountSearchResponse.fromJson(model)))));
      setState(() {
        accounts = List<AccountSearchResponse>.from((jsonDecode(res.data!)
            .map((model) => AccountSearchResponse.fromJson(model))));
      });

      account = accounts[0];
      NotifySearchRequest req = NotifySearchRequest();

      req.fromDate = fromDate;
      req.toDate = toDate;
      req.accountID = account!.iD;
      await getNotifyGeneral(req);

      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      // showMessage(res.message!, "99", 4);
    }
  }

  getNotifyGeneral(NotifySearchRequest req) async {
    dataChart.clear();
    notifies = [];
    quantity = 0;
    amount = 0;
    setState(() {});
    ResponseObject res = await con.general(req);
    if (res.code == "00") {
      generals = List<NotifyGeneralResponse>.from((jsonDecode(res.data!)
          .map((model) => NotifyGeneralResponse.fromJson(model))));
      startDomain = generals![0].transDate!;
      for (int i = 0; i < generals!.length; i++) {
        var item = generals![i];
        dataChart.add(OrdinalData(
            domain: item.transDate!.substring(0, 5),
            measure: item.amount!,
            other: item.transDate));
      }

      req = NotifySearchRequest();
      req.fromDate = startDomain;
      req.toDate = startDomain;
      req.accountID = account!.iD;
      await getNotify(req);

      setState(() {});
    }
  }

  getNotify(NotifySearchRequest req) async {
    ResponseObject res = await con.search(req);
    if (res.code == "00") {
      setState(() {
        notifies = List<NotifySearchResponse>.from((jsonDecode(res.data!)
            .map((model) => NotifySearchResponse.fromJson(model))));
        quantity = notifies!.length;
        amount = notifies!
            .fold(0, (previous, current) => previous + current.amount!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: [
              AppBar(
                  backgroundColor: ColorMP.ColorPrimary,
                  titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                  leadingWidth: size.width - 100,
                  leading: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserView()));
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                Ionicons.person,
                                color: ColorMP.ColorPrimary,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Xin chào!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  userProfile != null ? userProfile!.name! : "",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        List<DateTime> values = await dialogDate(context);
                        if (values.length > 1) {
                          fromDate = DateFormat('dd/MM/yyyy').format(values[0]);
                          toDate = DateFormat('dd/MM/yyyy').format(values[1]);
                          NotifySearchRequest req = NotifySearchRequest();
                          req.accountID = account!.iD!;
                          req.fromDate = fromDate;
                          req.toDate = toDate;

                          getNotifyGeneral(req);
                        }
                      },
                    )
                  ]),
              buildAccountNumber()
            ],
          ),
          height: 150,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: ColorMP.ColorPrimary,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
        ),

        Container(), // Required some widget in between to float AppBar

        Positioned(
            // To take AppBar Size only
            top: 100.0,
            left: 20.0,
            right: 20.0,
            child: Container(
                width: 170,
                height: 100,
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: Text(
                              "$fromDate - $toDate",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Số lượng"),
                            textAmount(
                                formatNumber(quantity), ColorMP.ColorPrimary),
                          ],
                        )),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Doanh thu"),
                            textAmount(
                                formatAmount(amount), ColorMP.ColorAccent),
                          ],
                        )),
                      ],
                    )
                  ],
                ))),

        Positioned(
            // To take AppBar Size only
            top: 210.0,
            left: 8.0,
            right: 8.0,
            bottom: 8,
            child: buildBody())
      ],
    );
  }

  Widget buildAccountNumber() {
    if (accounts.isNotEmpty) {
      return InkWell(
          onTap: () {
            bottomSheet(context, accounts, (v) {
              if (mounted) {
                Navigator.pop(context);
                setState(() {
                  account = v;
                });
                NotifySearchRequest req = NotifySearchRequest();
                req.accountID = account!.iD!;
                req.fromDate = fromDate;
                req.toDate = toDate;
                getNotifyGeneral(req);
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  textAccount(account != null ? account!.name! : ""),
                  textAccount(account != null ? account!.accoumtNumber! : ""),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(
                  Ionicons.chevron_down,
                  size: 20,
                  color: Colors.white,
                ),
              )
            ],
          ));
    }
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddLinkView()));
      },
      child: Container(
          alignment: Alignment.center,
          height: 30,
          width: 150,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text("Liên kết ngân hàng",
              style: TextStyle(
                  color: ColorMP.ColorAccent, fontWeight: FontWeight.w600))),
    );
  }

  Widget buildBody() {
    if (generals != null && generals!.isNotEmpty) {
      return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thống kê giao dịch",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 4,
          ),
          buildChart(),
          Text(
            "Chi tiết giao dịch ngày $startDomain",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 4,
          ),
          buildNotifies(),
        ],
      ));
    }
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Ionicons.tablet_landscape_outline,
            size: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Danh sách trống")
        ],
      ),
    );
  }

  Widget buildChart() {
    return Container(
        decoration: decorationMP(),
        width: MediaQuery.of(context).size.width - 18,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: DChartBarO(
            allowSliding: true,
            animate: true,
            configRenderBar: ConfigRenderBar(maxBarWidthPx: 24),
            fillColor: (group, ordinalData, index) {
              if (ordinalData.other == startDomain) {
                return ColorMP.ColorPrimary;
              }
              return ColorMP.ColorAccent;
            },
            onUpdatedListener: (data) {
              startDomain = data.other.toString();
              NotifySearchRequest req = NotifySearchRequest();
              req.fromDate = startDomain;
              req.toDate = startDomain;
              req.accountID = account!.iD;
              getNotify(req);
            },
            domainAxis: DomainAxis(
              showLine: true,
              ordinalViewport: OrdinalViewport(startDomain, 7),
              tickLength: 0,
              gapAxisToLabel: 10,
              labelStyle: const LabelStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              tickLabelFormatterT: (domain) {
                return DateFormat("dd/MM").format(domain);
              },
            ),
            measureAxis: MeasureAxis(noRenderSpec: true),
            groupList: [
              OrdinalGroup(
                  id: '1', data: dataChart, color: ColorMP.ColorAccent),
            ],
          ),
        ));
  }

  Widget buildNotifies() {
    if (notifies != null) {
      return Column(
          children: notifies!.map((item) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.accountNumber!,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "+ ${formatAmount(item.amount)}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorMP.ColorSuccess),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textLable(
                    "Thời gian:",
                  ),
                  textValue(
                    item.transDate!,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textLable(
                    "Mã giao dịch:",
                  ),
                  textValue(
                    item.transID!,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textLable(
                    "Nội dung:",
                  ),
                  textValue(
                    item.content!,
                  ),
                ],
              )
            ],
          ),
        );
      }).toList());
    }
    return SizedBox.shrink();
  }

  Widget textLable(String mes) {
    return Text(
      mes,
      style: TextStyle(color: Colors.black54),
    );
  }

  Widget textValue(String mes) {
    return Flexible(
        child: Text(
      mes,
      softWrap: true,
      textAlign: TextAlign.right,
      style: TextStyle(color: Colors.black),
    ));
  }

  Widget textAccount(String mes) {
    return Text(
      mes.toUpperCase(),
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    );
  }

  Widget textAmount(String mes, Color color) {
    return Text(
      mes,
      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 20),
    );
  }
}
