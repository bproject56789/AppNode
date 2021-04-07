import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/ui/bottom_nav_bar_router/main_router.dart';
import 'package:ylc/ui/chat/bloc/chat_bloc.dart';
import 'package:ylc/ui/consultation/consultation_charge_page.dart';
import 'package:ylc/ui/intro/intro_screen.dart';
import 'package:ylc/ui/onboarding/login_page.dart';
import 'package:ylc/ui/onboarding/otp_verification.dart';
import 'package:ylc/ui/onboarding/select_area_of_expertise.dart';
import 'package:ylc/ui/onboarding/upload_documents.dart';
import 'package:ylc/ui/splash/splash_screen.dart';
import 'package:ylc/ui/suspended/suspended_page.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/values/theme.dart';

class App extends StatelessWidget {
  // final UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => ChatBloc(),
          dispose: (_, b) => b.dispose(),
        ),
      ],
      child: StreamProvider<UserModel>.value(
        value: Auth().user,
        child: MaterialApp(
          theme: myTheme,
          home: RootWidget(),
        ),
      ),
    );
  }
}

class RootWidget extends StatefulWidget {
  const RootWidget({Key key}) : super(key: key);
  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  AuthStatus _authStatus = AuthStatus.unknown;

  @override
  void initState() {
    SharedPreferences.getInstance().then(
      (value) => setState(
        () => AppConfig.pref = value,
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //get the state, check current User, set AuthStatus based on state
    var userModel = Provider.of<UserModel>(context);
    if (userModel != null) {
      print(" logged in");
      setState(() {
        _authStatus = AuthStatus.loggedIn;

        Provider.of<ChatBloc>(context, listen: false).init(userModel.id);
      });
    } else {
      print("not logged in");
      setState(() {
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.unknown:
        return SplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        return LoginPage();
        break;
      case AuthStatus.loggedIn:
        return LoggedIn();
        break;
      default:
        return Container();
    }
  }
}

class LoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userStream = Provider.of<UserModel>(context);

    if (_userStream != null) {
      AppConfig.userName = _userStream.name;
      if (_userStream.isSuspended) {
        return SuspendedPage();
      }
      if (!(_userStream.seenIntro ?? false)) {
        return IntroScreen();
      }
      if (!(_userStream.phoneVerified)) {
        return OtpVerificationScreen(phoneNumber: _userStream.phone);
      }
      if (_userStream.isAdvocate) {
        if (_userStream.advocateDetails?.areaOfLaw?.isEmpty ?? true) {
          return SelectAreaOfExpertise();
        }
        if (_userStream.documents == null) {
          return UploadDocuments();
        }
        if (_userStream.advocateDetails.consultationCharges == null) {
          return ConsultationChargesPage();
        }
      }

      return MainRouter();
    } else {
      return SplashScreen();
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
