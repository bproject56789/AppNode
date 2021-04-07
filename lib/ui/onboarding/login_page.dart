import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ylc/app.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/ui/onboarding/mode_selection_page.dart';
import 'package:ylc/utils/regex.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/custom_buttons.dart';
import 'package:ylc/widgets/custom_text_fields.dart';
import 'package:ylc/widgets/loading_view.dart';
import 'package:ylc/widgets/navigaton_helper.dart';
import 'package:ylc/widgets/onboarding_background.dart';
import 'package:ylc/widgets/simple_dialog_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void _loginUser({
    String email,
    String password,
    BuildContext context,
  }) async {
    try {
      changeLoading(true);
      var userModel = await Auth().loginUserWithEmail(email, password);
      if (userModel != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RootWidget(),
          ),
          (route) => false,
        );
      } else {
        changeLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
      changeLoading(false);
    }
  }

  void changeLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YlcColors.categoryBackGround,
      body: LoadingView(
        isLoading: isLoading,
        child: OnBoardingBackground(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 40,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      Container(
                        margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: Image.asset(CustomIcons.hammer),
                      ),
                      SizedBox(height: 40),
                      CustomTextField(
                        controller: _emailController,
                        prefixIcon: Icons.email,
                        hintText: Strings.email,
                        validator: (v) =>
                            Regex.emailValidationRegex.hasMatch(v ?? '')
                                ? null
                                : Strings.emailError,
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        obscureText: true,
                        controller: _passwordController,
                        prefixIcon: Icons.lock,
                        hintText: Strings.password,
                        validator: (v) =>
                            v.isNotEmpty ? null : Strings.passwordError,
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          //open dialog to take input
                          var result = await openInputDialog(
                            context,
                            hintText: Strings.email,
                            validator: (v) =>
                                Regex.emailValidationRegex.hasMatch(v ?? '')
                                    ? null
                                    : Strings.emailError,
                          );
                          if (result != null) {
                            FirebaseAuth.instance
                                .sendPasswordResetEmail(email: result)
                                .then((value) {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'An email has been sent to you at $result to reset your password'),
                                ),
                              );
                            }).catchError((e) {
                              print(e);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                ),
                              );
                            });
                          }
                        },
                        child: Text(
                          Strings.forgotPassword,
                          style: TextStyle(color: YlcColors.maroon),
                        ),
                      ),
                      SizedBox(height: 20),
                      Button1(
                        buttonText: Strings.signIn,
                        onPressed: () {
                          _loginUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                          );
                        },
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(Strings.dontHaveAccount),
                            FlatButton(
                              child: Text(
                                Strings.signUp.toUpperCase(),
                                style: TextStyle(
                                  color: YlcColors.textColor1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                navigateToPage(
                                  context,
                                  ModeSelectionPage(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
