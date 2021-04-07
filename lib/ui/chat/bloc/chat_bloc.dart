import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:ylc/api/chat_api.dart';
import 'package:ylc/models/data_models/chat_model.dart';

class ChatBloc {
  final _messageCount = BehaviorSubject<int>();
  final _chats = BehaviorSubject<List<ChatModel>>();

  Stream<List<ChatModel>> get chats => _chats.stream;
  Stream<int> get messageCount => _messageCount.stream;

  void init(String userId) {
    ChatApi.fetchChats(userId).listen((chats) {
      int count = 0;
      chats.forEach((chat) {
        if (chat.unreadStatus != null &&
            chat.unreadStatus.containsKey(userId)) {
          count += chat.unreadStatus[userId];
        }
      });
      _chats.add(chats);
      _messageCount.add(count);
    });
  }

  ChatModel getChatModel(String chatId) {
    return _chats.value?.firstWhere(
      (element) => element.id == chatId,
      orElse: () => null,
    );
  }

  Stream<ChatModel> getChatStream(String chatId) async* {
    _chats.transform(
      StreamTransformer.fromHandlers(
        handleData: (chats, sink) {
          sink.add(
            chats.firstWhere(
              (chat) => chat.id == chatId,
              orElse: () => null,
            ),
          );
        },
      ),
    );
  }

  void dispose() {
    _messageCount.close();
    _chats.close();
  }
}
