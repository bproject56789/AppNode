import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ylc/keys/keys.dart';
import 'package:ylc/models/data_models/consultation_model.dart';
import 'package:ylc/models/enums/consultation_type.dart';
import 'package:ylc/utils/api_result.dart';

class ConsultationApi {
  static String _endPoint = BaseUrl + 'consultations/';
  static Future<ApiResult> createConsultation(ConsultationModel model) async {
    try {
      var result = await http.post(
        _endPoint,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode(
          {
            "userId": model.userDetails.id,
            "advocateId": model.advocateDetails.id,
            "startTime": model.startTime,
            "endTime": model.endTime,
            "isOver": model.isOver,
            "participants": model.participants,
            "type": model.type.label,
            "paymentId": model.paymentId,
          },
        ),
      );
      print(result.body);
      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('Something went wrong');
      }
    } catch (e) {
      print(e);
      return ApiResult.failure('Something went wrong');
    }
  }

  static Future<List<ConsultationModel>> fetchAllConsultationsOfUser(
      {String userId}) async {
    try {
      var result = await http.get(
        _endPoint + userId,
      );

      if (result.statusCode == 200) {
        return consultationModelListFromMap(result.body);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<ApiResult> changeConsultationTiming(String consultationId,
      int startTime, int endTime, bool isEditedByUser) async {
    try {
      var result = await http.patch(
        _endPoint + consultationId,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode(
          {
            "startTime": startTime,
            "endTime": endTime,
            isEditedByUser ? "acceptedByUser" : "acceptedByAdvocate": true,
            isEditedByUser ? "acceptedByAdvocate" : "acceptedByUser": false,
          },
        ),
      );
      print(result.body);
      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('Something went wrong');
      }
    } catch (e) {
      print(e);
      return ApiResult.failure('Something went wrong');
    }

    // try {
    //   await YlcCollectionRef.consultationCollection.doc(consultationId).update({
    //     "startTime": startTime,
    //     "endTime": endTime,
    //     isEditedByUser ? "acceptedByUser" : "acceptedByAdvocate": true,
    //     isEditedByUser ? "acceptedByAdvocate" : "acceptedByUser": false,
    //   });
    //   return ApiResult.successWithNoMessage();
    // } catch (e) {
    //   return ApiResult.failure(e);
    // }
  }

  static Future<ApiResult> acceptConsultationTiming(
      String consultationId, int startTime, int endTime, bool isUser) async {
    try {
      var result = await http.patch(
        _endPoint + consultationId,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode(
          {
            "startTime": startTime,
            "endTime": endTime,
            isUser ? "acceptedByUser" : "acceptedByAdvocate": true,
          },
        ),
      );
      print(result.body);
      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('Something went wrong');
      }
    } catch (e) {
      print(e);
      return ApiResult.failure('Something went wrong');
    }

    // try {
    //   await YlcCollectionRef.consultationCollection.doc(consultationId).update({
    //     "startTime": startTime,
    //     "endTime": endTime,
    //     isUser ? "acceptedByUser" : "acceptedByAdvocate": true,
    //   });
    //   return ApiResult.successWithNoMessage();
    // } catch (e) {
    //   return ApiResult.failure(e);
    // }
  }
}
