import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meepay_app/utils/color_mp.dart';

class DChartView extends StatefulWidget {
  const DChartView({Key? key}) : super(key: key);

  @override
  State<DChartView> createState() => _DChartViewState();
}

class _DChartViewState extends State<DChartView> {
  List<TimeData> series1 = [
    TimeData(domain: DateTime(2024, 10, 12), measure: 3),
    TimeData(domain: DateTime(2024, 10, 13), measure: 2),
    TimeData(domain: DateTime(2024, 10, 14), measure: 4),
    TimeData(domain: DateTime(2024, 10, 15), measure: 6),
    TimeData(domain: DateTime(2024, 10, 16), measure: 3),
    TimeData(domain: DateTime(2024, 10, 17), measure: 2),
    TimeData(domain: DateTime(2024, 10, 18), measure: 4),
    TimeData(domain: DateTime(2024, 10, 19), measure: 6),
    TimeData(domain: DateTime(2024, 10, 20), measure: 3),
    TimeData(domain: DateTime(2024, 10, 21), measure: 2),
    TimeData(domain: DateTime(2024, 10, 22), measure: 4),
    TimeData(domain: DateTime(2024, 10, 23), measure: 6),
    TimeData(domain: DateTime(2024, 10, 24), measure: 3.8),
    TimeData(domain: DateTime(2024, 10, 25), measure: 1.8),
    TimeData(domain: DateTime(2024, 10, 26), measure: 1.2),
    TimeData(domain: DateTime(2024, 10, 27), measure: 3),
    TimeData(domain: DateTime(2024, 10, 28), measure: 2),
    TimeData(domain: DateTime(2024, 10, 29), measure: 4),
  ];
  TimeData maxTimeData = TimeData(domain: DateTime(2024, 1), measure: 10);
  void findMaxDomain() {
    for (final data in series1) {
      if (data.measure > maxTimeData.measure) {
        maxTimeData = data;
      }
    }
    setState(() {});
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
      body: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartBarT(
                layoutMargin: LayoutMargin(40, 10, 10, 10),
                configRenderBar: ConfigRenderBar(
                  radius: 4,
                ),
                fillColor: (group, timeData, index) {
                  return timeData.domain == maxTimeData.domain
                      ? Colors.deepPurple
                      : null;
                },
                onUpdatedListener: (data) {
                  String sss = "";
                },
                domainAxis: DomainAxis(
                  showLine: false,
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
                // measureAxis: const MeasureAxis(
                //   noRenderSpec: true,
                // ),
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
                    data: series1,
                    color: Colors.deepPurple.shade100,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
