import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/questions_api.dart';
import 'package:ylc/models/data_models/answers_model.dart';
import 'package:ylc/models/data_models/questions_model.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/ui/questions_module/bloc/answers_bloc.dart';
import 'package:ylc/ui/questions_module/screens/answer_question.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/custom_dialogs/custom_dialogs.dart';
import 'package:ylc/widgets/hide_widget.dart';
import 'package:ylc/widgets/navigaton_helper.dart';
import 'package:ylc/widgets/profile_image.dart';

class AnswersPage extends StatefulWidget {
  final QuestionsModel questionsModel;

  const AnswersPage({Key key, this.questionsModel}) : super(key: key);

  @override
  _AnswersPageState createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  AnswersBloc bloc;
  @override
  void initState() {
    bloc = AnswersBloc(widget.questionsModel.id);
    bloc.init(widget.questionsModel.id);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool isCreator = widget.questionsModel.creatorId == userModel.id;
    return Scaffold(
      // floatingActionButton: widget.questionsModel.creatorId == userModel.id ||
      //         !userModel.isAdvocate
      //     ? null
      //     :
      floatingActionButton: RaisedButton(
        child: Text(Strings.answer),
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          navigateToPage(
            context,
            AnswerQuestion(
              questionId: widget.questionsModel.id,
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text(
          Strings.answers,
        ),
        actions: isCreator
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    if (await CustomDialogs
                        .generalConfirmationDialogWithMessage(
                      context,
                      "Are you sure you want delete this question?",
                    )) {
                      QuestionsApi.deleteQuestion(
                        widget.questionsModel.id,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 8,
                    ),
                    child: Text(widget.questionsModel.question),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 12),
              StreamBuilder<List<AnswersModel>>(
                stream: bloc.answers,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(Strings.noAnswers),
                    );
                  }
                  print(userModel.id);
                  return ListBody(
                    children: snapshot.data
                        .map(
                          (a) => Offstage(
                            offstage: a.privateAnswer &&
                                !(a.creatorDetails.id == userModel.id ||
                                    widget.questionsModel.creatorId ==
                                        userModel.id),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 20,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProfileImage.lightColor(
                                      photo: a.creatorDetails.photo,
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(a.answer),
                                        SizedBox(height: 8),
                                        Text(
                                          '- ' + a.creatorDetails.name,
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    HideWidget(
                                      hide: a.creatorDetails.id != userModel.id,
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          if (await CustomDialogs
                                              .generalConfirmationDialogWithMessage(
                                                  context,
                                                  "Are you sure you want to delete this answer?")) {
                                            QuestionsApi.deleteAnswer(
                                              a.id,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
