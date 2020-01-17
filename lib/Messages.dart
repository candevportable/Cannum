import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manda_msg/model/Conversation.dart';
import 'package:manda_msg/model/User.dart';
import 'model/Message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String _userId;
  String _userName;
  String _userImage;
  String _userIdRecipient;
  Firestore _db = Firestore.instance;
  bool _uploading = false;
  TextEditingController _controllerMessage = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();

  _sendMessage() {
    String textMessage = _controllerMessage.text;
    if (textMessage.isNotEmpty) {
      Message message = Message();
      message.userId = _userId;
      message.message = textMessage;
      message.urlImage = "";
      message.type = "text";
      message.time = DateTime.now();

      _saveMessage(_userIdRecipient, _userId, message);
      _saveMessage(_userId, _userIdRecipient, message);

      _saveConversation(message);
    }
  }

  _saveConversation(Message msg){
    Conversation conversationSender = Conversation();
    conversationSender.userId = _userId;
    conversationSender.recipientId = _userIdRecipient;
    conversationSender.message = msg.message;
    conversationSender.name = widget.contact.name;
    conversationSender.urlImage = widget.contact.urlImage;
    conversationSender.type = msg.type;
    conversationSender.save();

    Conversation conversationRecipient = Conversation();
    conversationRecipient.userId = _userIdRecipient;
    conversationRecipient.recipientId = _userId;
    conversationRecipient.message = msg.message;
    conversationRecipient.name = _userName;
    conversationRecipient.urlImage = _userImage;
    conversationRecipient.type = msg.type;
    conversationRecipient.save();
  }

  _saveMessage(String recipientId, String senderId, Message message) async {
    await _db
        .collection("messages")
        .document(recipientId)
        .collection(senderId)
        .add(message.toMap());

    _controllerMessage.clear();
  }

  _sendImage() async{
    File _selectedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    _uploading = true;
    String _imageName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference root = storage.ref();
    StorageReference file = root.child("messages")
        .child(_userId)
        .child(_imageName + ".jpg");

    StorageUploadTask task = file.putFile(_selectedImage);
    task.events.listen((StorageTaskEvent storageEvent){
      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _uploading = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _uploading = false;
        });
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot){
      _fetchUrlImage(snapshot);
    });

  }

  Future _fetchUrlImage(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();

    Message message = Message();
    message.userId = _userId;
    message.message = "";
    message.urlImage = url;
    message.type = "image";
    message.time = DateTime.now();

    _saveMessage(_userIdRecipient, _userId, message);
    _saveMessage(_userId, _userIdRecipient, message);
  }

  _loadUserData() async{
    DocumentSnapshot snapshot = await _db.collection("users")
        .document(_userId)
        .get();
    Map<String, dynamic> data = snapshot.data;
    _userName = data["name"];
    _userImage = data["urlImage"];
  }

  _loadInitialData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _userId = user.uid;
    _userIdRecipient = widget.contact.userId;
    _loadUserData();
    _addMessagesListener();
  }

  Stream<QuerySnapshot> _addMessagesListener() {
    final stream = _db
        .collection("messages")
        .document(_userId)
        .collection(_userIdRecipient)
        .orderBy("time", descending: false)
        .snapshots();

    stream.listen((data) {
      _controller.add(data);
      Timer(Duration(seconds: 1), (){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    _loadInitialData();
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
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                  hintText: "Digite uma mensagem...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)),
                  prefixIcon:
                  _uploading ? CircularProgressIndicator()
                    :IconButton(icon: Icon(Icons.camera_alt),onPressed: _sendImage,),
                ),
              ),
            ),
          ),
          Platform.isIOS
            ? CupertinoButton(
                child: Text("Enviar"),
                onPressed: _sendMessage,
              )
            : FloatingActionButton(
                backgroundColor: Color(0xff020659),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                mini: true,
                onPressed: _sendMessage,
              )
        ],
      ),
    );

    var stream = StreamBuilder(
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
                    child: Text("Carregando mensagens"),
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar as mensagens"),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, index) {
                      List<DocumentSnapshot> messages = querySnapshot.documents.toList();
                      DocumentSnapshot item = messages[index];
                      Alignment alignment = Alignment.centerRight;
                      Color color = Color(0xff525AFF);
                      if (_userId != item["userId"]) {
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child:
                            item["type"] == "text"
                              ? Text(item["message"], style: TextStyle(fontSize: 18),)
                              : Image.network(item["urlImage"]),
                          ),
                        ),
                      );
                    }),
              );
            }
            break;
        }
        return null;
      },
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
                image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[stream, messageBox],
            ),
          ),
        ),
      ),
    );
  }
}
