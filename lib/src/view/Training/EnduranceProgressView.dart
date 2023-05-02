import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/view/Training/EnduranceProgressChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class EnduranceProgressView extends StatefulWidget {
  EnduranceProgressView({Key? key}) : super(key: key);

  @override
  State<EnduranceProgressView> createState() => _EnduranceProgressViewState();
}

class _EnduranceProgressViewState extends State<EnduranceProgressView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height * (isPortrait ? .40 : 1),
              child: EnduranceProgressChart().generateZoneChart(context, Provider.of<ProviderWorkout>(context).currentSelectedWorkout),
            ),
            Text("", style: CupertinoTheme.of(context).textTheme.textStyle)
          ],
        ),
      ],
    );
  }
}
