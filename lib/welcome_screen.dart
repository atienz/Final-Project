import 'package:flutter/material.dart';
import 'package:mysample/LoginBody.dart';
import 'package:mysample/RoundedButton.dart';
import 'package:mysample/SignupPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.white,
          ),
          Image(image: AssetImage('images/Home.png')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome to SchoolDaze',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            '''
      Your hard-working app for the lazy college student.
            ''',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
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
