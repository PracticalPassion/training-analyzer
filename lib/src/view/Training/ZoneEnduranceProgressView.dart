import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/view/Training/EnduranceProgressChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ZoneEnduranceProgressView extends StatefulWidget {
  ZoneEnduranceProgressView({Key? key}) : super(key: key);

  @override
  State<ZoneEnduranceProgressView> createState() => _ZoneEnduranceProgressViewState();
}

class _ZoneEnduranceProgressViewState extends State<ZoneEnduranceProgressView> {
  late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Column(
      children: [
        isPortrait
            ? SizedBox(
                height: MediaQuery.of(context).size.height * .40,
                child: EnduranceProgressChart().getChart(context, Provider.of<ProviderWorkout>(context).currentSelectedWorkout, _zoomPanBehavior),
              )
            : SizedBox(
                child: EnduranceProgressChart().getChart(context, Provider.of<ProviderWorkout>(context).currentSelectedWorkout, _zoomPanBehavior),
              ),
        Text(
          "Nice Stuff, your heart rate ist going down, while your pace is gioing up. Good progress!",
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 13),
        )
      ],
    );
  }
}
