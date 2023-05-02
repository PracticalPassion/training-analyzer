import 'package:fitness_analyzer/src/view/Dashboard/Charts.dart';
import 'package:flutter/cupertino.dart';

class Trend extends StatefulWidget {
  Trend({Key? key}) : super(key: key);

  @override
  State<Trend> createState() => _TrendState();
}

class _TrendState extends State<Trend> {
  Charts chart = Charts();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text("Overall time in hours per Week"), //TODO week ggf in Tag ändern
        ),
        SizedBox(height: MediaQuery.of(context).size.height * (MediaQuery.of(context).orientation != Orientation.portrait ? .9 : .40), child: chart.getTrandChart(context))
      ],
    );
  }
}
