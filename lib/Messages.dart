import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manda_msg/model/User.dart';

import 'model/Message.dart';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String _userId;
  String _userIdRecipient;
  List<String> messagesList = [
    "Olá, tudo bem??",
    "tudo, e vc?",
    "to de boas"
  ];
  TextEditingController _controllerMessage = TextEditingController();

  _sendMessage(){
    String textMessage = _controllerMessage.text;
    if(textMessage.isNotEmpty){
      Message message = Message();
      message.userId = _userId;
      message.message = textMessage;
      message.urlImage = "";
      message.type = "text";

      _saveMessage(_userIdRecipient, _userId, message);
    }
  }

  _saveMessage(String recipientId, String senderId, Message message) async{
    Firestore db = Firestore.instance;

    await db.collection("messages")
      .document(_userId)
      .collection(_userIdRecipient)
      .add(message.toMap());

    _controllerMessage.clear();
  }

  _sendImage(){

  }

  _recoverProfileData() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _userId = user.uid;
    _userIdRecipient = widget.contact.userId;
  }

  @override
  void initState() {
    _recoverProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var messageBox = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMessage,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma mensagem...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _sendImage,
                  ),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(Icons.send, color: Colors.white,),
            mini: true,
            onPressed: _sendMessage,
          )
        ],
      ),
    );

    var listView = Expanded(
      child: ListView.builder(
        itemCount: messagesList.length,
          itemBuilder: (context, index){

            Alignment alignment = Alignment.centerRight;
            Color color = Color(0xffd2ffa5);
            if(index%2 == 0){
              alignment = Alignment.centerLeft;
              color = Colors.white;
            }

            return Align(
              alignment: alignment,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Text(messagesList[index], style: TextStyle(fontSize: 18),),
                ),
              ),
            );
          }
      ),
    );

    return Scaffold(
      appBar: AppBar(

        title: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: widget.contact.urlImage != null
                  ? NetworkImage(widget.contact.urlImage)
                  : null,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(widget.contact.name),
            )
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover
          )
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                listView,
                messageBox
              ],
            ),
          ),
        ),
      ),
    );
  }
}