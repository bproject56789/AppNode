import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static SharedPreferences pref;

  static String get userId => pref.getString('userId');
  static String userName;
}
