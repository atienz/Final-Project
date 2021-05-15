import 'package:flutter/material.dart';
import 'package:mysample/Calendar.dart';
import 'package:mysample/LoginBody.dart';
import 'package:mysample/checkAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _email = '', _password = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
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

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    print("hi");
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
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
      backgroundColor: Colors.red[300],
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 35.0, bottom: 8.0, left: 10.0, right: 10.0),
                child: Image(
                  image: AssetImage('images/SignupPage.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "Create an account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
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
                          }),
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
                        onPressed: signUp,
                        child: Text('Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        color: Colors.indigo[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      AlreadyHaveAnAccountCheck(
                          login: false,
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
              ),
            ]),
      ),
    );
  }
}
