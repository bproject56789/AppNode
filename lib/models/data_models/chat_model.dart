import 'package:ylc/models/data_models/consultation_model.dart';

class ChatModel {
  String id;
  List<String> participants;
  List<Details> participantDetails;
  String lastMessage;
  Map<String, int> unreadStatus;

  int timestamp;
  int endTime;

  ChatModel({
    this.id,
    this.participants,
    this.participantDetails,
    this.lastMessage,
    this.unreadStatus,
    this.endTime,
    this.timestamp,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) => ChatModel(
        participants: List<String>.from(map["participants"].map((x) => x)),
        participantDetails: List<Details>.from(map["participantDetails"]
            .map((x) => Details.fromMap(Map<String, dynamic>.from(x)))),
        lastMessage: map.containsKey('lastMessage') ? map["lastMessage"] : null,
        unreadStatus: map["unreadStatus"] != null
            ? Map<String, int>.from(map["unreadStatus"])
            : {},
        timestamp: map.containsKey("timestamp") ? map["timestamp"] : null,
        endTime: map["endTime"],
      );

  Map<String, dynamic> toMap() => {
        "participants": List<dynamic>.from(participants.map((x) => x)),
        "participantDetails":
            List<dynamic>.from(participantDetails.map((x) => x.toMap())),
        "unreadStatus": unreadStatus,
        "endTime": endTime,
        "timestamp": timestamp,
      };
}
