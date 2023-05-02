import 'dart:convert';
import 'dart:io';
import 'package:fitness_analyzer/src/model/Workout.dart';
import 'package:fitness_analyzer/src/model/Workouttype.dart';
import 'package:xml/xml.dart';
import 'package:path_provider/path_provider.dart';

class XMLWorkoutFetcher {
  //List<Workout?> workouts = [];
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<Workout>> convertFromXML() async {
    List<Workout> data = [];
    // Lese die exportierte XML-Datei ein
    String str = await _localPath;
    final xmlString = File('$str/assets/Export2.xml').readAsStringSync();

    // Parsen der XML-Datei und Extrahieren der Workouts
    final document = XmlDocument.parse(xmlString);

    final workouts = document.findAllElements('Workout');

    for (final workout in workouts) {
      if (workout.findAllElements("MetadataEntry").where((element) => element.getAttribute("key") == "HKIndoorWorkout" && element.getAttribute("value") == "1").isNotEmpty) {
        print("inddor");
        continue;
      }
      data.add(Workout.fromXML(workout));
    }
    return data;
  }
}
