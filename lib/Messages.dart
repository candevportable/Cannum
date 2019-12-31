import 'package:flutter/material.dart';
import 'package:manda_msg/model/User.dart';

class Messages extends StatefulWidget {
  User contact;

  Messages(this.contact);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  TextEditingController _controllerMessage = TextEditingController();

  _sendMessage(){

  }

  _sendImage(){

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
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
                Text("list view"),
                messageBox
              ],
            ),
          ),
        ),
      ),
    );
  }
}
