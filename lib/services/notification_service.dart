// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:ylc/api/user_api.dart';

// class NotificationService {
//   NotificationService._();

//   factory NotificationService() => _instance;

//   static final NotificationService _instance = NotificationService._();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;

//   Future<void> init(String userId) async {
//     if (!_initialized) {
//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions();
//       _firebaseMessaging.configure();

//       // For testing purposes print the Firebase Messaging token
//       String token = await _firebaseMessaging.getToken();
//       await UserApi.setFCMToken(userId, token);
//       _initialized = true;
//     }
//   }
// }
