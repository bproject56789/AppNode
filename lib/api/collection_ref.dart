import 'package:cloud_firestore/cloud_firestore.dart';

class YlcCollectionRef {
  static final _firestore = FirebaseFirestore.instance;
  // static final usersCollection = _firestore.collection("users");
  // static final questonsCollection = _firestore.collection("questions");
  // static final consultationCollection = _firestore.collection("consultations");
  static final chatsCollection = _firestore.collection("chats");
  // static final reviewCollection = _firestore.collection("reviews");
  // static CollectionReference answersRef(String questionId) =>
  //     questonsCollection.doc(questionId).collection("answers");

  static CollectionReference messageRef(String chatId) =>
      chatsCollection.doc(chatId).collection("messages");
}
