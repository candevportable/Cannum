import 'package:flutter/material.dart';
import 'package:manda_msg/RouteGenerator.dart';
import 'Login.dart';
import 'dart:io';

final ThemeData androidTheme = ThemeData(
    primaryColor: Color(0xff075E54),
    accentColor: Color(0xff25D366)
);

final ThemeData iosTheme = ThemeData(
    primaryColor: Colors.grey[200],
    accentColor: Color(0xff25D366)
);

void main(){
    WidgetsFlutterBinding.ensureInitialized();

    runApp(MaterialApp(
        home: Login(),
        theme: Platform.isIOS ? iosTheme : androidTheme,
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
    ));
}

