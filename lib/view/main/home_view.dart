// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:d_chart/commons/axis/axis.dart';
import 'package:d_chart/commons/config_render/config_render.dart';
import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/commons/layout_margin.dart';
import 'package:d_chart/commons/style/style.dart';
import 'package:d_chart/commons/tick/numeric_tick_provider.dart';
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
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_date.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
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
  List<TimeData> dataChart = [];

  AccountSearchResponse? account;
  int quantity = 0;
  int amount = 0;
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final Duration animDuration = const Duration(milliseconds: 250);

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

      req.fromDate = DateFormat('dd/MM/yyyy')
          .format(DateTime.now().add(Duration(days: -7)));
      req.toDate = formattedDate;
      // req.accountID = item.iD;
      await getNotifyGeneral(req);
      await getNotify(req);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
      showMessage(res.message!, "99", 4);
    }
  }

  getNotify(NotifySearchRequest req) async {
    // if (mounted) showProcess(context);

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

    // if (mounted) {
    //   Navigator.pop(context);
    // }
  }

  getNotifyGeneral(NotifySearchRequest req) async {
    // if (mounted) showProcess(context);

    ResponseObject res = await con.general(req);
    if (res.code == "00") {
      generals = List<NotifyGeneralResponse>.from((jsonDecode(res.data!)
          .map((model) => NotifyGeneralResponse.fromJson(model))));

      for (int i = 0; i < generals!.length; i++) {
        var item = generals![i];
        dataChart.add(TimeData(
            domain: DateFormat("dd/MM/yyyy").parse(item.transDate!),
            measure: item.amount!));
      }

      setState(() {});
    }

    // if (mounted) {
    //   Navigator.pop(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: [
              AppBar(
                  backgroundColor: ColorMP.ColorPrimary,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                  title: Text("Mee Pay"),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final values = await dialogDate(context);
                        if (values != null) {
                          NotifySearchRequest req = NotifySearchRequest();
                          req.fromDate =
                              DateFormat('dd/MM/yyyy').format(values[0]);
                          req.toDate =
                              DateFormat('dd/MM/yyyy').format(values[1]);

                          getNotify(req);
                        }
                      },
                    )
                  ]),
              InkWell(
                  onTap: () {
                    bottomSheet(context, accounts, (v) {
                      if (mounted) {
                        Navigator.pop(context);
                        account = v;
                        NotifySearchRequest req = NotifySearchRequest();
                        getNotify(req);
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          textAccount(account != null ? account!.name! : ""),
                          textAccount(
                              account != null ? account!.accoumtNumber! : ""),
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
                  ))
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
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(1, 1),
                      )
                    ]),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: Text(
                              "$formattedDate - $formattedDate",
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
            child: Text(
              "Lịch sử giao dịch",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            )),
        Positioned(
            // To take AppBar Size only
            top: 240.0,
            left: 8.0,
            right: 8.0,
            bottom: 8,
            child: SingleChildScrollView(
                child: Column(
              children: [
                buildChart(),
                buildNotifies(),
              ],
            )))
      ],
    );
  }

  Widget buildChart() {
    if (generals != null && generals!.isNotEmpty) {
      Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width - 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartBarT(
                layoutMargin: LayoutMargin(40, 10, 10, 10),
                configRenderBar: ConfigRenderBar(
                  radius: 4,
                ),
                onUpdatedListener: (data) {
                  String sss = "";
                },
                domainAxis: DomainAxis(
                  showLine: true,
                  lineStyle: LineStyle(color: Colors.grey.shade200),
                  tickLength: 0,
                  gapAxisToLabel: 12,
                  labelStyle: const LabelStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                  tickLabelFormatterT: (domain) {
                    return DateFormat.MMM().format(domain);
                  },
                ),
                measureAxis: const MeasureAxis(
                  gapAxisToLabel: 8,
                  numericTickProvider: NumericTickProvider(
                    desiredMinTickCount: 5,
                    desiredMaxTickCount: 10,
                  ),
                  tickLength: 0,
                  labelStyle: LabelStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
                groupList: [
                  TimeGroup(
                    id: '1',
                    data: dataChart,
                    color: Colors.deepPurple.shade100,
                  ),
                ],
              ),
            ),
          ));
    }
    return SizedBox.shrink();
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
