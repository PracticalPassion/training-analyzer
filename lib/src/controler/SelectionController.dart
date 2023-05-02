import 'package:flutter/cupertino.dart';

class SelectionController with ChangeNotifier {
  int _theriGroupValue = 0;
  int get theirGroupValue => _theriGroupValue;
  set theirGroupValue(changeFromGroupValue) {
    _theriGroupValue = changeFromGroupValue;
    notifyListeners();
  }

  final Map<int, Widget> _menueWidgets = const <int, Widget>{0: Text("3 Month"), 1: Text("6 Month")};
  Map<int, Widget> get menueWidget => _menueWidgets;
}
