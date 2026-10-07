import 'package:flutter/cupertino.dart';

class TodoStateProvider extends ChangeNotifier {
  void refreshList() {
    notifyListeners();
  }
}

