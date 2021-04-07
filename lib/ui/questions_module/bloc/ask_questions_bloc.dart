import 'package:ylc/api/questions_api.dart';
import 'package:ylc/models/data_models/questions_model.dart';

class AskQuestionBloc {
  Future<bool> askQuestion({
    String question,
    String creatorId,
  }) async {
    return (await QuestionsApi.createNewQuestion(
      QuestionsModel(
        question: question,
        creatorId: creatorId,
        totalAnswers: 0,
      ),
    ))
        .isSuccess;
  }
}
