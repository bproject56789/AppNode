import 'package:flutter/material.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';

class Intro2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: YlcColors.categoryBackGround,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(GeneralImages.onBoarding2),
          SizedBox(height: 30),
          Text(
            "Find The Right lawyer",
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Access to thousands of lawyers who work around the clock to bring you to justice.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
