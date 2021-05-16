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

  //function called when sign up button is hit
  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    //try catch block to catch errors in authentication
    try {
      //try to log user in with the entered credentials with firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      //if an error is encountered send an error message to user
      //error is password is too weak
      if (e.code == 'weak-password') {
        showError('The password provided is too weak.');
        //error if email already has an account
      } else if (e.code == 'email-already-in-use') {
        showError('The account already exists for that email.');
      }
    } catch (e) {
      //print error to console
      print(e);
    }
  }

  //function for displaying error messages to the user using an alert dialogue
  //accepts a string representing the error message the user will be shown
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

//build page
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red[300],
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //padding for whitespace around image
              Padding(
                padding: const EdgeInsets.only(
                    top: 35.0, bottom: 8.0, left: 10.0, right: 10.0),
                //image to be shown
                child: Image(
                  image: AssetImage('images/SignupPage.png'),
                ),
              ),
              //padding for whitespace around text
              Padding(
                padding: const EdgeInsets.all(6.0),
                //display create an account
                child: Text(
                  "Create an account",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ),
              //form for user credentials
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        //email input field
                        //takes user input in the field and saves it to _email variable
                        child: TextFormField(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        //input field for password
                        //takes user input in the field and saves it to _password variable
                        child: TextFormField(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        //submission button for inputs
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                          onPressed: signUp,
                          //button says sign up
                          child: Text('Sign Up',
                              //set button style
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          color: Colors.indigo[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      //displays a prompt to the user asking if they already
                      // have an account and allows them to easily navigate to login page in stead
                      AlreadyHaveAnAccountCheck(
                          login: false, //arg that says we are not on the logon page
                          press: () { //arg that says on press to navigate to login page
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
