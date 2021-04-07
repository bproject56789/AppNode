import 'package:rxdart/subjects.dart';
import 'package:ylc/api/chat_api.dart';
import 'package:ylc/models/data_models/message_model.dart';
import 'package:ylc/utils/helpers.dart';

class MessageBloc {
  final _messages = BehaviorSubject<List<MessageModel>>();

  Stream<List<MessageModel>> get messages => _messages.stream;

  void init(String chatId) {
    ChatApi.fetchMessages(chatId).listen((event) {
      _messages.add(event);
    });
  }

  void dispose() {
    _messages.close();
  }

  Future<void> pushNewMessage({
    String chatId,
    String messageContent,
    String senderId,
    String recieverId,
    MessageType type,
  }) async {
    MessageModel messageModel = MessageModel(
      fromId: senderId,
      toId: recieverId,
      message: messageContent,
      type: type,
      timestamp: timestamp(),
    );
    await ChatApi.createMessage(chatId, messageModel);
  }
}
