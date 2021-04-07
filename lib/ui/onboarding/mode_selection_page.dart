import 'package:flutter/material.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/ui/onboarding/register_page.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

class ModeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YlcColors.categoryBackGround,
      appBar: AppBar(
        backgroundColor: YlcColors.categoryBackGround,
        elevation: 0,
      ),
      body: Column(
        children: [
          Spacer(flex: 2),
          Row(
            children: [
              Image.asset(
                CustomIcons.hammer,
                scale: 0.8,
              ),
              Column(
                children: [
                  Text(
                    Strings.yourLegalConsultancy,
                    style: TextStyle(
                      color: YlcColors.textColor1,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Strings.weAreHere,
                    style: TextStyle(
                      color: YlcColors.textColor1,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(flex: 2),
          Text(
            Strings.signUpAs,
            style: TextStyle(color: YlcColors.textColor1, fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildSignUpModeCircle(
                context: context,
                mode: UserMode.Advocate,
              ),
              buildSignUpModeCircle(
                context: context,
                mode: UserMode.User,
              ),
            ],
          ),
          Spacer(),
          FlatButton(
            onPressed: () {},
            child: Text(Strings.privacyPolicy),
          ),
        ],
      ),
    );
  }

  Widget buildSignUpModeCircle({BuildContext context, UserMode mode}) {
    return InkWell(
      onTap: () {
        navigateToPage(
          context,
          RegisterPage(mode: mode),
        );
      },
      splashColor: YlcColors.textColor1,
      borderRadius: BorderRadius.circular(300),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black,
                BlendMode.modulate,
              ),
              child: Image.asset(
                mode == UserMode.User ? CustomIcons.user : CustomIcons.advocate,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 4),
            Text(
              mode == UserMode.User ? Strings.user : Strings.advocate,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
