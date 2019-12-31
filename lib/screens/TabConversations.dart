import 'package:flutter/material.dart';
import 'package:manda_msg/model/Conversation.dart';

class TabConversations extends StatefulWidget {
  @override
  _TabConversationsState createState() => _TabConversationsState();
}

class _TabConversationsState extends State<TabConversations> {
  List<Conversation> conversationList = [
    Conversation("Ana Clara", "Olá, tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-3ccb0.appspot.com/o/profile%2Fperfil1.jpg?alt=media&token=0c287b3c-85cf-426d-bcc2-99f5d65cff3f"),
    Conversation("Pedro Silva", "Me manda o nome daquela série",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-3ccb0.appspot.com/o/profile%2Fperfil2.jpg?alt=media&token=ff005287-a309-4888-8038-612695f46c1e"),
    Conversation("Marcela Almeida", "Vamos sair hoje?",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-3ccb0.appspot.com/o/profile%2Fperfil3.jpg?alt=media&token=187c4d06-1a64-4d9d-af9c-e0746973f6bd"),
    Conversation(
        "José Renato",
        "Não vai acreditar no que tenho para te contar...",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-3ccb0.appspot.com/o/profile%2Fperfil4.jpg?alt=media&token=01978adc-6293-449e-b308-225bca45a886"),
    Conversation("Jamilton Damasceno", "Curso novo!!! dps dá uma olhada!!",
        "https://firebasestorage.googleapis.com/v0/b/fir-flutter-3ccb0.appspot.com/o/profile%2Fperfil5.jpg?alt=media&token=e2b1dafa-9e0d-45d2-bad4-1808f629b32f"),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: conversationList.length,
        itemBuilder: (context, index) {
          Conversation conversation = conversationList[index];

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            leading: CircleAvatar(
              maxRadius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(conversation.pathPhoto),
            ),
            title: Text(
              conversation.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            subtitle: Text(
              conversation.message,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14
              ),
            ),
          );
        });
  }
}
