// ignore_for_file: public_member_api_docs, sort_constructors_first
// Diese Klasse definiert die Datenstruktur für die Chart Daten.
import 'package:fitness_analyzer/src/model/Workouttype.dart';
import 'package:fitness_analyzer/src/model/Zone.dart';

class ChartData {
  final DateTime time;
  final int num;
  final double sales;

  ChartData(this.num, this.time, this.sales);
}

class ChartDataEnduranceProgress {
  final DateTime time;
  final int num;
  final double heartRate;
  final double speed;

  ChartDataEnduranceProgress(this.time, this.num, this.heartRate, this.speed);
}

class ChartDataPie {
  final WorkoutType type;
  final double totalHours;
  double percentage;
  ChartDataPie(this.type, this.totalHours, this.percentage);
}

class ChartDataZone {
  final String type;
  final double totalHours;
  double percentage;
  ChartDataZone(this.type, this.totalHours, this.percentage);
}

class ChartDataZoneColored {
  final ZoneType zoneType;
  final double totalHours;
  double percentage;
  List<ChartDataZoneWorkout> data;

  ChartDataZoneColored({
    required this.zoneType,
    required this.totalHours,
    required this.percentage,
    required this.data,
  });
}

class ChartDataZoneWorkout {
  final WorkoutType workoutType;
  final ZoneType zoneType;
  final double workoutTypeHoursPerZone;

  ChartDataZoneWorkout(this.workoutType, this.zoneType, this.workoutTypeHoursPerZone);
}
