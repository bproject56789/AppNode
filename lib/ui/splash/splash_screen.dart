import 'package:flutter/material.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';

class SplashScreen extends StatelessWidget {
  final double width = 400;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Transform.scale(
                scale: 1.7,
                child: Container(
                  padding: const EdgeInsets.all(60),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: YlcColors.categoryBackGround.withOpacity(0.4),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(60),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: YlcColors.categoryBackGround.withOpacity(0.6),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: YlcColors.categoryBackGround,
                      ),
                      child: Image.asset(CategoryImages.logo),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  Strings.yourLegalConsultancy,
                  style: TextStyle(
                    color: YlcColors.textColor1,
                    fontSize: 32,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Loading ...",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 200,
                        height: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
