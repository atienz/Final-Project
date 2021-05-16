import 'package:flutter/material.dart';
import 'package:mysample/Calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysample/SignupPage.dart';
import 'checkAccount.dart';

//Class for user login
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //instantiate firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //instantiate form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //create variables for user's email and password
  String _email = '',
      _password = '';

  //check to see if user is already logged in and if so, load the calendar page
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

  //auto initialization
  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  //function called when login button is pressed
  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //try catch for user authentication
      try {
        //attempt to sign user into firebase with user inputted credentials
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);

        //catch block for errors
      } on FirebaseAuthException catch (e) {
        //error if email is not registered
        if (e.code == 'user-not-found') {
          //show error to user
          showError('No user found for that email.');
          //error if password is incorrect
        } else if (e.code == 'wrong-password') {
          //show error to user
          showError('Wrong password provided for that user.');
        }
      }
    }
  }

  //function for displaying errors to user using an alert dialog
  //accepts a string arg representing the message the user will see
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

//build login page
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //whitespace padding around image
            Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 8.0, left: 10.0, right: 10.0),
              //display an image
              child: Image(image: AssetImage('images/LoginPage.png'),
              ),
            ),
            //whitespace padding around text
            Padding(
              padding: const EdgeInsets.all(6.0),
              //header text
              child: Text(
                "Login to your account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
              ),
            ),
            //form for user credential input
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      //input field for email
                      //input is saved to _email
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
                          }
                          ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      //input field for password
                      //input is saved to _password
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
                      //button for credential submission
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                        //call login when pressed
                        onPressed: login,
                        //button text says Login
                        child: Text('Login',
                            //stylize text
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                        //set color
                        color: Colors.red[300],
                        //set shape
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    //allows user to navigate to sign up if they don't have an account
                    AlreadyHaveAnAccountCheck(
                        login: true, //tells function we are on the login page
                        press: () { //sends user to signup page on press
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return SignUp();
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

