import 'package:fitness_analyzer/src/view/Dashboard/Charts.dart';
import 'package:flutter/cupertino.dart';

class Anteile extends StatefulWidget {
  Anteile({Key? key}) : super(key: key);

  @override
  State<Anteile> createState() => _AnteileState();
}

class _AnteileState extends State<Anteile> {
  Charts chart = Charts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text("Percentage of spend time on Training types"),
        ),
        Container(child: chart.getPieChart(context))
      ],
    );
  }
}
