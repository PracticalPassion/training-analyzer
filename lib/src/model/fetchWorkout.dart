import 'package:health/health.dart';
import 'package:fitness_analyzer/src/model/Workout.dart';

class WorkoutDataFetcher {
  /*
  List<Workout?> workouts = [];

  WorkoutDataFetcher() {
    getInitData();
  }

  getInitData() async {
    workouts = await fetchWorkoutData();
  }

  Future<List<Workout?>> fetchWorkoutData() async {
    final permissions = <HealthDataType>[
      HealthDataType.WORKOUT,
    ];

    // request authorization to access health data
    final healthData = HealthFactory();

    if (await healthData.requestAuthorization(permissions)) throw Exception('Authorization not granted');

    final results = await healthData.getHealthDataFromTypes(
      DateTime.now().subtract(Duration(days: 30)),
      DateTime.now(),
      [HealthDataType.WORKOUT],
    );

    final workoutData = results.map((result) {
      final Map<String, dynamic> workoutValueMap = result.value as Map<String, dynamic>;
      final workoutType = workoutValueMap['type'];
      final startTime = DateTime.fromMillisecondsSinceEpoch(workoutValueMap['date_from'] * 1000);
      final endTime = DateTime.fromMillisecondsSinceEpoch(workoutValueMap['date_to'] * 1000);
      final caloriesBurned = workoutValueMap['energy']?.toDouble() ?? 0;
      final distance = workoutValueMap['distance']?.toDouble() ?? 0;
      final duration = (endTime.difference(startTime).inSeconds / 60).toDouble();
/*
      if (workoutType == 'Running') {
        final pace = workoutValueMap['average_speed']?.toDouble() ?? 0;
        return Running(
          workoutType: "Running",
          startTime: startTime,
          endTime: endTime,
          caloriesBurned: caloriesBurned,
          distance: distance,
          duration: duration,
          pace: pace,
        );
      } else if (workoutType == 'Walking') {
        final pace = workoutValueMap['average_speed']?.toDouble() ?? 0;
        return Walking(
          workoutType: "Walking",
          startTime: startTime,
          endTime: endTime,
          caloriesBurned: caloriesBurned,
          distance: distance,
          duration: duration,
          pace: pace,
        );
      } else if (workoutType == 'Cycling') {
        final averageSpeed = workoutValueMap['average_speed']?.toDouble() ?? 0;
        return Cycling(workoutType: "Cycling", startTime: startTime, endTime: endTime, caloriesBurned: caloriesBurned, distance: distance, duration: duration, averageSpeed: averageSpeed);
      }
*/
    }).toList();
    return workoutData;
  }*/
}
