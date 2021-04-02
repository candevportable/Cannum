import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cannum/RouteGenerator.dart';
import 'package:cannum/model/app_user.dart';

class TabContacts extends StatefulWidget {
  @override
  _TabContactsState createState() => _TabContactsState();
}

class _TabContactsState extends State<TabContacts> {
  String _userEmail;

  Future<List<AppUser>> _loadContacts() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection("users").get();

    List<AppUser> usersList;
    for (DocumentSnapshot item in querySnapshot.docs) {
      var data = item.data();

      if (data["email"] == _userEmail) continue;

      AppUser user = AppUser();
      user.userId = item.id;
      user.name = data["name"];
      user.email = data["email"];
      user.urlImage = data["urlImage"];

      usersList.add(user);
    }
    return usersList;
  }

  _recoverProfileData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    _userEmail = user.email;
  }

  @override
  void initState() {
    _recoverProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppUser>>(
      future: _loadContacts(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Carregando contatos"),
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  List<AppUser> contactsList = snapshot.data;
                  AppUser user = contactsList[index];

                  return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteGenerator.MESSAGES_ROUTE,
                            arguments: user);
                      },
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: user.urlImage != null
                            ? NetworkImage(user.urlImage)
                            : null,
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ));
                });
            break;
        }
        return null;
      },
    );
  }
}
