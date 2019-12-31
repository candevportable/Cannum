import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _controllerName = TextEditingController();
  File _photo;
  String _idUser;
  String _urlImage;
  bool _uploading = false;

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
                                .child(_idUser + ".jpg");

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

    setState(() {
      _urlImage = url;
    });
  }

  _recoverProfileData() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    _idUser = user.uid;
  }

  @override
  void initState() {
    super.initState();
    _recoverProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações"),),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
              _uploading
              ? CircularProgressIndicator()
              : Container(),
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                backgroundImage:
                  _urlImage != null
                  ? NetworkImage(_urlImage)
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
                  autofocus: true,
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
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  onPressed: () {

                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
