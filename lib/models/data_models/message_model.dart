class MessageModel {
  String id;
  String message;
  String fromId;
  String toId;
  MessageType type;
  String data;
  int timestamp;

  MessageModel({
    this.message,
    this.fromId,
    this.toId,
    this.type,
    this.timestamp,
    this.data,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
        message: map["message"],
        fromId: map["fromId"],
        toId: map["toId"],
        type: map.containsKey('type')
            ? _typeMapper[map["type"]]
            : MessageType.MESSAGE,
        timestamp: map["timestamp"],
        data: map.containsKey("data") ? map['data'] : null,
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "fromId": fromId,
        "toId": toId,
        "data": data,
        "type": type != null ? type.toString().split('.')[1] : "MESSAGE",
        "timestamp": timestamp,
      };
}

enum MessageType {
  MESSAGE,
  // IMAGE,
  // URL,
}

Map<String, MessageType> _typeMapper = {
  "MESSAGE": MessageType.MESSAGE,
  // "IMAGE": MessageType.IMAGE,
  // "URL": MessageType.URL,
};
