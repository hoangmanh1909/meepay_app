// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
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
import 'package:meepay_app/utils/color_extension.dart';
import 'package:meepay_app/utils/color_mp.dart';
import 'package:meepay_app/utils/common.dart';
import 'package:meepay_app/utils/dialog_date.dart';
import 'package:meepay_app/utils/dialog_process.dart';
import 'package:meepay_app/utils/dimen.dart';
import 'package:meepay_app/utils/scaffold_messger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);
  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
      ];

  final Color barBackgroundColor =
      AppColors.contentColorWhite.darken().withValues(alpha: 0.3);
  final Color barColor = ColorMP.ColorAccent;
  final Color touchedBarColor = AppColors.contentColorGreen;
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

  List<BarChartGroupData> showingGroups = [];

  AccountSearchResponse? account;
  int quantity = 0;
  int amount = 0;
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
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
        showingGroups.add(makeGroupData(i, item.amount!.toDouble(),
            isTouched: i == touchedIndex));
      }
      for (int i = 0; i < generals!.length; i++) {
        var item = generals![i];
        showingGroups.add(makeGroupData(i, item.amount!.toDouble(),
            isTouched: i == touchedIndex));
      }
      for (int i = 0; i < generals!.length; i++) {
        var item = generals![i];
        showingGroups.add(makeGroupData(i, item.amount!.toDouble(),
            isTouched: i == touchedIndex));
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
                        color: Colors.white.withValues(alpha: 0.1),
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

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor.darken(80))
              : BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  // List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
  //       switch (i) {
  //         case 0:
  //           return makeGroupData(0, 5, isTouched: i == touchedIndex);
  //         case 1:
  //           return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
  //         case 2:
  //           return makeGroupData(2, 5, isTouched: i == touchedIndex);
  //         case 3:
  //           return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
  //         case 4:
  //           return makeGroupData(4, 9, isTouched: i == touchedIndex);
  //         case 5:
  //           return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
  //         case 6:
  //           return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
  //         default:
  //           return throw Error();
  //       }
  //     });

  Widget buildChart() {
    if (generals != null) {
      return Container(
        height: 250,
        width: 200,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(Dimen.padingDefault),
        decoration: decorationMP(),
        child: BarChart(
          mainBarData(),
          duration: animDuration,
        ),
      );
    }
    return SizedBox.shrink();
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          fitInsideVertically: true,
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              case 6:
                weekDay = 'Sunday';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: formatAmount(rod.toY),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups,
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: ColorMP.ColorPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: Text("13/01", style: style),
    );
  }
}
