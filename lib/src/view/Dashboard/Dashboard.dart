import 'dart:async';

import 'package:fitness_analyzer/src/controler/ProviderWorkouts.dart';
import 'package:fitness_analyzer/src/view/Dashboard/Anteile.dart';
import 'package:fitness_analyzer/src/view/Dashboard/PageControllerLanscape.dart';
import 'package:fitness_analyzer/src/view/GeneralView/LandscView.dart';
import 'package:fitness_analyzer/src/view/Dashboard/Trend.dart';
import 'package:fitness_analyzer/src/view/Dashboard/ZoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> widgets() {
    return [
      ZoneView(),
      Anteile(),
      Trend(),
    ];
  }

  // TODO: initState aufrufen - > Zeitraum passt beim ersten aufrufen nicht

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text("Dashboard")),
        child: !context.watch<ProviderWorkout>().loading
            ? MediaQuery.of(context).orientation != Orientation.portrait
                ? LandscView(
                    pageController: context.watch<PageControllerLanscape>().pageController,
                    pages: context.watch<PageControllerLanscape>().pages,
                    currentPage: context.watch<PageControllerLanscape>().currentPage,
                    onchanged: context.watch<PageControllerLanscape>().onchanged,
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: ListView(
                      children: [
                        Provider.of<ProviderWorkout>(context).testLo == false
                            ? const SizedBox(
                                height: 40,
                              )
                            : Container(),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: CupertinoSlidingSegmentedControl<int>(
                                groupValue: Provider.of<ProviderWorkout>(context).selectedPeriodIndex,
                                onValueChanged: (changeFromGroupValue) {
                                  Provider.of<ProviderWorkout>(context, listen: false).selectedPeriodIndex = changeFromGroupValue;
                                },
                                children: Provider.of<ProviderWorkout>(context).periodWidgets,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                    ),
                  )
            : const Center(child: CupertinoActivityIndicator()));
  }
}
