import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manda_msg/RouteGenerator.dart';
import 'package:manda_msg/model/User.dart';

class TabContacts extends StatefulWidget {
  @override
  _TabContactsState createState() => _TabContactsState();
}

class _TabContactsState extends State<TabContacts> {

  //String _userId;
  String _userEmail;

  Future<List<User>> _loadContacts() async {
    Firestore db = Firestore.instance;

    QuerySnapshot querySnapshot = await db.collection("users").getDocuments();

    List<User> usersList = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var data = item.data;

      if(data["email"] == _userEmail) continue;

      User user = User();
      user.name = data["name"];
      user.email = data["email"];
      user.urlImage = data["urlImage"];

      usersList.add(user);
    }
    return usersList;
  }

  _recoverProfileData() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    //_userId = user.uid;
    _userEmail = user.email;
  }

  @override
  void initState() {
    _recoverProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
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
                  List<User> contactsList = snapshot.data;
                  User user = contactsList[index];

                  return ListTile(
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            RouteGenerator.MESSAGES_ROUTE,
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
