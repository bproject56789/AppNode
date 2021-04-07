import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).maybePop();
      },
    );
  }
}
