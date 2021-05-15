import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color, textColor;
  final VoidCallback press;
  const RoundedButton({
    required this.text,
    required this.press,
    this.color = Colors.indigo,
    this.textColor = Colors.white,
  }) ;

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