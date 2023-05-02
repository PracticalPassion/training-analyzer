import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/model/ChartData.dart';
import 'package:fitness_analyzer/src/model/Workouttype.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Charts {
  Widget getTrandChart(context) {
    return SfCartesianChart(primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0), title: AxisTitle(text: 'Datum')), primaryYAxis: NumericAxis(), series: <ChartSeries>[
      ColumnSeries<ChartData, String>(
          dataSource: Provider.of<ProviderWorkout>(context).generateDashTrend(),
          xValueMapper: (ChartData data, _) =>
              Provider.of<ProviderWorkout>(context).selectedPeriodIndex <= ProviderWorkout.drop ? "${data.time.day}.${data.time.month} " : "${data.num} / ${data.time.year}",
          trackBorderWidth: 0,
          isTrackVisible: false,
          yValueMapper: (ChartData data, _) => data.sales,
          // Width of the columns
          width: 0.8,
          // Spacing between the columns
          spacing: 0.2)
    ]);
  }

  Widget getPieChart(context) {
    return SfCircularChart(
        legend: Legend(isVisible: true, position: MediaQuery.of(context).orientation != Orientation.portrait ? LegendPosition.right : LegendPosition.bottom, overflowMode: LegendItemOverflowMode.wrap),
        series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartDataPie, String>(
              animationDuration: 350,
              dataSource: Provider.of<ProviderWorkout>(context).generatePiedashboard(),
              xValueMapper: (ChartDataPie data, _) => WorkoutTypeExtention.getStringPretty(data.type),
              yValueMapper: (ChartDataPie data, _) => data.totalHours,
              dataLabelMapper: (ChartDataPie data, _) => "${data.percentage.toStringAsFixed(2)} %",
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]);
  }

  Widget generateZoneChart(context) {
    List<ChartDataZoneColored> chartData = Provider.of<ProviderWorkout>(context).generateZoneChartColored(null, null);
    List<ChartSeries> charts = [];

    chartData.first.data.toSet().toList().forEach((element) {
      charts.add(StackedColumnSeries<ChartDataZoneColored, String>(
        dataSource: chartData,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        xValueMapper: (ChartDataZoneColored data, _) => data.zoneType.name,
        yValueMapper: (ChartDataZoneColored data, _) => data.data.firstWhere((element2) => element2.workoutType == element.workoutType).workoutTypeHoursPerZone,
        dataLabelSettings: const DataLabelSettings(isVisible: true, showCumulativeValues: true),
        name: WorkoutTypeExtention.getStringPretty(element.workoutType),
        dataLabelMapper: (ChartDataZoneColored data, _) => (data.data.firstWhere((element2) => element2.workoutType == element.workoutType).workoutTypeHoursPerZone <= 0.4
            ? ""
            : (data.data.firstWhere((element2) => element2.workoutType == element.workoutType).workoutTypeHoursPerZone).toStringAsFixed(0)),
      ));
    });

    var val = true;
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(majorGridLines: MajorGridLines(width: 0)),
        //primaryYAxis: NumericAxis(),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        series: val
            ? charts
            : <ChartSeries>[
                ColumnSeries<ChartDataZoneColored, String>(
                    dataSource: Provider.of<ProviderWorkout>(context).generateZoneChartColored(null, null),
                    xValueMapper: (ChartDataZoneColored data, _) => data.zoneType.name,
                    yValueMapper: (ChartDataZoneColored data, _) => data.totalHours,
                    // Width of the columns
                    width: 0.8,
                    dataLabelMapper: (ChartDataZoneColored data, _) => "${(data.percentage * 100).toStringAsFixed(0)} %",
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                    ),
                    spacing: 0.2),
              ]);
  }
}
