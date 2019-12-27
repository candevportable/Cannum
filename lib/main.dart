import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(){
    WidgetsFlutterBinding.ensureInitialized();

    runApp(MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
    ));
}

