import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ylc/ui/questions_module/bloc/answers_bloc.dart';
import 'package:ylc/utils/api_result.dart';
import 'package:ylc/values/strings.dart';

class AnswerQuestion extends StatefulWidget {
  final String questionId;

  const AnswerQuestion({Key key, this.questionId}) : super(key: key);
  @override
  _AnswerQuestionPageState createState() => _AnswerQuestionPageState();
}

class _AnswerQuestionPageState extends State<AnswerQuestion> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  AnswersBloc bloc;
  bool isPrivate = false;

  @override
  void initState() {
    bloc = AnswersBloc(widget.questionId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.answer),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: Strings.writeYourAnswer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                validator: (v) => v == null || v.isEmpty
                    ? Strings.fieldCantBeLeftBlank
                    : null,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isPrivate,
                    onChanged: (_) {
                      setState(() {
                        isPrivate = !isPrivate;
                      });
                    },
                  ),
                  Text(Strings.answerPrivately),
                ],
              ),
              SizedBox(height: 40),
              RaisedButton(
                child: Text(Strings.answer),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () async {
                  if (controller.text != null && controller.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });

                    ApiResult result = await bloc.createAnswer(
                      answer: controller.text,
                      isPrivate: isPrivate,
                    );
                    if (result.isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            Strings.yourAnswerHasBeenPosted,
                          ),
                        ),
                      );
                      Future.delayed(Duration(seconds: 1)).then(
                        (value) => Navigator.pop(context),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Strings.generalError),
                        ),
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
