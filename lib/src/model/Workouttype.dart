import 'package:fitness_analyzer/src/model/WokroutSubtype.dart';

enum WorkoutType { other, running, walking, cycling, strengthTraining }

class WorkoutTypeString {
  static const String cycling = "HKWorkoutActivityTypeCycling";
  static const String running = "HKWorkoutActivityTypeRunning";
}

extension WorkoutTypeExtention on WorkoutType {
  static WorkoutType getVal(String str) {
    switch (str) {
      case WorkoutTypeString.running:
        return WorkoutType.running;
      case "HKWorkoutActivityTypeWalking":
        return WorkoutType.walking;
      case "HKWorkoutActivityTypeTraditionalStrengthTraining":
        return WorkoutType.strengthTraining;
      case "HKWorkoutActivityTypeFunctionalStrengthTraining":
        return WorkoutType.strengthTraining;
      case WorkoutTypeString.cycling:
        return WorkoutType.cycling;
      default:
        return WorkoutType.other;
    }
  }

  static TrainingType getTryiningType(WorkoutType type) {
    switch (type) {
      case WorkoutType.running:
        return TrainingType.endurance;
      case WorkoutType.cycling:
        return TrainingType.endurance;
      case WorkoutType.strengthTraining:
        return TrainingType.strength;
      case WorkoutType.walking:
        return TrainingType.other;
      case WorkoutType.other:
        return TrainingType.other;
      default:
        return TrainingType.other;
    }
  }

  static String getString(WorkoutType type) {
    switch (type) {
      case WorkoutType.running:
        return WorkoutTypeString.running;
      case WorkoutType.walking:
        return "HKWorkoutActivityTypeWalking";
      case WorkoutType.strengthTraining:
        return "HKWorkoutActivityTypeTraditionalStrengthTraining";
      case WorkoutType.cycling:
        return WorkoutTypeString.cycling;
      default:
        return "other";
    }
  }

  static String getStringPretty(WorkoutType type) {
    switch (type) {
      case WorkoutType.running:
        return "Running";
      case WorkoutType.walking:
        return "Walking";
      case WorkoutType.strengthTraining:
        return "Strength Tarining";
      case WorkoutType.cycling:
        return "Cycling";
      default:
        return "other";
    }
  }

  static int getIndex(WorkoutType type) {
    switch (type) {
      case WorkoutType.running:
        return 0;
      case WorkoutType.walking:
        return 1;
      case WorkoutType.strengthTraining:
        return 2;
      case WorkoutType.cycling:
        return 3;
      default:
        return 10;
    }
  }

  static WorkoutType getIndexedType(int index) {
    switch (index) {
      case 0:
        return WorkoutType.running;
      case 1:
        return WorkoutType.cycling;
      case 2:
        return WorkoutType.walking;
      case 3:
        return WorkoutType.strengthTraining;
      default:
        return WorkoutType.other;
    }
  }

  static List<WorkoutType> getEnduranceValue() {
    return [WorkoutType.running, WorkoutType.cycling];
  }
}
