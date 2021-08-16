import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/storage.dart';

class Preferences with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  Preferences({required String theme}) {
    switch (theme) {
      case 'ThemeMode.light':
        _themeMode = ThemeMode.light;
        break;
      case 'ThemeMode.dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'ThemeMode.system':
        _themeMode = ThemeMode.system;
        break;
    }
  }

  void setThemeMode(themeMode) async {
    await Storage.saveString('theme', themeMode.toString());

    _themeMode = themeMode;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
}
