import 'package:flutter/material.dart';
import 'package:ylc/models/data_models/questions_model.dart';
import 'package:ylc/ui/questions_module/bloc/question_bloc.dart';
import 'package:ylc/ui/questions_module/screens/answers_page.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

/// If [userId] is [null] then it displays all questions otherwise questions asked by that user only
class QuestionsPage extends StatefulWidget {
  final String userId;

  const QuestionsPage({Key key, this.userId}) : super(key: key);

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final QuestionsBloc bloc = QuestionsBloc();

  @override
  void initState() {
    print(widget.userId);
    bloc.init(userId: widget.userId);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userId == null ? Strings.questions : Strings.myQuestions,
        ),
      ),
      body: StreamBuilder<List<QuestionsModel>>(
        stream: bloc.questions,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(Strings.generalError),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.isEmpty) {
            return Center(
              child: Text(Strings.noQuestions),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data[index].question),
                    subtitle: Text(
                      "${snapshot.data[index].totalAnswers} ${Strings.answers}",
                    ),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      navigateToPage(
                        context,
                        AnswersPage(
                          questionsModel: snapshot.data[index],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
