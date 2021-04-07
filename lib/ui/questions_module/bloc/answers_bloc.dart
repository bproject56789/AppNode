import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:ylc/api/questions_api.dart';
import 'package:ylc/models/data_models/answers_model.dart';
import 'package:ylc/utils/api_result.dart';

class AnswersBloc {
  final String questionId;
  AnswersBloc(this.questionId);
  Timer _timer;

  final _answers = BehaviorSubject<List<AnswersModel>>();

  Stream<List<AnswersModel>> get answers => _answers.stream;

  void init(String questionId) {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      var answers = await QuestionsApi.fetchAnswers(questionId);
      if (answers != null) {
        _answers.add(answers);
      } else {
        _answers.addError('Something went wrong');
      }
    });
  }

  Future<ApiResult> createAnswer({
    String answer,
    bool isPrivate = false,
  }) {
    return QuestionsApi.createAnswer(
      questionId,
      answer,
      isPrivateAnswer: isPrivate,
    );
  }

  void dispose() {
    _timer?.cancel();
    _answers.close();
  }
}
