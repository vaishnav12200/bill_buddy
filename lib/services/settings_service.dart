import 'package:flutter/material.dart';
import '../models/expense.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  String _currentLanguage = 'en';
  double _totalAmountSpent = 0.0;

  String get currentLanguage => _currentLanguage;
  double get totalAmountSpent => _totalAmountSpent;

  void setLanguage(String languageCode) {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      notifyListeners();
    }
  }

  void updateTotalSpent(List<Expense> expenses, String currentUser) {
    double total = 0.0;
    for (var expense in expenses) {
      if (expense.paidBy == currentUser) {
        total += expense.amount;
      }
    }
    if (_totalAmountSpent != total) {
      _totalAmountSpent = total;
      notifyListeners();
    }
  }

  void addToTotalSpent(double amount) {
    _totalAmountSpent += amount;
    notifyListeners();
  }
}