// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fitness_analyzer/src/model/Zone.dart';
import 'package:xml/xml.dart';

import 'package:fitness_analyzer/src/model/ChartData.dart';

enum TrainingType { endurance, strength, other }

abstract class WorkoutSubType {
  TrainingType type;
  ZoneType zone;

  WorkoutSubType({
    required this.type,
    required this.zone,
  });
}

class Nothing extends WorkoutSubType {
  Nothing() : super(type: TrainingType.other, zone: ZoneType.noZone);
}

class Running extends WorkoutSubType {
  Duration pace;
  double distance;
  int caloriesBurned;
  int avarageHeartRate;
  int maxHeartRate;
  int minHeartRate;
  static String distanceIdent = "HKQuantityTypeIdentifierDistanceWalkingRunning";

  Running({required this.pace, required this.distance, required this.caloriesBurned, required this.avarageHeartRate, required this.maxHeartRate, required this.minHeartRate, required zone})
      : super(type: TrainingType.endurance, zone: zone);

  static Running fromXML(XmlElement workoutRaw) {
    int minute = double.parse(workoutRaw.getAttribute('duration') ?? "0") ~/
        double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == distanceIdent).first.getAttribute("sum") ?? "0");

    int second = ((double.parse(workoutRaw.getAttribute('duration') ?? "0") /
                    double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == distanceIdent).first.getAttribute("sum") ?? "0") -
                minute) *
            60)
        .toInt();

    return Running(
        caloriesBurned:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierActiveEnergyBurned").first.getAttribute("sum") ?? "0")
                .toInt(),
        distance: double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == distanceIdent).first.getAttribute("sum") ?? "0"),
        pace: Duration(minutes: minute, seconds: second),
        avarageHeartRate:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("average") ?? "0")
                .toInt(),
        maxHeartRate:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("maximum") ?? "0")
                .toInt(),
        minHeartRate:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("minimum") ?? "0")
                .toInt(),
        zone: ZoneTypeExtention.getVal(
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("average") ?? "0")
                .toInt()));
  }
}

class Walking extends WorkoutSubType {
  double pace;
  double distance;
  int caloriesBurned;
  int avarageHeartRate;
  int maxHeartRate;
  int minHeartRate;

  @override
  TrainingType type = TrainingType.other;

  Walking({
    required this.distance,
    required this.caloriesBurned,
    required this.pace,
    required this.avarageHeartRate,
    required this.maxHeartRate,
    required this.minHeartRate,
  }) : super(type: TrainingType.other, zone: ZoneType.noZone);
}

class Strength extends WorkoutSubType {
  int caloriesBurned;
  int avarageHeartRate;
  int maxHeartRate;
  int minHeartRate;

  Strength({
    required this.caloriesBurned,
    required this.avarageHeartRate,
    required this.maxHeartRate,
    required this.minHeartRate,
  }) : super(type: TrainingType.strength, zone: ZoneType.noZone);
}

class Cycling extends WorkoutSubType {
  double averageSpeed;
  double pace;
  double distance;
  static String distanceIdent = "HKQuantityTypeIdentifierDistanceCycling";
  int caloriesBurned;
  int avarageHeartRate;
  int maxHeartRate;
  int minHeartRate;

  Cycling(
      {required this.caloriesBurned,
      required this.distance,
      required this.averageSpeed,
      required this.pace,
      required this.avarageHeartRate,
      required this.maxHeartRate,
      required this.minHeartRate,
      required zone})
      : super(type: TrainingType.endurance, zone: zone);

  static Cycling fromXML(XmlElement workoutRaw) {
    return Cycling(
        caloriesBurned:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierActiveEnergyBurned").first.getAttribute("sum") ?? "0")
                .toInt(),
        distance: double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == distanceIdent).first.getAttribute("sum") ?? "0"),
        averageSpeed: 60 /
            double.parse(workoutRaw.getAttribute('duration') ?? "0") *
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == distanceIdent).first.getAttribute("sum") ?? "0"),
        pace: 0,
        avarageHeartRate:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("average") ?? "0")
                .toInt(),
        maxHeartRate:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("maximum") ?? "0")
                .toInt(),
        minHeartRate:
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("minimum") ?? "0")
                .toInt(),
        zone: ZoneTypeExtention.getVal(
            double.parse(workoutRaw.findElements("WorkoutStatistics").where((element) => element.getAttribute("type") == "HKQuantityTypeIdentifierHeartRate").first.getAttribute("average") ?? "0")
                .toInt()));
  }
}
