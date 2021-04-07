import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/ui/questions_module/bloc/ask_questions_bloc.dart';
import 'package:ylc/values/strings.dart';

class AskQuestionsPage extends StatefulWidget {
  @override
  _AskQuestionsPageState createState() => _AskQuestionsPageState();
}

class _AskQuestionsPageState extends State<AskQuestionsPage> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  final AskQuestionBloc bloc = AskQuestionBloc();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.askQuestion),
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
                  hintText: Strings.askQuestionHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                validator: (v) => v == null || v.isEmpty
                    ? Strings.askQuestionValidation
                    : null,
              ),
              SizedBox(height: 40),
              RaisedButton(
                child: Text(Strings.postQuestion.toUpperCase()),
                onPressed: () async {
                  if (controller.text != null && controller.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    bool result = await bloc.askQuestion(
                      question: controller.text,
                      creatorId: Provider.of<UserModel>(
                        context,
                        listen: false,
                      ).id,
                    );
                    if (result) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Strings.yourQuestionHasBeenPosted),
                        ),
                      );
                      Future.delayed(Duration(seconds: 1)).then(
                        (value) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Navigator.pop(context);
                        },
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
