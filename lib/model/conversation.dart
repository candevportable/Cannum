import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String _userId;
  String _recipientId;
  String _name;
  String _message;
  String _urlImage;
  String _type;

  Conversation();

  save() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("conversations")
        .doc(this.userId)
        .collection("last_message")
        .doc(this.recipientId)
        .set(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "userId": this.userId,
      "recipientId": this.recipientId,
      "name": this.name,
      "message": this.message,
      "urlImage": this.urlImage,
      "type": this.type,
    };
    return map;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get message => _message;

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  set message(String value) {
    _message = value;
  }

  String get recipientId => _recipientId;

  set recipientId(String value) {
    _recipientId = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }
}
