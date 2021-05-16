import 'package:flutter/material.dart';


//Class to display an option to log into a preexisting account from the signup page
class AlreadyHaveAnAccountCheck extends StatelessWidget {
  //variable to see if the user is on login page
  final bool login;
  //variable to hold tap
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    this.login = true, //default to true
    required this.press, //require press arg at function call
  });

  //build widget
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          //Display don't have an account if on login page or already have an
          // account if on other (sign in) page
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: Colors.indigo), //set text to indigo
        ),
        //to create button
        GestureDetector(
          onTap: press, //accept press
          child: Text(
            //display sign up or sign in button depending on page
            login ? "Sign Up" : "Sign In",
            //stylize text
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}