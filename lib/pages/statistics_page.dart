import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticsPage extends StatefulWidget {
  final String accessToken;

  const StatisticsPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late bool isLoading;
  late Map<String, dynamic> statisticsData;
  int numberOfRooms = 0;
  int numberOfTenants = 0;
  int numberOfRoomsOccupied = 0;
  int totalBedSpaceLeft = 0;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    statisticsData = {};
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ethenatx.pythonanywhere.com/management/management-profile/'),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          statisticsData = data;
          numberOfRooms = statisticsData['number_of_rooms'] ?? 0;
          numberOfRoomsOccupied = statisticsData['number_rooms_occupied'] ?? 0;
          numberOfTenants = statisticsData['number_of_tenants'] ?? 0;
          totalBedSpaceLeft = statisticsData['total_bed_space_left'] ?? 0;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load statistics data');
      }
    } catch (e) {
      print('Error fetching statistics data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF59B15)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Statistics',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF59B15),
            fontSize: 21,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCombinedChart(),
                  const SizedBox(height: 63),
                  const SizedBox(height: 23),
                  _buildCircularProgressBars(),
                  const SizedBox(height: 63),
                  _buildPieChart(
                    'Bed Space Distribution',
                    {
                      '4 in a Room': statisticsData['number_of_4_in_a_room'],
                      '3 in a Room': statisticsData['number_of_3_in_a_room'],
                      '2 in a Room': statisticsData['number_of_2_in_a_room'],
                      '1 in a Room': statisticsData['number_of_1_in_a_room'],
                    },
                  ),
                ],
              ),
            ),
    );
  }

  // Widget _buildCombinedChart() {
  //   return Container(
  //     height: 180,
  //     child: LineChart(
  //       LineChartData(
  //         lineTouchData: LineTouchData(
  //           touchTooltipData: LineTouchTooltipData(
  //             tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
  //             getTooltipItems: (List<LineBarSpot> touchedSpots) {
  //               return touchedSpots.map((LineBarSpot spot) {
  //                 if (spot.barIndex == 0) {
  //                   return LineTooltipItem(
  //                     'Tenants: ${statisticsData['number_of_tenants']}',
  //                     const TextStyle(color: Colors.white),
  //                   );
  //                 } else if (spot.barIndex == 1) {
  //                   return LineTooltipItem(
  //                     'Rooms Occupied: ${statisticsData['number_rooms_occupied']}',
  //                     const TextStyle(color: Colors.white),
  //                   );
  //                 } else {
  //                   return LineTooltipItem(
  //                     'Bed Space Left: ${statisticsData['total_bed_space_left']}',
  //                     const TextStyle(color: Colors.white),
  //                   );
  //                 }
  //               }).toList();
  //             },
  //           ),
  //           handleBuiltInTouches: true,
  //         ),
  //         lineBarsData: [
  //           _buildVerticalLine(
  //               'Tenants', 0, statisticsData['number_of_tenants'] ?? 0),
  //           _buildVerticalLine(
  //               'Occupied', 1, statisticsData['number_rooms_occupied'] ?? 0),
  //           _buildVerticalLine(
  //               'Space Left', 2, statisticsData['total_bed_space_left'] ?? 0),
  //         ],
  //         titlesData: FlTitlesData(
  //           topTitles: const AxisTitles(
  //               sideTitles: SideTitles(
  //             showTitles: false,
  //           )),
  //           leftTitles: const AxisTitles(
  //             sideTitles: SideTitles(showTitles: true, reservedSize: 40),
  //           ),
  //           bottomTitles: AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: true,
  //               interval: 1,
  //               reservedSize: 15,
  //               getTitlesWidget: (double value, TitleMeta titleMeta) {
  //                 return Text(
  //                   '${_getBottomTitles(value.toInt())}',
  //                   style: const TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 13,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         borderData: FlBorderData(
  //             show: true,
  //             border: const Border(
  //               left: BorderSide(width: 1.0),
  //               bottom: BorderSide(width: 1.0),
  //             )),
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildCombinedChart() {
  //   return Container(
  //     height: 195,
  //     // width: 630,
  //     child: BarChart(
  //       BarChartData(
  //         barGroups: [
  //           _buildVerticalBar(
  //               'Ten', 0, statisticsData['number_of_tenants'] ?? 0),
  //           _buildVerticalBar(
  //               'Occ', 1, statisticsData['number_rooms_occupied'] ?? 0),
  //           _buildVerticalBar(
  //               'Rooms', 2, statisticsData['number_of_rooms'] ?? 0),
  //           _buildVerticalBar(
  //               'Space', 3, statisticsData['total_bed_space_left'] ?? 0),
  //         ],
  //         titlesData: FlTitlesData(
  //           leftTitles: const AxisTitles(
  //             sideTitles: SideTitles(showTitles: true, reservedSize: 26),
  //           ),
  //           topTitles: const AxisTitles(
  //             sideTitles: SideTitles(showTitles: true, reservedSize: 40),
  //           ),
  //           rightTitles:
  //               const AxisTitles(sideTitles: SideTitles(reservedSize: 20)),
  //           bottomTitles: AxisTitles(
  //             sideTitles: SideTitles(
  //               showTitles: true,
  //               interval: 1,
  //               reservedSize: 15,
  //               getTitlesWidget: (double value, TitleMeta titleMeta) {
  //                 return Text(
  //                   '${_getBottomTitles(value.toInt())}',
  //                   style: const TextStyle(
  //                     fontSize: 13,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         borderData: FlBorderData(
  //           show: true,
  //           border: const Border(
  //             left: BorderSide(width: 1.0),
  //             bottom: BorderSide(width: 1.0),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  BarChartGroupData _buildVerticalBar(String title, double x, double value) {
    return BarChartGroupData(
      x: x.toInt(),
      barRods: [
        BarChartRodData(
          toY: value,
          width: 9,
          color: const Color(0xFFF59B15),
        ),
      ],
    );
  }

  String _getBottomTitles(int value) {
    switch (value) {
      case 0:
        return 'Tenants';
      case 1:
        return 'Occupied';
      case 2:
        return 'Rooms';
      case 3:
        return 'Space';
      default:
        return '';
    }
  }

  int touchedIndex = -1;

  Widget _buildPieChart(String title, Map<String, dynamic> data, {Key? key}) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              // Pie Chart on the left
              Expanded(
                child: Container(
                  height: 300,
                  key: key,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: _getModifiedPieChartSections(data),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  width: 16), // Adjust spacing between pie chart and legend
              // Legend items on the right
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.entries
                    .map((entry) => _buildLegendItem(
                          entry.key,
                          entry.value,
                          _getColorForIndex(
                              data.keys.toList().indexOf(entry.key)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String type, dynamic value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 4),
        Text(
          '$type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 12), // Adjust spacing between legend items as needed
      ],
    );
  }

  Color _getColorForIndex(int index) {
    final List<Color> colors = [
      Color(0xfff49e1d),
      Color(0xffff5e01),
      Color(0xfffff05f),
      Color(0xfc6e4e24),
    ];

    return colors[index % colors.length];
  }

  List<PieChartSectionData> _getModifiedPieChartSections(
      Map<String, dynamic> data) {
    List<PieChartSectionData> sections = [];
    final List<Color> colors = [
      const Color(0xfff49e1d),
      const Color(0xffff5e01),
      const Color(0xfffff05f),
      const Color(0xfc6e4e24),
    ];

    data.forEach((key, value) {
      if (value != null && value is num) {
        sections.add(
          PieChartSectionData(
            color: colors[sections.length % colors.length],
            value: value.toDouble(),
            title: '${value.toString()}',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 19.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      }
    });

    return sections;
  }

  Widget _buildCircularProgressBars() {
    double tenantsPercentage =
        (statisticsData['number_of_tenants'] ?? 0) / numberOfRooms;
    double occupiedPercentage =
        (statisticsData['number_rooms_occupied'] ?? 0) / numberOfRooms;
    double spaceLeftPercentage =
        (statisticsData['total_bed_space_left'] ?? 0) / 43;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCircularProgressBar(
            '$numberOfTenants recorded', 'Tenants', tenantsPercentage),
        _buildCircularProgressBar('$numberOfRoomsOccupied rooms filled',
            'Occupied', occupiedPercentage),
        _buildCircularProgressBar(
            '$totalBedSpaceLeft unoccupied', 'Space Left', spaceLeftPercentage),
      ],
    );
  }

  Widget _buildCircularProgressBar(
      String sublabel, String label, double percentage) {
    int roundedPercentage = (percentage * 100).round();
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 10.0,
          animation: true,
          animationDuration: 990,
          percent: percentage,
          center: Text('$roundedPercentage%',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: const Color(0xFFF59B15),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Row(
          children: [Text("("), Text(sublabel), Text(")")],
        )
      ],
    );
  }

  Widget _buildCombinedChart() {
    return Container(
      height: 180,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, statisticsData['number_of_tenants']?.toDouble() ?? 0),
                FlSpot(1,
                    statisticsData['number_rooms_occupied']?.toDouble() ?? 0),
                FlSpot(2, statisticsData['number_of_rooms']?.toDouble() ?? 0),
                FlSpot(
                    3, statisticsData['total_bed_space_left']?.toDouble() ?? 0),
              ],
              isCurved: true,
              belowBarData: BarAreaData(show: true),
              color: const Color(0xFFF59B15),
              dotData: const FlDotData(show: false),
              isStrokeCapRound: true,
              preventCurveOverShooting: true,
              barWidth: 5, // Adjust this value to control thickness
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 15,
                getTitlesWidget: (double value, TitleMeta titleMeta) {
                  return Text(
                    '${_getBottomTitles(value.toInt())}',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(width: 1.0),
              bottom: BorderSide(width: 1.0),
            ),
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildVerticalLine(String title, double x, double value) {
    return LineChartBarData(
      spots: [
        FlSpot(x, 0),
        FlSpot(x, value),
      ],
      isCurved: true,
      belowBarData: BarAreaData(show: true),
      color: const Color(0xFFF59B15),
      dotData: const FlDotData(show: false),
      isStrokeCapRound: true,
      preventCurveOverShooting: true,
      barWidth: 1,
    );
  }
}
