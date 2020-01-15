import 'package:flutter/material.dart';
import 'package:manda_msg/model/Conversation.dart';

class TabConversations extends StatefulWidget {
  @override
  _TabConversationsState createState() => _TabConversationsState();
}

class _TabConversationsState extends State<TabConversations> {
  List<Conversation> _conversationList = List();

  @override
  void initState() {
    super.initState();
    Conversation conversation = Conversation();
    conversation.name = "Ana Clara";
    conversation.message = "Oiee";
    conversation.pathPhoto = "https://firebasestorage.googleapis.com/v0/b/fir-flutter-3ccb0.appspot.com/o/profile%2Ffa4lgyvjmnUrbzFhhMwlOX38GYK2.jpg?alt=media&token=a8da5dad-51de-49fd-906d-c3feab823964";
    _conversationList.add(conversation);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _conversationList.length,
        itemBuilder: (context, index) {
          Conversation conversation = _conversationList[index];

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
