import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  String uid;
  String email;
  String name;
  String photo;
  bool isAdvocate;

  AuthModel({
    this.uid,
    this.email,
  });

  AuthModel.fromFirebaseUser({User user}) {
    uid = user.uid;
    email = user.email;
  }
}
