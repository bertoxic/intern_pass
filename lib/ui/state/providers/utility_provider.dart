import 'package:flutter/foundation.dart';

class UtilityProvider extends ChangeNotifier {
  bool _dropdownValue=false;

  bool get dropdownValue => _dropdownValue;

  void setDropdownValue(bool newValue) {
    _dropdownValue = newValue;
    notifyListeners();
  }
}
