import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SwitchProvider extends ChangeNotifier {
  String _response = '';
  String _response2 = '';
  String _response3 = '';
  bool _isFeatureEnabled = false;
  bool _isFeatureEnabled1 = false;
  bool _isFeatureEnabled2 = false;
  final Guid _uuidWrite = Guid("d8520577-81ed-478c-a3ad-a810d65c064a");

  String get response => _response;
  
  set response(String newResponse) {
    _response = newResponse;
    notifyListeners();
  }

  String get response2 => _response2;

  set response2(String newResponse2) {
    _response2 = newResponse2;
    notifyListeners();
  }

  String get response3 => _response3;

  set response3(String newResponse3) {
    _response3 = newResponse3;
    notifyListeners();
  }

  bool get isFeatureEnabled => _isFeatureEnabled;

  set isFeatureEnabled(bool newValue) {
    _isFeatureEnabled = newValue;
    notifyListeners();
  }

  bool get isFeatureEnabled1 => _isFeatureEnabled1;

  set isFeatureEnabled1(bool newValue) {
    _isFeatureEnabled1 = newValue;
    notifyListeners();
  }

  bool get isFeatureEnabled2 => _isFeatureEnabled2;

  set isFeatureEnabled2(bool newValue) {
    _isFeatureEnabled2 = newValue;
    notifyListeners();
  }

  Guid get uuidWrite => _uuidWrite;

}
