import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/ui/intro/intro1.dart';
import 'package:ylc/ui/intro/intro2.dart';
import 'package:ylc/ui/intro/intro3.dart';
import 'package:ylc/values/colors.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int currentPage = 0;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: [
              Intro1(),
              Intro2(),
              Intro3(),
            ],
            onPageChanged: (page) {
              setState(() => currentPage = page);
            },
          ),
          currentPage > 0
              ? Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        controller.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 3,
                  ),
                  IndicatorBuilder(
                    currentPage: currentPage,
                  ),
                  Spacer(),
                  Container(
                    height: 30,
                    child: RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onPressed: () async {
                        if (currentPage < 2) {
                          controller.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          var userModel =
                              Provider.of<UserModel>(context, listen: false);
                          UserApi.updateSeenIntro(
                            userModel.id,
                          ).then((value) {
                            if (value.isSuccess) {
                              Auth.updateUser(
                                userModel.copyWith(seenIntro: true),
                              );
                            }
                          });
                        }
                      },
                      child: Text(currentPage < 2 ? "Next" : "Get Started"),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IndicatorBuilder extends StatelessWidget {
  final int currentPage;
  final double indicatorSize;

  const IndicatorBuilder({Key key, this.currentPage, this.indicatorSize = 14})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          margin: const EdgeInsets.all(8),
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: currentPage == index ? YlcColors.textColor1 : Colors.white,
            border: Border.all(color: YlcColors.textColor1, width: 2),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
