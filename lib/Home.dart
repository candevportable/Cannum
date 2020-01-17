import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manda_msg/RouteGenerator.dart';
import 'package:manda_msg/screens/TabContacts.dart';
import 'package:manda_msg/screens/TabConversations.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  TabController _tabController;
  List<String> _menuItems = [
    "Configurações", "Deslogar"
  ];

  Future _verifyUserLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    if (user == null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROUTE);
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyUserLogged();
    _tabController = TabController(
      length: 2,
      vsync: this
    );
  }

  _selectedMenuItem(String selectedItem){
    switch(selectedItem){
      case "Configurações":
        Navigator.pushNamed(context, RouteGenerator.SETTINGS_ROUTE);
        break;
      case "Deslogar":
        _signOut();
        break;
    }
  }

  _signOut() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manda msg"),
        elevation: Platform.isIOS ? 0 : 4,
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Platform.isIOS ? Colors.grey[400] : Colors.white,
          tabs: <Widget>[
            Tab(text: "Conversas",),
            Tab(text: "Contatos",)
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _selectedMenuItem,
            itemBuilder: (context){
              return _menuItems.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          TabConversations(),
          TabContacts()
        ],
      ),
    );
  }
}
