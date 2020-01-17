import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manda_msg/RouteGenerator.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _controllerName = TextEditingController();
  File _photo;
  String _userId;
  String _imageUrl;
  bool _uploading = false;
  bool _loading = false;

  Future _recoverPhoto(String source) async{
    File selectedPhoto;

    switch(source){
      case "camera":
        selectedPhoto = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "gallery":
        selectedPhoto = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _photo = selectedPhoto;
      if(_photo != null){
        _uploading = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async{
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference root = storage.ref();
    StorageReference file = root.child("profile")
                                .child(_userId + ".jpg");

    StorageUploadTask task = file.putFile(_photo);
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
    _reloadUrlImageFirestore(url);

    setState(() {
      _imageUrl = url;
    });
  }

  _reloadUrlImageFirestore(String url){
    Firestore db = Firestore.instance;

    Map<String, dynamic> updatedData = {
      "urlImage" : url
    };

    db.collection("users")
    .document(_userId)
    .updateData(updatedData);
  }

  _reloadNameImageFirestore(){
    Firestore db = Firestore.instance;
    String name = _controllerName.text;

    Map<String, dynamic> updatedData = {
      "name" : name
    };

    db.collection("users")
        .document(_userId)
        .updateData(updatedData);
  }

  _recoverProfileData() async{
    _loading = true;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _userId = user.uid;

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db.collection("users")
     .document(_userId)
     .get();

    Map<String, dynamic> data = snapshot.data;
    _controllerName.text = data["name"];

    setState(() {
      _loading = false;
    });

    if(data["urlImage"] != null){
      setState(() {
        _imageUrl = data["urlImage"];
      });
    }
  }

  @override
  void initState() {
    _recoverProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(32),
                  child: _uploading
                      ? CircularProgressIndicator()
                      : Container(),
                ),
                _loading
                ? CircularProgressIndicator()
                : CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                  _imageUrl != null
                      ? NetworkImage(_imageUrl)
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Câmera"),
                      onPressed: (){
                        _recoverPhoto("camera");
                      },
                    ),
                    FlatButton(
                      child: Text("Galeria"),
                      onPressed: (){
                        _recoverPhoto("gallery");
                      },
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerName,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Color(0xff525AFF),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _reloadNameImageFirestore();
                      Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.HOME_ROUTE, (_)=>false);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
