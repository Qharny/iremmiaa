import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalesStatsPage extends StatefulWidget {
  final String accessToken;

  const SalesStatsPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _SalesStatsPageState createState() => _SalesStatsPageState();
}

class _SalesStatsPageState extends State<SalesStatsPage> {
  List<Map<String, dynamic>> salesData = [];
  List<double> years = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ethenatx.pythonanywhere.com/management/sales-stats/'),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          salesData = List<Map<String, dynamic>>.from(data);
          years = salesData.map((data) => data['year'] as double).toList();
        });
      } else if (response.statusCode == 404) {
        // Handle 404 error
        print('No data found');
      } else {
        // Handle other errors
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle network or other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Sales Stats',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF59B15),
            fontSize: 21,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF59B15)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: salesData.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(right: 18, top: 18),
              child: Container(
                width: MediaQuery.of(context).size.width * 1.5,
                height: 270,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles:
                            SideTitles(reservedSize: 40, showTitles: true),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles:
                            SideTitles(reservedSize: 0, showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles:
                            SideTitles(reservedSize: 0, showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 44,
                          interval: 1,
                          showTitles: true,
                          getTitlesWidget: (value, titleMeta) {
                            if (years.isEmpty) {
                              return Text("Loading...");
                            }
                            if (value.toInt() >= 0 &&
                                value.toInt() < years.length) {
                              return Text(years[value.toInt()].toString());
                            }
                            return Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(width: 2.0),
                        bottom: BorderSide(width: 2.0),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: salesData
                            .map(
                              (data) => FlSpot(
                                data['year'].toDouble(),
                                data['amount'].toDouble(),
                              ),
                            )
                            .toList(),
                        isCurved: true,
                        curveSmoothness: 0.14,
                        color: Color(0xFFF59B15),
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
