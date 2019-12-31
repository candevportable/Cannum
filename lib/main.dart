import 'package:flutter/material.dart';
import 'package:manda_msg/RouteGenerator.dart';
import 'Login.dart';

void main(){
    WidgetsFlutterBinding.ensureInitialized();

    runApp(MaterialApp(
        home: Login(),
        theme: ThemeData(
            primaryColor: Color(0xff075E54),
            accentColor: Color(0xff25D366)
        ),
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
    ));
}

