import 'package:flutter/material.dart';
import 'package:manda_msg/Home.dart';
import 'package:manda_msg/Login.dart';
import 'package:manda_msg/Signin.dart';

class RouteGenerator{
  static const String ROOT_ROUTE = "/";
  static const String LOGIN_ROUTE = "/login";
  static const String SIGNIN_ROUTE = "/signin";
  static const String HOME_ROUTE = "/home";

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case ROOT_ROUTE:
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case LOGIN_ROUTE:
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case SIGNIN_ROUTE:
        return MaterialPageRoute(
            builder: (_) => Signin()
        );
      case HOME_ROUTE:
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(title: Text("Tela não encontrada!"),),
          body: Text("Tela não encontrada!"),
        );
      }
    );
  }
}