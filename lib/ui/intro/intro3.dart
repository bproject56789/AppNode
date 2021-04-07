import 'package:flutter/material.dart';
import 'package:ylc/values/images.dart';

class Intro3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(GeneralImages.onBoarding3),
        SizedBox(height: 30),
        Text(
          "Gain Consultation and Post Queries",
          style: TextStyle(fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Get consultation from Top Lawyers and responses to your queries within 24 Hours",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
