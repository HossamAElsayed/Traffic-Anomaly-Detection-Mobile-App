import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DataUsageScreen extends StatefulWidget {
  const DataUsageScreen({Key? key}) : super(key: key);

  @override
  _DataUsageScreenState createState() => _DataUsageScreenState();
}

class _DataUsageScreenState extends State<DataUsageScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    // make _isLoaded true after 2 seconds
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff161621),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            FadeInUp(
                                duration: const Duration(milliseconds: 800),
                                child: Text(
                                  "Total Data Usage",
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade300,
                                      fontSize: 20),
                                )),
                            const SizedBox(height: 20),
                            FadeInUp(
                              duration: const Duration(milliseconds: 800),
                              child: Text(
                                "450 MB",
                                style: GoogleFonts.sora(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: SizedBox(
                          width: double.infinity,
                          height: 250,
                          child: LineChart(
                            mainData(),
                            swapAnimationDuration:
                                const Duration(milliseconds: 1000), // Optional
                            swapAnimationCurve: Curves.linear, // Optional
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ];
          },
          body: Container(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // FadeInUp(
              //   duration: const Duration(milliseconds: 1000),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       MaterialButton(
              //         onPressed: () {
              //           // Navigator.of(context).pushReplacementNamed('/');
              //         },
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 30, vertical: 15),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10)),
              //         color: const Color(0xff02d39a).withOpacity(0.7),
              //         child: Row(
              //           children: const [
              //             Icon(
              //               Icons.account_balance_wallet_outlined,
              //               color: Colors.white,
              //             ),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Text(
              //               "Payment",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //       ),
              //       const SizedBox(width: 20),
              //       MaterialButton(
              //         onPressed: () {},
              //         shape: RoundedRectangleBorder(
              //             side: BorderSide(
              //                 color: const Color(0xff02d39a).withOpacity(0.4),
              //                 width: 1),
              //             borderRadius: BorderRadius.circular(10)),
              //         splashColor: const Color(0xff02d39a).withOpacity(0.4),
              //         highlightColor: const Color(0xff02d39a).withOpacity(0.4),
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 30, vertical: 15),
              //         color: Colors.transparent,
              //         elevation: 0,
              //         child: Row(
              //           children: const [
              //             Icon(
              //               Icons.arrow_circle_up_rounded,
              //               color: Colors.white,
              //             ),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Text(
              //               "Transfer",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(height: 40),
              // recent transactions
              FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: Text(
                    "Recent Transactions",
                    style: TextStyle(
                        color: Colors.blueGrey.shade300, fontSize: 16),
                  )),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        from: 50,
                        duration: Duration(milliseconds: 1000 + index * 100),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Colors.black.withOpacity(0.3),
                              border: Border.all(
                                  color: Colors.blueGrey.withOpacity(0.3),
                                  width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(
                                Icons.arrow_circle_up_rounded,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Transfer",
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "\$ 12,500.00",
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "12:00 PM",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 11);
    Widget text;
    List<String> days = [];
    var today = DateTime.now();
    for (var i = 0; i < 12; i++) {
      var newDate = DateTime(today.year, today.month, today.day - i);
      days.add(newDate.day.toString());
    }
    switch (value.toInt()) {
      case 1:
        text = Text(days[10], style: style);
        break;
      case 2:
        text = Text(days[9], style: style);
        break;
      case 3:
        text = Text(days[8], style: style);
        break;
      case 4:
        text = Text(days[7], style: style);
        break;
      case 5:
        text = Text(days[6], style: style);
        break;
      case 6:
        text = Text(days[5], style: style);
        break;
      case 7:
        text = Text(days[4], style: style);
        break;
      case 8:
        text = Text(days[3], style: style);
        break;
      case 9:
        text = Text(days[2], style: style);
        break;
      case 10:
        text = Text(days[1], style: style);
        break;
      case 11:
        text = Text(days[0], style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return Padding(child: text, padding: const EdgeInsets.only(top: 8.0));
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10MB';
        break;
      case 3:
        text = '30MB';
        break;
      case 5:
        text = '50MB';
        break;
      case 7:
        text = '100MB';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  LineChartData mainData() {
    return LineChartData(
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(
          show: true,
          horizontalInterval: 1.6,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              dashArray: const [3, 3],
              color: const Color(0xff37434d).withOpacity(0.2),
              strokeWidth: 2,
            );
          },
          drawVerticalLine: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTitlesWidget: bottomTitleWidgets,
        )),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: leftTitleWidgets,
          reservedSize: 40,

          // margin: 12,
        )),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: _isLoaded
              ? const [
                  FlSpot(0, 3),
                  FlSpot(2.4, 2),
                  FlSpot(4.4, 3),
                  FlSpot(6.4, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 4),
                  FlSpot(11, 5),
                ]
              : const [
                  FlSpot(0, 0),
                  FlSpot(2.4, 0),
                  FlSpot(4.4, 0),
                  FlSpot(6.4, 0),
                  FlSpot(8, 0),
                  FlSpot(9.5, 0),
                  FlSpot(11, 0)
                ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          // colors: gradientColors,
          barWidth: 2,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 146, 193, 180).withOpacity(0.1),
                const Color(0xff02d39a).withOpacity(0),
              ].map((color) => color.withOpacity(0.3)).toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
