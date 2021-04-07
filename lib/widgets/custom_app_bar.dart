import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final bool showBackButton;
  final String title;

  CustomAppBar({
    this.title,
    this.showBackButton = true,
  });
  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: showBackButton
          ? IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : Container(),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      centerTitle: true,
    );
  }
}
