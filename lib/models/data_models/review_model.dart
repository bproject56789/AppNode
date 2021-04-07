import 'dart:convert';

import 'package:ylc/models/data_models/user_model.dart';

List<ReviewModel> reviewModelFromMap(String str) =>
    List<ReviewModel>.from(json.decode(str).map((x) => ReviewModel.fromMap(x)));

class ReviewModel {
  ReviewModel({
    this.rating,
    this.review,
    this.creatorDetails,
    this.userDetails,
    this.timestamp,
  });

  final double rating;
  final String review;
  final UserModel creatorDetails;
  final UserModel userDetails;
  final int timestamp;

  ReviewModel copyWith({
    double rating,
    String review,
    UserModel creatorDetails,
    UserModel userDetails,
    int timestamp,
  }) =>
      ReviewModel(
        rating: rating ?? this.rating,
        review: review ?? this.review,
        creatorDetails: creatorDetails ?? this.creatorDetails,
        userDetails: userDetails ?? this.userDetails,
        timestamp: timestamp ?? this.timestamp,
      );

  factory ReviewModel.fromMap(Map<String, dynamic> json) => ReviewModel(
        rating: json["rating"].toDouble(),
        review: json["review"],
        creatorDetails: UserModel.fromMap(json["creatorId"]),
        userDetails: UserModel.fromMap(json["userId"]),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "rating": rating,
        "review": review,
        "creatorId": creatorDetails?.id,
        "userId": userDetails?.id,
        "timestamp": timestamp,
      };
}
