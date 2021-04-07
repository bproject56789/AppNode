import 'package:flutter/material.dart';
import 'package:ylc/values/images.dart';

class Intro1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "WELCOME",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        Image.asset(GeneralImages.onBoarding1),
        SizedBox(height: 30),
        Text(
          "Start your trip to justice with us!",
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
