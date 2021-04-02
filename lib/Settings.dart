import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cannum/RouteGenerator.dart';

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

  Future _recoverPhoto(String source) async {
    final _picker = ImagePicker();
    File selectedPhoto;

    switch (source) {
      case "camera":
        final _selectedImg = await _picker.getImage(source: ImageSource.camera);
        selectedPhoto = File(_selectedImg.path);
        break;
      case "gallery":
        final _selectedImg =
            await _picker.getImage(source: ImageSource.gallery);
        selectedPhoto = File(_selectedImg.path);
        break;
    }

    setState(() {
      _photo = selectedPhoto;
      if (_photo != null) {
        _uploading = true;
        _uploadImage();
      }
    });
  }

  Future _uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference root = storage.ref();
    Reference file = root.child("profile").child(_userId + ".jpg");

    UploadTask task = file.putFile(_photo);
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.running) {
        setState(() {
          _uploading = true;
        });
      } else if (snapshot.state == TaskState.success) {
        setState(() {
          _uploading = false;
        });
      }
    });

    task.then((TaskSnapshot snapshot) {
      _fetchUrlImage(snapshot);
    });
  }

  Future _fetchUrlImage(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _reloadUrlImageFirestore(url);

    setState(() {
      _imageUrl = url;
    });
  }

  _reloadUrlImageFirestore(String url) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> updatedData = {"urlImage": url};

    db.collection("users").doc(_userId).update(updatedData);
  }

  _reloadNameImageFirestore() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    String name = _controllerName.text;

    Map<String, dynamic> updatedData = {"name": name};

    db.collection("users").doc(_userId).update(updatedData);
  }

  _recoverProfileData() async {
    _loading = true;
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    _userId = user.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("users").doc(_userId).get();

    Map<String, dynamic> data = snapshot.data();
    _controllerName.text = data["name"];

    setState(() {
      _loading = false;
    });

    if (data["urlImage"] != null) {
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
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(32),
                  child: _uploading ? CircularProgressIndicator() : Container(),
                ),
                _loading
                    ? CircularProgressIndicator()
                    : CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            _imageUrl != null ? NetworkImage(_imageUrl) : null,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: Text("Câmera"),
                      onPressed: () {
                        _recoverPhoto("camera");
                      },
                    ),
                    TextButton(
                      child: Text("Galeria"),
                      onPressed: () {
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
                  child: ElevatedButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff525AFF),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onPressed: () {
                      _reloadNameImageFirestore();
                      Navigator.pushNamedAndRemoveUntil(
                          context, RouteGenerator.HOME_ROUTE, (_) => false);
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
