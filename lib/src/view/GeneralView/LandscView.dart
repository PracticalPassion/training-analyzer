// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class LandscView extends StatelessWidget {
  PageController pageController;
  List<Widget> pages;
  int currentPage;
  Function(int) onchanged;

  late Size deviceSize;
  late double scaleY;

  LandscView({
    Key? key,
    required this.pageController,
    required this.pages,
    required this.currentPage,
    required this.onchanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            child: Row(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * .03,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List<Widget>.generate(pages.length, (int index) {
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    width: 10,
                    height: (index == currentPage) ? 30 : 10,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: (index == currentPage) ? CupertinoColors.activeBlue : CupertinoColors.activeBlue.withOpacity(0.3)));
              }),
            )),
        Expanded(
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: pageController,
            onPageChanged: onchanged,
            children: pages,
          ),
        ),
      ],
    )));
  }
}
