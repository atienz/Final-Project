import 'package:flutter/material.dart';
import 'package:mysample/LoginBody.dart';
import 'package:mysample/RoundedButton.dart';
import 'package:mysample/SignupPage.dart';

//Class for building home page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //create white app bar
          AppBar(
            backgroundColor: Colors.white,
          ),
          //display image
          Image(image: AssetImage('images/Home.png')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            //display header
            child: Text(
              'Welcome to SchoolDaze',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          //display secondary text
          Text(
            '''
      Your hard-working app for the lazy college student.
            ''',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          //display login button that redirects to login page when clicked
          RoundedButton(
              text: "LOGIN",
              color: Colors.indigo.shade300,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ),
                );
              }),
          //display sign up button that redirects to sign up page when clicked
          RoundedButton(
              text: "SIGN UP",
              color: Colors.red.shade300,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUp();
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
