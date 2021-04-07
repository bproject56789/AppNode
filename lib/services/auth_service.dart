import 'package:rxdart/subjects.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/utils/api_result.dart';

import '../user_config.dart';

enum AuthStatus { unknown, notLoggedIn, loggedIn }

class Auth {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  static final _user = BehaviorSubject<UserModel>();

  static Function(UserModel) get updateUser => _user.sink.add;

  Auth() {
    // AppConfig.pref.setString("userId", "604cdd3ac5cfd3149a4a4561");
    // AppConfig.pref.setString("userId", "602801947ddc180c524039d5");
    if (AppConfig.userId != null) {
      UserApi.getUser(uid: AppConfig.userId).then((model) {
        if (model != null) {
          _user.add(model);
        }
      });
    }
  }

  Stream<UserModel> get user => _user.stream;

  static Future<ApiResult<String>> signOut() async {
    try {
      await AppConfig.pref.setString("userId", null);
      _user.add(null);

      return ApiResult.successWithNoMessage();
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<UserModel> signUpUser(
    String email,
    String password,
    String name,
    String phone,
    UserMode mode,
  ) async {
    var result = await UserApi.createUser(
      name: name.trim(),
      email: email,
      phone: phone,
      password: password,
      isAdvocate: mode == UserMode.Advocate,
    );
    if (result != null) {
      await AppConfig.pref.setString("userId", result.id);
    }
    _user.add(result);
    return result;
  }

  Future<UserModel> loginUserWithEmail(String email, String password) async {
    try {
      var model = await UserApi.loginUser(email: email, password: password);
      if (model != null) {
        await AppConfig.pref.setString("userId", model.id);
      }
      _user.add(model);
      return model;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void dispose() {
    _user.close();
  }
}
