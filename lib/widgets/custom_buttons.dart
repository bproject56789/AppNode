import 'package:flutter/material.dart';
import 'package:ylc/values/colors.dart';

class Button1 extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const Button1({
    Key key,
    @required this.buttonText,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(buttonText),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textColor: YlcColors.textColor1,
      color: Colors.white,
      onPressed: onPressed,
    );
  }
}
