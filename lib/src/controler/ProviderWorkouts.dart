import 'package:fitness_analyzer/src/model/ChartData.dart';
import 'package:fitness_analyzer/src/model/WokroutSubtype.dart';
import 'package:fitness_analyzer/src/model/Workout.dart';
import 'package:fitness_analyzer/src/model/Workouttype.dart';
import 'package:fitness_analyzer/src/model/Zone.dart';
import 'package:fitness_analyzer/src/model/fetchWorkoutXML.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:core';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ProviderWorkout with ChangeNotifier {
  List<Workout> workouts = [];
  bool loading = true;

  int _indexSelectedWorkout = 0;
  int get indexSelectedWorkout => _indexSelectedWorkout;
  set indexSelectedWorkout(newIndex) {
    _indexSelectedWorkout = newIndex;
    notifyListeners();
  }

  WorkoutType _currentSelectedWorkout = WorkoutType.running;
  WorkoutType get currentSelectedWorkout => _currentSelectedWorkout;
  set currentSelectedWorkout(WorkoutType val) {
    _currentSelectedWorkout = val;
    notifyListeners();
  }

  // default value
  DateTime _dateFrom = Jiffy().subtract(months: 90).dateTime;
  DateTime get dateFrom => _dateFrom;
  set dateFrom(DateTime val) {
    _dateFrom = val;
    notifyListeners();
  }

  //DateTime dateFrom = DateTime.now().subtract(Duration(days: 180));
  bool testLo = true;
  int _selectedPeriodIndex = 3;
  int get selectedPeriodIndex => _selectedPeriodIndex;
  set selectedPeriodIndex(val) {
    _selectedPeriodIndex = val;
    changeDate();
    notifyListeners();
  }

  final Map<int, Widget> _periodWidgets = const <int, Widget>{
    3: Text("All"),
    2: Text("6 Month"),
    1: Text("1 Month"),
    0: Text("Week"),
  };
  Map<int, Widget> get periodWidgets => _periodWidgets;

  changeDate() {
    int weeks = 0;
    int num = 90;
    if (_selectedPeriodIndex == 0) {
      num = 0;
      weeks = 1;
    }
    if (_selectedPeriodIndex == 1) num = 1;
    if (_selectedPeriodIndex == 2) num = 6;
    dateFrom = Jiffy().subtract(months: num, weeks: weeks).dateTime;
    notifyListeners();
  }

  Future initData() async {
    loading = true;
    workouts = await XMLWorkoutFetcher().convertFromXML();
    loading = false;
    notifyListeners();
  }

  List<ChartDataEnduranceProgress> genDataEnduranceProgress(WorkoutType type) {
    List<ChartDataEnduranceProgress> list = [];
    int i = 0;
    for (var element in workouts.where((element) => element.workoutType == type)) {
      switch (type) {
        case WorkoutType.cycling:
          Cycling cycling = element.subtype as Cycling;
          list.add(ChartDataEnduranceProgress(element.creationDate, i, cycling.avarageHeartRate.toDouble(), cycling.averageSpeed));
          i++;
          break;
        case WorkoutType.running:
          Running running = element.subtype as Running;
          list.add(ChartDataEnduranceProgress(element.creationDate, i, running.avarageHeartRate.toDouble(), running.pace.inSeconds.toDouble() / 60));
          i++;
          break;
        default:
      }
    }
    return list;
  }

  //TODO ggf funktion für chart ersetzen
  List<ChartDataZone> generateZoneChart(List<WorkoutType>? type, DateTime? givenDate) {
    List<ChartDataZone> list = [];
    List<double> zoneValues = [0, 0, 0, 0, 0];
    List<WorkoutType> values = type ?? WorkoutType.values.map((e) => e).toList();

    for (var workouttype in values) {
      for (var element in workouts) {
        // run loop for each type
        if (workouttype != element.workoutType) continue;
        // if not endurance, skip
        if (element.subtype.type != TrainingType.endurance) continue;
        // dont add Data, which is bevore selected Date
        if (element.creationDate.isBefore(givenDate ?? dateFrom)) continue;

        switch (element.subtype.zone) {
          case ZoneType.zone1:
            zoneValues[0] += element.duration;
            break;
          case ZoneType.zone2:
            zoneValues[1] += element.duration;
            break;
          case ZoneType.zone3:
            zoneValues[2] += element.duration;
            break;
          case ZoneType.zone4:
            zoneValues[3] += element.duration;
            break;
          case ZoneType.zone5:
            zoneValues[4] += element.duration;
            break;
          default:
            break;
        }
      }
    }
    double sum = zoneValues.sum;
    zoneValues.forEachIndexed((index, element) {
      list.add(ChartDataZone(ZoneTypeExtention.getStringFromList(index), element / 60, element / sum));
    });
    return list;
  }

  List<ChartDataZoneColored> generateZoneChartColored(List<WorkoutType>? type, DateTime? givenDate) {
    List<ChartDataZoneColored> list = [];
    List<double> zoneValues = [0, 0, 0, 0, 0];
    List<WorkoutType> values = type ?? WorkoutType.values.map((e) => e).toList();
    double overallSum = 0;
    List<ChartDataZoneWorkout> listPerWorkouttype = [];

    for (var workouttype in values) {
      if (WorkoutTypeExtention.getTryiningType(workouttype) != TrainingType.endurance) continue;
      //for (var element in workouts.where((element) => element.workoutType == workouttype)) {
      for (var element in workouts) {
        // if not endurance, skip
        if (workouttype != element.workoutType) continue;
        // dont add Data, which is bevore selected Date
        if (element.creationDate.isBefore(givenDate ?? dateFrom)) continue;

        switch (element.subtype.zone) {
          case ZoneType.zone1:
            zoneValues[0] += element.duration;
            break;
          case ZoneType.zone2:
            zoneValues[1] += element.duration;
            break;
          case ZoneType.zone3:
            zoneValues[2] += element.duration;
            break;
          case ZoneType.zone4:
            zoneValues[3] += element.duration;
            break;
          case ZoneType.zone5:
            zoneValues[4] += element.duration;
            break;
          default:
            break;
        }
        overallSum += zoneValues.sum;
      }

      zoneValues.forEachIndexed((index, element) {
        listPerWorkouttype.add(ChartDataZoneWorkout(workouttype, ZoneTypeExtention.getValueFromList(index), element / 60));
      });
      zoneValues = [0, 0, 0, 0, 0];
    }

    for (int i = 0; i < 5; i++) {
      double sum =
          listPerWorkouttype.where((element) => element.zoneType == ZoneTypeExtention.getValueFromList(i)).map((expense) => expense.workoutTypeHoursPerZone).fold(0, (prev, amount) => prev + amount);

      list.add(ChartDataZoneColored(
          zoneType: ZoneTypeExtention.getValueFromList(i),
          totalHours: sum,
          percentage: sum / overallSum * 100,
          data: listPerWorkouttype.where((element) => element.zoneType == ZoneTypeExtention.getValueFromList(i)).toList()));
    }
    return list;
  }

  List<ChartDataPie> generatePiedashboard() {
    double typeDuration = 0;
    List<ChartDataPie> list = [];

    for (var workouttype in WorkoutType.values) {
      for (var element in workouts) {
        // run loop for each type
        if (workouttype != element.workoutType) continue;

        // dont add Data, which is bevore selected Date
        if (element.creationDate.isBefore(dateFrom)) continue;

        // same week, add data
        typeDuration += element.duration;
      }
      if (typeDuration == 0) continue;
      // not same Week anymore, set data and reset variable
      list.add(ChartDataPie(workouttype, typeDuration / 60, 0));
      // set new Week
      typeDuration = 0;
    }
    double sum = 0;
    for (var element in list) {
      sum += element.totalHours;
    }
    for (var element in list) {
      element.percentage = element.totalHours / sum * 100;
    }
    return list;
  }

  static int drop = 1;
  List<ChartData> generateDashTrend() {
    // Format:
    // 6 Month and Weeks
    // All in Weeks
    // 3 Month in Weeks
    // 1 Month in Days
    // 1 Week in Days

    List<ChartData> list = [];
    int? week;
    DateTime? day;
    double durationSum = 0;
    int weekNumVariable = 0;
    DateTime? currentDate;

    for (var element in workouts) {
      // dont add Data, which is bevore selected Date
      if (element.creationDate.isBefore(dateFrom)) continue;

      // Week Format: weekNumber
      // Week Format: compareDay
      day ??= element.creationDate;
      week ??= weekNumber(element.creationDate);
      currentDate ??= element.creationDate;

      if (_selectedPeriodIndex <= drop ? currentDate.isSameDate(day) : week == weekNumber(element.creationDate)) {
        // same week, add data
        durationSum += element.duration;
        _selectedPeriodIndex <= drop ? null : weekNumVariable = week;
        currentDate = element.creationDate;
      } else {
        // not same Week/day anymore, set data and reset variable
        list.add(ChartData(weekNumVariable, currentDate, durationSum / 60));
        durationSum = 0;

        // set new Week/Day
        day = currentDate;
        _selectedPeriodIndex <= drop ? weekNumVariable++ : week = weekNumber(element.creationDate);
      }
    }
    return list;
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  /// returned:
  ///
  /// if [ChartData]: return one ChartSet
  ///
  /// if [ChartDataEnduranceProgress]: return two ChartSet:
  ///
  ///    1.: speed
  ///
  ///    2.: heartRate
  List<List<ChartData>> generateRegression(
    List<dynamic> raw,
  ) {
    int i = 0;
    List<List<ChartData>> rootData = [];
    List<ChartData> retdata = [];
    // generate differend Lits, depending on ChartData (sales) or ChartDataEnduranceProgress (heartRate, speed)
    if (raw is List<ChartData>) {
      final reg = linearRegression(raw.map((e) => e.num).toList(), raw.map((e) => e.sales).toList(), raw.length);
      double a = (reg[0] * raw.first.num + reg[1]);
      retdata.add(ChartData(raw.first.num, raw.first.time, a));
      a = (reg[0] * raw.last.num + reg[1]);
      retdata.add(ChartData(raw.last.num, raw.last.time, a));
      // for (var element in raw) {
      //   double a = (reg[0] * i + reg[1]);
      //   retdata.add(ChartData(i, element.time, a));
      //   i++;
      // }
      rootData.add(retdata);
    } else if (raw is List<ChartDataEnduranceProgress>) {
      var reg = linearRegression(raw.map((e) => e.num).toList(), raw.map((e) => e.speed).toList(), raw.length);

      // only two Data points?
      double a = (reg[0] * raw.first.num + reg[1]);
      retdata.add(ChartData(raw.first.num, raw.first.time, a));
      a = (reg[0] * raw.last.num + reg[1]);
      retdata.add(ChartData(raw.last.num, raw.last.time, a));

      // for (var element in raw) {
      //   double a = (reg[0] * i + reg[1]);
      //   retdata.add(ChartData(i, element.time, a));
      //   i++;
      // }

      rootData.add(retdata.toList());
      retdata.clear();
      reg.clear();
      i = 0;
      reg = linearRegression(raw.map((e) => e.num).toList(), raw.map((e) => e.heartRate).toList(), raw.length);
      a = (reg[0] * raw.first.num + reg[1]);
      retdata.add(ChartData(raw.first.num, raw.first.time, a));
      a = (reg[0] * raw.last.num + reg[1]);
      retdata.add(ChartData(raw.last.num, raw.last.time, a));
      // for (var element in raw) {
      //   double a = (reg[0] * i + reg[1]);
      //   retdata.add(ChartData(i, element.time, a));
      //   i++;
      // }
      rootData.add(retdata);
    } else {
      throw UnimplementedError("Error while generating Regression. Type not supported");
    }
    return rootData;
  }

  List linearRegression(List<int> xdata, List<double> ydata, int length) {
    double xAverage = xdata.average;
    double yAvarage = ydata.average;

    double prodData = 0;
    double xSquare = 0;

    for (int i = 0; i < length; i++) {
      prodData += (ydata[i] - yAvarage) * (xdata[i] - xAverage);
      xSquare += pow((xdata[i] - xAverage), 2);
    }
    var steigung = prodData / xSquare;
    var offset = yAvarage - steigung * xAverage;

    return [steigung, offset];
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
