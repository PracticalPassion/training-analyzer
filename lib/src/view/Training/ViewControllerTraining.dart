import 'package:fitness_analyzer/src/view/Training/EnduranceProgressView.dart';
import 'package:fitness_analyzer/src/view/Training/ZoneEnduranceProgressView.dart';
import 'package:flutter/cupertino.dart';

class ViewControllerTraining with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final PageController _controller = PageController();
  PageController get pageController => _controller;

  final List<Widget> _pages = [
    ZoneEnduranceProgressView(),
    EnduranceProgressView(),
  ];
  List<Widget> get pages => _pages;

  onchanged(int index) {
    _currentPage = index;
    //resetData(true);
    notifyListeners();
  }
}
