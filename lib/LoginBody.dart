import 'package:flutter/material.dart';
import 'package:mysample/Calendar.dart';
import 'package:mysample/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysample/SignupPage.dart';

import 'checkAccount.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '',
      _password = '';

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Calendar()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showError('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showError('Wrong password provided for that user.');
        }
      }
    }
  }
  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 8.0, left: 10.0, right: 10.0),
              child: Image(image: AssetImage('images/LoginPage.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                "Login to your account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                child: Column(
                  children: [
                    TextFormField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Your Email",
                          border: InputBorder.none,
                        ),
                        onSaved: (val) {
                          _email = val!;
                        }
                        ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: "Password",
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                      onSaved: (val) {
                        _password = val!;
                      },
                    ),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                      onPressed: login,
                      child: Text('Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      color: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    AlreadyHaveAnAccountCheck(
                        login: true,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Login();
                            }),
                          );
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

