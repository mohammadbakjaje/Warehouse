import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartScreen extends StatefulWidget {
  @override
  _LineChartScreenState createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen> {
  // بيانات ثابتة تمثل نقاط البيانات للمخطط البياني
  List<DataPoint> dataPoints = [
    DataPoint(x: 0, y: 10),
    DataPoint(x: 1, y: 30),
    DataPoint(x: 2, y: 80),
    DataPoint(x: 3, y: 70),
    DataPoint(x: 4, y: 90),
    DataPoint(x: 5, y: 50),
  ];

  // دالة لإضافة نقطة بيانات جديدة (نقطة ثابتة في هذه الحالة)
  void addDataPoint() {
    setState(() {
      dataPoints.add(DataPoint(x: 6, y: 60)); // إضافة نقطة جديدة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // عرض المخطط البياني باستخدام fl_chart
          LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 100,
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints
                      .map((point) => FlSpot(point.x, point.y))
                      .toList(),
                  isCurved: true,
                  colors: [Colors.orange],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // زر لإضافة نقطة بيانات جديدة
          ElevatedButton(
            onPressed: addDataPoint, // دالة إضافة نقطة جديدة
            child: Text("إضافة نقطة بيانات"),
          ),
        ],
      ),
    );
  }
}

// كائن يمثل نقطة البيانات (تستخدمه في المخطط البياني)
class DataPoint {
  final double x;
  final double y;

  DataPoint({required this.x, required this.y});
}
