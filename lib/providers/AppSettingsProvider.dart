import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  bool _useLocalData = false;

  bool get useLocalData => _useLocalData;

  set useLocalData(bool value) {
    if (_useLocalData != value) {
      _useLocalData = value;
      notifyListeners();
    }
  }
}