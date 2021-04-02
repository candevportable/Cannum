import 'package:flutter/material.dart';
import 'package:cannum/Home.dart';
import 'package:cannum/Login.dart';
import 'package:cannum/Messages.dart';
import 'package:cannum/Settings.dart';
import 'package:cannum/Signin.dart';

class RouteGenerator {
  static const String ROOT_ROUTE = "/";
  static const String LOGIN_ROUTE = "/login";
  static const String SIGNIN_ROUTE = "/signin";
  static const String HOME_ROUTE = "/home";
  static const String SETTINGS_ROUTE = "/settings";
  static const String MESSAGES_ROUTE = "/messages";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ROOT_ROUTE:
        return MaterialPageRoute(builder: (_) => Login());
      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => Login());
      case SIGNIN_ROUTE:
        return MaterialPageRoute(builder: (_) => Signin());
      case HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => Home());
      case SETTINGS_ROUTE:
        return MaterialPageRoute(builder: (_) => Settings());
      case MESSAGES_ROUTE:
        return MaterialPageRoute(builder: (_) => Messages(args));
      default:
        _routeError();
    }
    return null;
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Text("Tela não encontrada!"),
      );
    });
  }
}
