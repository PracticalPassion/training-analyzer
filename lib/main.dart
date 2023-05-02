import 'dart:core';
import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/view/Dashboard/PageControllerLanscape.dart';
import 'package:fitness_analyzer/src/view/Front.dart';
import 'package:fitness_analyzer/src/view/Training/ViewControllerTraining.dart';
import 'package:provider/provider.dart';
import 'package:fitness_analyzer/src/model/fetchWorkoutXML.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final appDir = await path_provider.getApplicationDocumentsDirectory();
  //Hive.init(appDir.path);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProviderWorkout()),
    ChangeNotifierProvider(create: (_) => PageControllerLanscape()),
    ChangeNotifierProvider(create: (_) => ViewControllerTraining())
  ], child: FZG()));
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class FZG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      return MaterialApp(
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: "/",
        navigatorKey: navigatorKey,
        routes: {"/": ((context) => MyApp())},
        // theme: CustomTheme.lightTheme,
        title: "Traing Analyzer",
      );
    } on Exception catch (_) {
      throw UnimplementedError();
    }
  }
}
