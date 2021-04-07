import 'package:flutter/material.dart';

class HideWidget extends StatelessWidget {
  final bool hide;
  final Widget child;

  const HideWidget({Key key, this.hide = true, @required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return hide ? Container() : child;
  }
}
