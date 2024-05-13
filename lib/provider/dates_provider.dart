import 'package:flutter/material.dart';

class DatesProvider extends ChangeNotifier {
  late DateTime _toDate;
  late DateTime _fromDate;

  DateTime get toDate => _toDate;

  set toDate(DateTime newToDate) {
    _toDate = newToDate;
    notifyListeners(); 
  }

  DateTime get fromDate => _fromDate;
  set fromDate(DateTime newFromDate) {
    _fromDate = newFromDate;
    notifyListeners(); 
  }

  DatesProvider() {
    _toDate = DateTime.now();
    _fromDate = DateTime.now().add(const Duration(minutes: 1));
  }
}
