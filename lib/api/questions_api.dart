import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ylc/keys/keys.dart';
import 'package:ylc/models/data_models/answers_model.dart';
import 'package:ylc/models/data_models/questions_model.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/utils/api_result.dart';

class QuestionsApi {
  static const _questionsEndPoint = BaseUrl + "questions/";
  static const _answersEndPoint = BaseUrl + "answers/";
  static Future<ApiResult> createNewQuestion(QuestionsModel model) async {
    print("hitting $_questionsEndPoint ${model.toMap()}");
    try {
      var result = await http.post(_questionsEndPoint,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode(
            model.toMap(),
          ));

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('failed');
      }
    } catch (e) {
      print(e);
      return ApiResult.failure(e);
    }
  }

  static Future<List<QuestionsModel>> fetchQuestions() async {
    var result = await http.get(
      _questionsEndPoint + 'unblocked',
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json"
      },
    );

    if (result.statusCode == 200) {
      return questionsModelFromMap(result.body);
    } else {
      print(result.body);
      throw 'Something went wrong';
    }
  }

  static Future<List<QuestionsModel>> myQuestions(String userId) async {
    var result = await http.get(
      _questionsEndPoint + 'unblocked/' + userId,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json"
      },
    );

    if (result.statusCode == 200) {
      return questionsModelFromMap(result.body);
    } else {
      print(result.body);
      throw 'Something went wrong';
    }
  }

  static Future<List<AnswersModel>> fetchAnswers(String questionId) async {
    try {
      var result = await http.get(_answersEndPoint + 'unblocked/$questionId');
      if (result.statusCode == 200) {
        return answersModelFromMap(result.body);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<ApiResult> createAnswer(
    String questionId,
    String answer, {
    bool isPrivateAnswer,
  }) async {
    try {
      var result = await http.post(
        _answersEndPoint,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode({
          "questionId": questionId,
          "creatorId": AppConfig.userId,
          "answer": answer,
          "privateAnswer": isPrivateAnswer,
          "isBlocked": false,
        }),
      );
      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        throw result.body;
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> deleteQuestion(String questionId) async {
    try {
      var result = await http.delete(_questionsEndPoint + questionId);
      if (result.statusCode == 200) {
        return ApiResult.successWithNoMessage();
      } else {
        print(result.body);
        return ApiResult.failure('something went wrong');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> deleteAnswer(String answerId) async {
    print("hitting api ${_answersEndPoint + answerId}");
    try {
      var result = await http.delete(_answersEndPoint + answerId);
      if (result.statusCode == 200) {
        return ApiResult.successWithNoMessage();
      } else {
        print(result.body);
        return ApiResult.failure('something went wrong');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<int> getCountOfAnswersByUser(String userId) async {
    try {
      print(_answersEndPoint + 'users/$userId');
      var result =
          await http.get(_answersEndPoint + 'user/${AppConfig.userId}');
      print(result.statusCode);
      if (result.statusCode == 200) {
        return json.decode(result.body)['count'];
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
