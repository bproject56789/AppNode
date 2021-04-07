import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ylc/api/collection_ref.dart';
import 'package:ylc/models/data_models/chat_model.dart';
import 'package:ylc/models/data_models/message_model.dart';
import 'package:ylc/utils/api_result.dart';
import 'package:ylc/utils/helpers.dart';

class ChatApi {
  static Stream<List<ChatModel>> fetchChats(String userId) async* {
    var data = YlcCollectionRef.chatsCollection
        .where("participants", arrayContains: userId)
        .orderBy("timestamp", descending: true)
        .snapshots();

    yield* data.transform(
      StreamTransformer.fromHandlers(
        handleData: (documents, sink) {
          List<ChatModel> models = [];
          documents.docs.forEach((element) {
            models.add(ChatModel.fromMap(element.data())..id = element.id);
          });
          sink.add(models);
        },
      ),
    );
  }

  static Future<ApiResult> createChat(ChatModel model) async {
    try {
      await YlcCollectionRef.chatsCollection.doc(model.id).set(model.toMap());
      return ApiResult.successWithNoMessage();
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> createMessage(
    String chatId,
    MessageModel model,
  ) async {
    try {
      print(chatId);
      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.update(YlcCollectionRef.chatsCollection.doc(chatId), {
        "lastMessage": model.message,
        "timestamp": timestamp(),
      });
      batch.set(YlcCollectionRef.messageRef(chatId).doc(), model.toMap());
      await batch.commit();
      return ApiResult.successWithNoMessage();
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Stream<List<MessageModel>> fetchMessages(String chatId) async* {
    var data = YlcCollectionRef.messageRef(chatId)
        .orderBy("timestamp", descending: false)
        .snapshots();

    yield* data.transform(
      StreamTransformer.fromHandlers(
        handleData: (documents, sink) {
          List<MessageModel> models = [];
          documents.docs.forEach((element) {
            models.add(MessageModel.fromMap(element.data()));
          });
          sink.add(models);
        },
      ),
    );
  }

  static Future<void> markMessageAsRead({
    String chatId,
    String userId,
  }) async {
    return YlcCollectionRef.chatsCollection.doc(chatId).update(
      {
        'unreadStatus': {userId: 0}
      },
    );
  }
}
