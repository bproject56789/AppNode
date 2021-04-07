// import 'package:rxdart/subjects.dart';
// import 'package:ylc/api/user_api.dart';
// import 'package:ylc/models/data_models/user_model.dart';

// class UserService {
//   final _user = BehaviorSubject<UserModel>();

//   Stream<UserModel> get user => _user.stream;

//   void init(String userId) {
//     UserApi.getUserStream(userId).listen((event) {
//       _user.add(event);
//     });
//   }

//   void dispose() {
//     _user.close();
//   }
// }
