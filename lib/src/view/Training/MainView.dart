import 'dart:async';
import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/model/Workouttype.dart';
import 'package:fitness_analyzer/src/view/GeneralView/LandscView.dart';
import 'package:fitness_analyzer/src/view/Training/EnduranceProgressView.dart';
import 'package:fitness_analyzer/src/view/Training/ViewControllerTraining.dart';
import 'package:fitness_analyzer/src/view/Training/ZoneEnduranceProgressView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Helper/Utils.dart';

class MainView extends StatefulWidget {
  MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late ZoomPanBehavior _zoomPanBehavior;

  List<Widget> widgets() {
    return [
      ZoneEnduranceProgressView(),
      EnduranceProgressView(),
    ];
  }

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
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text("Detailed Training Analysis")),
        child: !context.watch<ProviderWorkout>().loading
            ? !isPortrait
                ? LandscView(
                    pageController: Provider.of<ViewControllerTraining>(context).pageController,
                    pages: Provider.of<ViewControllerTraining>(context).pages,
                    currentPage: Provider.of<ViewControllerTraining>(context).currentPage,
                    onchanged: Provider.of<ViewControllerTraining>(context).onchanged,
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: ListView(
                      children: [
                        isPortrait
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(alignment: Alignment.centerLeft, child: Text("Current Selected Workout Type:", style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle)),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: CupertinoButton(
                                        padding: const EdgeInsets.fromLTRB(0, 5, 5, 10),
                                        child: Text(WorkoutTypeExtention.getStringPretty(Provider.of<ProviderWorkout>(context).currentSelectedWorkout)),
                                        onPressed: () => Utils.showSheet(
                                          context,
                                          child: buildCustomPicker(context),
                                          onClicked: () {
                                            Provider.of<ProviderWorkout>(context, listen: false).currentSelectedWorkout =
                                                WorkoutTypeExtention.getIndexedType(Provider.of<ProviderWorkout>(context, listen: false).indexSelectedWorkout);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      )),
                                ],
                              )
                            : Container(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widgets().length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(shape: BoxShape.rectangle, border: Border.all(width: .5, color: CupertinoColors.systemGrey), borderRadius: BorderRadius.circular(5)),
                                    child: widgets().elementAt(index)),
                                const SizedBox(height: 15)
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
            : const Center(child: CupertinoActivityIndicator()));
  }
}

Widget buildCustomPicker(context) => SizedBox(
      height: 200,
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: Provider.of<ProviderWorkout>(context, listen: false).indexSelectedWorkout),
        itemExtent: 60,
        diameterRatio: 0.8,
        onSelectedItemChanged: (index) {
          Provider.of<ProviderWorkout>(context, listen: false).indexSelectedWorkout = index;
        },
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: Colors.grey.withOpacity(0.12),
        ),
        children: Utils.modelBuilder<WorkoutType>(
          WorkoutTypeExtention.getEnduranceValue(),
          (index, value) {
            final color = Provider.of<ProviderWorkout>(context, listen: false).indexSelectedWorkout == index ? CupertinoColors.activeBlue : CupertinoColors.black;
            return Center(
              child: Text(
                WorkoutTypeExtention.getStringPretty(value),
                style: TextStyle(color: color, fontSize: 24),
              ),
            );
          },
        ),
      ),
    );
