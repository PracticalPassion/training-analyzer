import 'package:fitness_analyzer/src/model/WokroutSubtype.dart';
import 'package:fitness_analyzer/src/model/Workouttype.dart';
import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';
import 'package:xml/xml.dart';

class Workout {
  final WorkoutType workoutType;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime creationDate;
  final double duration;
  final WorkoutSubType subtype;

  Workout({
    required this.workoutType,
    required this.startTime,
    required this.endTime,
    required this.creationDate,
    required this.duration,
    required this.subtype,
  });

  static Workout fromXML(XmlElement workoutRaw) {
    WorkoutSubType type = Nothing();

    switch (workoutRaw.getAttribute('workoutActivityType')) {
      case WorkoutTypeString.cycling:
        type = Cycling.fromXML(workoutRaw);
        break;
      case WorkoutTypeString.running:
        type = Running.fromXML(workoutRaw);
        break;
      default:
    }

    return Workout(
        workoutType: WorkoutTypeExtention.getVal(workoutRaw.getAttribute('workoutActivityType') ?? ""),
        duration: double.parse(workoutRaw.getAttribute('duration') ?? "0"),
        startTime: DateTime.parse(workoutRaw.getAttribute('startDate') ?? "0"),
        endTime: DateTime.parse(workoutRaw.getAttribute('endDate') ?? "0"),
        creationDate: DateTime.parse(workoutRaw.getAttribute('creationDate') ?? "0"),
        subtype: type);
  }
}
