import 'package:fitness_analyzer/src/view/Dashboard/Anteile.dart';
import 'package:fitness_analyzer/src/view/Dashboard/Trend.dart';
import 'package:flutter/cupertino.dart';

import 'ZoneView.dart';

class PageControllerLanscape with ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final PageController _controller = PageController();
  PageController get pageController => _controller;

  final List<Widget> _pages = [Anteile(), Trend(), ZoneView()];
  List<Widget> get pages => _pages;

  onchanged(int index) {
    _currentPage = index;
    //resetData(true);
    notifyListeners();
  }
}
