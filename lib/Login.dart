import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cannum/RouteGenerator.dart';
import 'model/app_user.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String _errorMessage = "";

  _validateFields() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty) {
        setState(() {
          _errorMessage = "";
        });

        AppUser user = AppUser();
        user.email = email;
        user.password = password;
        _logUser(user);
      } else {
        setState(() {
          _errorMessage = "Preencha a senha.";
        });
      }
    } else {
      setState(() {
        _errorMessage = "O e-mail informado é inválido.";
      });
    }
  }

  _logUser(AppUser user) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROUTE);
    }).catchError((error) {
      setState(() {
        _errorMessage =
            "Erro ao autenticar usuário, verifique os campos e tente novamente.";
      });
    });
  }

  Future _verifyUserLogged() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROUTE);
    }
  }

  @override
  void initState() {
    //_verifyUserLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Color(0xFFDFC7A3),
            image: DecorationImage(
                fit: BoxFit.none,
                image: AssetImage('assets/images/background_folha.jpg'))),
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        child: Center(
            child: SizedBox(
          width: 250.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: AnimatedTextKit(
              pause: Duration(seconds: 2),
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  "Cannum",
                  speed: Duration(milliseconds: 200),
                  curve: Curves.easeInSine,
                  textStyle: TextStyle(
                    fontSize: 57.0,
                    fontFamily: "Tox Typewriter",
                    letterSpacing: 2,
                    color: Color(0xFF484536),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        )

            /*SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Image.asset(
                    "images/logoCandev.png",
                    width: 180,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Color(0xff020659),
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    onPressed: () {
                      _validateFields();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem uma conta? Cadastre-se!",
                      style: TextStyle(color: Color(0xff020659)),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RouteGenerator.SIGNIN_ROUTE);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),*/
            ),
      ),
    );
  }
}
