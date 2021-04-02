import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cannum/model/app_user.dart';

import '../RouteGenerator.dart';

class TabConversations extends StatefulWidget {
  @override
  _TabConversationsState createState() => _TabConversationsState();
}

class _TabConversationsState extends State<TabConversations> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _userId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  _addConversationListener() {
    final stream = db
        .collection("conversations")
        .doc(_userId)
        .collection("last_message")
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
    });
  }

  _loadInitialData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    _userId = user.uid;
    _addConversationListener();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Carregando conversas"),
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro ao carregar conversas!");
            } else {
              QuerySnapshot querySnapshot = snapshot.data;
              if (querySnapshot.docs.length == 0) {
                return Center(
                  child: Text(
                    "Você não possui nenhuma conversa ainda :( ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> conversations =
                        querySnapshot.docs.toList();
                    DocumentSnapshot item = conversations[index];

                    String urlImage = item["urlImage"];
                    String type = item["type"];
                    String message = item["message"];
                    String name = item["name"];
                    String repicientId = item["recipientId"];

                    AppUser user = AppUser();
                    user.name = name;
                    user.urlImage = urlImage;
                    user.userId = repicientId;

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
                        backgroundImage:
                            urlImage != null ? NetworkImage(urlImage) : null,
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        type == "text" ? message : "Imagem...",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    );
                  });
            }
        }
        return null;
      },
    );
  }
}
