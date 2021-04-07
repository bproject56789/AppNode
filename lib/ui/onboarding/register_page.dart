import 'package:flutter/material.dart';
import 'package:ylc/app.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/utils/regex.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/custom_buttons.dart';
import 'package:ylc/widgets/custom_text_fields.dart';
import 'package:ylc/widgets/loading_view.dart';
import 'package:ylc/widgets/onboarding_background.dart';

class RegisterPage extends StatefulWidget {
  final UserMode mode;

  const RegisterPage({
    Key key,
    this.mode = UserMode.User,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _signUpUser(
    String email,
    String password,
    String name,
    String phone,
    BuildContext context,
  ) async {
    try {
      setLoadingStatus(true);
      var result = await Auth().signUpUser(
        email,
        password,
        name,
        phone,
        widget.mode,
      );
      if (result != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RootWidget(),
          ),
          (route) => false,
        );
      } else {
        setLoadingStatus(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setLoadingStatus(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Strings.generalError),
          duration: Duration(seconds: 2),
        ),
      );
      print(e);
    }
  }

  void setLoadingStatus(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: YlcColors.categoryBackGround,
        elevation: 0,
        title: Text(
            widget.mode == UserMode.User ? Strings.newUser : Strings.advocate),
      ),
      body: LoadingView(
        isLoading: isLoading,
        child: OnBoardingBackground(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 40,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Spacer(),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          Strings.signUpToGetStarted,
                          style: TextStyle(
                            color: YlcColors.textColor1,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Spacer(),
                      CustomTextField(
                        controller: _nameController,
                        prefixIcon: Icons.person,
                        hintText: Strings.username,
                        validator: (v) =>
                            v.isNotEmpty ? null : Strings.nameError,
                      ),
                      SizedBox(height: 12),
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
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return Strings.passwordError;
                          } else if (v.length < 6) {
                            return Strings.passwordError2;
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        controller: _phoneController,
                        prefixIcon: Icons.phone,
                        hintText: Strings.phone,
                        validator: (v) =>
                            v.isNotEmpty ? null : Strings.phoneError,
                      ),
                      SizedBox(height: 40),
                      Button1(
                        buttonText: Strings.signUp,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _signUpUser(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              _phoneController.text,
                              context,
                            );
                          }
                        },
                      ),
                      Spacer(flex: 2),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(Strings.haveAccount),
                            FlatButton(
                              child: Text(
                                Strings.signIn.toUpperCase(),
                                style: TextStyle(
                                  color: YlcColors.textColor1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                var count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
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
