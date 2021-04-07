import 'dart:convert';

import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/consultation_type.dart';

ConsultationModel consultationModelFromMap(String str) =>
    ConsultationModel.fromMap(json.decode(str));

List<ConsultationModel> consultationModelListFromMap(String str) =>
    List<ConsultationModel>.from(
        json.decode(str).map((x) => ConsultationModel.fromMap(x)));

class ConsultationModel {
  ConsultationModel({
    this.id,
    this.advocateDetails,
    this.userDetails,
    this.startTime,
    this.endTime,
    this.participants,
    this.isOver,
    this.type,
    this.paymentId,
    this.acceptedByAdvocate,
    this.acceptedByUser,
  });

  final String id;
  final UserModel advocateDetails;
  final UserModel userDetails;
  final int startTime;
  final int endTime;
  final bool isOver;
  final List<String> participants;
  final ConsultationType type;
  final String paymentId;
  final bool acceptedByUser;
  final bool acceptedByAdvocate;

  ConsultationModel copyWith({
    String id,
    Details advocateDetails,
    Details userDetails,
    List<String> participants,
    int startTime,
    int endTime,
    bool isOver,
    bool acceptedByAdvocate,
    bool acceptedByUser,
  }) =>
      ConsultationModel(
        advocateDetails: advocateDetails ?? this.advocateDetails,
        userDetails: userDetails ?? this.userDetails,
        participants: participants ?? this.participants,
        type: type ?? this.type,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        isOver: isOver ?? this.isOver,
        id: id ?? this.id,
        acceptedByAdvocate: acceptedByAdvocate ?? this.acceptedByAdvocate,
        acceptedByUser: acceptedByUser ?? this.acceptedByUser,
      );

  factory ConsultationModel.fromMap(Map<String, dynamic> json) =>
      ConsultationModel(
        id: json['_id'],
        advocateDetails: UserModel.fromMap(json["advocateId"]),
        userDetails: UserModel.fromMap(json["userId"]),
        participants: List<String>.from(json["participants"].map((x) => x)),
        startTime: json["startTime"],
        endTime: json["endTime"],
        isOver: json["isOver"],
        type: consultationTypeMapper[json["type"]],
        acceptedByAdvocate: json.containsKey('acceptedByAdvocate')
            ? (json['acceptedByAdvocate'] ?? false)
            : false,
        acceptedByUser: json.containsKey('acceptedByUser')
            ? (json['acceptedByUser'] ?? true)
            : true,
      );

  Map<String, dynamic> toMap() => {
        "advocateDetails": advocateDetails?.id,
        "userDetails": userDetails?.id,
        "participants": List<dynamic>.from(participants.map((x) => x)),
        "startTime": startTime,
        "endTime": endTime,
        "isOver": isOver,
        "type": type.label,
        "paymentId": paymentId,
      };

  bool isAdvocate(String userId) {
    return advocateDetails.id == userId;
  }

  UserModel getDetailsToShow(String userId) {
    return advocateDetails.id == userId ? userDetails : advocateDetails;
  }
}

class Details {
  Details({
    this.id,
    this.name,
    this.photo,
  });

  final String id;
  final String name;
  final String photo;

  Details copyWith({
    String id,
    String name,
    String photo,
  }) =>
      Details(
        id: id ?? this.id,
        name: name ?? this.name,
        photo: photo ?? this.photo,
      );

  factory Details.fromMap(Map<String, dynamic> json) => Details(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "photo": photo,
      };
}
