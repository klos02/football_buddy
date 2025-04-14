import 'package:flutter/material.dart';


enum AppScreen {login, register, forgotPassword}


class AuthNavigationProvider extends ChangeNotifier {
  AppScreen get currentScreen => _currentScreen;

  AppScreen _currentScreen = AppScreen.login;

  void setCurrentScreen(AppScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }



}