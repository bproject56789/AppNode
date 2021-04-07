import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ylc/keys/keys.dart';
import 'package:ylc/models/data_models/review_model.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/utils/api_result.dart';

class ReviewApi {
  static const _endPoint = BaseUrl + 'reviews/';

  static Future<List<ReviewModel>> fetchUserReviews(String userId) async {
    print(_endPoint);
    try {
      var result = await http.get(_endPoint + userId);

      if (result.statusCode == 200) {
        return reviewModelFromMap(result.body);
      } else {
        return null;
      }
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ApiResult> createReview(
      {double rating, String review, String reviewedId}) async {
    try {
      var result = await http.post(
        _endPoint,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode({
          "rating": rating,
          "review": review,
          "creatorId": AppConfig.userId,
          "userId": reviewedId,
        }),
      );

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure("something went wrong");
      }
    } catch (e) {
      print(e);
      return ApiResult.failure(e);
    }
  }
}
