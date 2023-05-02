import 'package:fitness_analyzer/src/view/Dashboard/Charts.dart';
import 'package:flutter/cupertino.dart';

class ZoneView extends StatefulWidget {
  ZoneView({Key? key}) : super(key: key);

  @override
  State<ZoneView> createState() => _ZoneViewState();
}

class _ZoneViewState extends State<ZoneView> {
  Charts chart = Charts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text("Time spend within different Zones"),
        ),
        Container(child: chart.generateZoneChart(context))
      ],
    );
  }
}
