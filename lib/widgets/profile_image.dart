import 'package:flutter/material.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';

class ProfileImage extends StatelessWidget {
  final String photo;
  final double radius;
  final Color foreGroundColor;
  final Color backGroundColor;

  factory ProfileImage.lightColor({
    String photo,
    double radius = 24,
  }) {
    return ProfileImage(
      photo: photo,
      radius: radius,
      backGroundColor: YlcColors.categoryForeGround,
    );
  }

  factory ProfileImage.darkColor({
    String photo,
    double radius = 24,
  }) {
    return ProfileImage(
      photo: photo,
      radius: radius,
      foreGroundColor: Colors.white,
    );
  }

  const ProfileImage({
    Key key,
    this.photo,
    this.radius = 24,
    this.foreGroundColor,
    this.backGroundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backGroundColor,
      foregroundColor: foreGroundColor,
      child: photo != null
          ? ClipOval(
              child: Image.network(
                photo,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                CustomIcons.userLogo,
                fit: BoxFit.contain,
                // scale: 2,
              ),
            ),
    );
  }
}
