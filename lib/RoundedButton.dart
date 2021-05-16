import 'package:flutter/material.dart';

/// Class for creating a rounded button
/// can accept arguments text - the text the button will display
///color - the color of the button
///textColor- the color of the text
///press- the action the button will perform when pressed
class RoundedButton extends StatelessWidget {
  final String text;
  final Color color, textColor;
  final VoidCallback press;
  //set defaults
  const RoundedButton({
    //text and press are required arguments
    required this.text,
    required this.press,
    //color and text color are optional arguments with default values
    this.color = Colors.indigo,
    this.textColor = Colors.white,
  }) ;

  //build button
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
            child: Text(text, style: TextStyle(color: textColor)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color)
            ),
            onPressed: press
          ),
        ),
    );
  }
}