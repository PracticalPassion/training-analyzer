import 'dart:ffi';

import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/model/ChartData.dart';
import 'package:fitness_analyzer/src/model/Workouttype.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fitness_analyzer/src/globals.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class EnduranceProgressChart {
  static String secondaryAxis = "hf";
  static String primaryAxis = "pace";

  static Color red = const Color.fromARGB(255, 199, 52, 55);
  static Color blue = const Color.fromARGB(255, 12, 95, 159);

  Widget getChart(context, WorkoutType type, ZoomPanBehavior? _zoomPanBehavior) {
    // get required Data
    List<ChartDataEnduranceProgress> data = Provider.of<ProviderWorkout>(context).genDataEnduranceProgress(type);
    var dataReag = Provider.of<ProviderWorkout>(context).generateRegression(data);

    return SfCartesianChart(
        zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: DateTimeAxis(
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          // majorGridLines: MajorGridLines(width: 0),
          isInversed: type == WorkoutType.cycling ? false : true,
          minimum: (data.map((e) => e.speed).toList().reduce(min) - 1).floorToDouble(),
          maximum: (data.map((e) => e.speed).toList().reduce(max) + 1).ceilToDouble(), //title: AxisTitle(//text: 'Geschwindigkeit', textStyle: const TextStyle(color: CupertinoColors.activeBlue))
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        axes: <ChartAxis>[
          NumericAxis(
              // majorGridLines: MajorGridLines(width: 0),
              name: secondaryAxis,
              opposedPosition: true,
              title: AxisTitle(//text: 'Herzfrequenz', textStyle: TextStyle(color: CupertinoColors.systemRed)
                  ),
              minimum: (data.map((e) => e.heartRate).toList().reduce(min) / 10).round() * 10 - 15,
              maximum: (data.map((e) => e.heartRate).toList().reduce(max) / 10).round() * 10 + 15)
        ],
        series: <ChartSeries>[
          ScatterSeries<ChartDataEnduranceProgress, DateTime>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ChartDataEnduranceProgress data, _) => data.time,
              yValueMapper: (ChartDataEnduranceProgress data, _) => data.heartRate,
              yAxisName: secondaryAxis,
              name: "bpm",
              markerSettings: const MarkerSettings(height: 6, width: 6),
              color: red.withOpacity(0.6)),
          LineSeries<ChartData, DateTime>(
              dataSource: dataReag[1], xValueMapper: (ChartData data, _) => data.time, yValueMapper: (ChartData data, _) => data.sales, yAxisName: secondaryAxis, isVisibleInLegend: false, color: red),
          ScatterSeries<ChartDataEnduranceProgress, DateTime>(
            enableTooltip: true,
            dataSource: data,
            xValueMapper: (ChartDataEnduranceProgress data, _) => data.time,
            yValueMapper: (ChartDataEnduranceProgress data, _) => data.speed,
            yAxisName: primaryAxis,
            name: type == WorkoutType.cycling ? "km/h" : "min/km",
            markerSettings: const MarkerSettings(height: 6, width: 6),
            color: blue.withOpacity(0.6),
            // trendlines: <Trendline>[Trendline(type: TrendlineType.linear, color: CupertinoColors.activeBlue)]
          ),
          LineSeries<ChartData, DateTime>(
              dataSource: dataReag[0], xValueMapper: (ChartData data, _) => data.time, yValueMapper: (ChartData data, _) => data.sales, yAxisName: primaryAxis, isVisibleInLegend: false, color: blue)
        ]);
  }

  Widget generateZoneChart(context, WorkoutType type) {
    List<WorkoutType> list = [type];
    return SfCartesianChart(primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)), primaryYAxis: NumericAxis(), series: <ChartSeries>[
      ColumnSeries<ChartDataZone, String>(
          dataSource: Provider.of<ProviderWorkout>(context).generateZoneChart(list, DateTime.now().subtract(const Duration(days: 180))),
          xValueMapper: (ChartDataZone data, _) => data.type,
          yValueMapper: (ChartDataZone data, _) => data.totalHours,
          width: 0.8,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
          dataLabelMapper: (ChartDataZone data, _) => "${(data.percentage * 100).toStringAsFixed(0)} %",
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          spacing: 0.2)
    ]);
  }
}
