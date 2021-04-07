import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:ylc/api/questions_api.dart';
import 'package:ylc/models/data_models/questions_model.dart';

class QuestionsBloc {
  final _questions = BehaviorSubject<List<QuestionsModel>>();
  Timer _timer;

  Stream<List<QuestionsModel>> get questions => _questions.stream;

  void init({String userId}) {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        var questions = userId == null
            ? await QuestionsApi.fetchQuestions()
            : await QuestionsApi.myQuestions(userId);
        if (questions != null) {
          _questions.add(questions);
        }
      } on Exception catch (e) {
        _questions.addError(e);
      }
    });
  }

  void dispose() {
    _questions.close();
    _timer?.cancel();
  }
}
