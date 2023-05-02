import 'package:fitness_analyzer/src/view/Dashboard/Dashboard.dart';
import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/view/Training/MainView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int pageIndex = 0;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      Provider.of<ProviderWorkout>(context).initData();
      loaded = true;
    }
  }

  List<Widget> pagelist() {
    return [
      Dashboard(),
      MainView()
      // Training(),
      // Settings()
    ];
  }

  List<BottomNavigationBarItem> navBarItems() {
    return const [
      BottomNavigationBarItem(
          icon: Icon(
            CupertinoIcons.chart_bar,
          ),
          label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.bolt_horizontal), label: 'Training'),
      // BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings), label: 'Settings')
    ];
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        body: SafeArea(child: pagelist()[pageIndex]),
        bottomNavigationBar: isPortrait
            ? BottomNavigationBar(
                currentIndex: pageIndex,
                onTap: (value) {
                  setState(() {
                    pageIndex = value;
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: navBarItems(),
              )
            : Container(
                height: 0,
              ));
  }
}
