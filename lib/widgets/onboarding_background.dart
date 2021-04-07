import 'package:flutter/material.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';

class OnBoardingBackground extends StatelessWidget {
  final Widget child;
  const OnBoardingBackground({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: YlcColors.categoryBackGround,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -MediaQuery.of(context).size.width * 0.4,
            top: MediaQuery.of(context).size.height * 0.2,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.amber, BlendMode.modulate),
              child: Image.asset(
                GeneralImages.loginPageBg,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
