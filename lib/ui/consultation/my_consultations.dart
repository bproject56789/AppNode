import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ylc/api/chat_api.dart';
import 'package:ylc/api/consultation_api.dart';
import 'package:ylc/models/data_models/chat_model.dart';
import 'package:ylc/models/data_models/consultation_model.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/consultation_type.dart';
import 'package:ylc/ui/call_module/video_call.dart';
import 'package:ylc/ui/chat/chat_page.dart';
import 'package:ylc/ui/consultation/bloc/consultation_bloc.dart';
import 'package:ylc/utils/helpers.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/consultation_card.dart';
import 'package:ylc/widgets/custom_dialogs/custom_dialogs.dart';
import 'package:ylc/widgets/loading_view.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

import '../../user_config.dart';

class MyConsultations extends StatefulWidget {
  @override
  _MyConsultationsState createState() => _MyConsultationsState();
}

class _MyConsultationsState extends State<MyConsultations> {
  ConsultationBloc bloc = ConsultationBloc();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bloc.init(AppConfig.userId);
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = AppConfig.userId;
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.consultation),
      ),
      body: StreamBuilder<List<ConsultationModel>>(
        stream: bloc.consultations,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(Strings.generalError),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          }

          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(
              child: Text(Strings.noConsultations),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              final model = snapshot.data[index];
              return ConsultationCard(
                model: model,
                onTap: () => onTap(
                  context,
                  model,
                  userId,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> createAndOpenChat(
    context,
    UserModel user,
    UserModel advocate,
    int endTime, {
    VoidCallback onChatCreate,
  }) async {
    List<String> participants = [user.id, advocate.id];
    participants.sort();
    ChatModel model = ChatModel(
      id: "${participants[0]}*${participants[1]}",
      participants: participants,
      participantDetails: [user.details, advocate.details],
      endTime: endTime,
    );

    await ChatApi.createChat(model);
    onChatCreate?.call();
    print(model.id);
    navigateToPage(context, ChatPage(chatId: model.id));
  }

  void onTap(context, ConsultationModel model, String userId) async {
    final isOver = DateTime.now().millisecondsSinceEpoch >= model.endTime;
    final inFuture = DateTime.now().millisecondsSinceEpoch < model.startTime;

    if (isOver) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'The consultation is over',
          ),
        ),
      );
      return;
    }

    if (model.acceptedByAdvocate && model.acceptedByUser) {
      if (inFuture) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'The consultation has not started yet',
            ),
          ),
        );
        return;
      }

      switch (model.type) {
        case ConsultationType.Video:
          await _handleCameraAndMic(Permission.camera);
          await _handleCameraAndMic(Permission.microphone);
          navigateToPage(
            context,
            VideoCallPage(
              model: model,
            ),
          );
          break;
        case ConsultationType.Call:
          await _handleCameraAndMic(Permission.camera);
          await _handleCameraAndMic(Permission.microphone);
          navigateToPage(
            context,
            VideoCallPage(
              model: model,
            ),
          );

          break;
        case ConsultationType.Chat:
          createAndOpenChat(
            context,
            model.userDetails,
            model.advocateDetails,
            model.endTime,
          );
          break;
      }
    } else {
      var duration = DateTime.fromMillisecondsSinceEpoch(model.endTime)
          .difference(DateTime.fromMillisecondsSinceEpoch(model.startTime));
      var now = DateTime.now();

      if (model.isAdvocate(userId)) {
        if (!model.acceptedByAdvocate) {
          CustomDialogs.generalConfirmationDialogWithMessage(
            context,
            "Please confirm the consulatation timing",
            actionButton: FlatButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                var startTime = await showDateTimePicker(context,
                    initialDate: model.startTime);
                if (startTime != null) {
                  ConsultationApi.changeConsultationTiming(
                    model.id,
                    startTime.millisecondsSinceEpoch,
                    startTime.add(duration).millisecondsSinceEpoch,
                    false,
                  );
                }
              },
              child: Text('Change'),
            ),
          ).then((value) {
            if (value != null && value) {
              if (model.startTime < now.millisecondsSinceEpoch) {
                ConsultationApi.acceptConsultationTiming(
                  model.id,
                  now.millisecondsSinceEpoch,
                  now.add(duration).millisecondsSinceEpoch,
                  false,
                );
              } else {
                ConsultationApi.acceptConsultationTiming(
                  model.id,
                  model.startTime,
                  model.endTime,
                  false,
                );
              }
            }
          });
        } else if (!model.acceptedByUser) {
          CustomDialogs.generalDialogWithCloseButton(
            context,
            "Waiting for the user to confirm the consultation timing",
          );
        }
      } else {
        if (!model.acceptedByUser) {
          CustomDialogs.generalConfirmationDialogWithMessage(
            context,
            "Please confirm the consulatation timing",
            actionButton: FlatButton(
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                var startTime = await showDateTimePicker(context,
                    initialDate: model.startTime);
                if (startTime != null) {
                  ConsultationApi.changeConsultationTiming(
                    model.id,
                    startTime.millisecondsSinceEpoch,
                    startTime.add(duration).millisecondsSinceEpoch,
                    true,
                  );
                }
              },
              child: Text('Change'),
            ),
          ).then((value) {
            if (value != null && value) {
              if (value) {
                if (model.startTime < now.millisecondsSinceEpoch) {
                  ConsultationApi.acceptConsultationTiming(
                    model.id,
                    now.millisecondsSinceEpoch,
                    now.add(duration).millisecondsSinceEpoch,
                    true,
                  );
                } else {
                  ConsultationApi.acceptConsultationTiming(
                    model.id,
                    model.startTime,
                    model.endTime,
                    true,
                  );
                }
              }
            }
          });
        } else if (!model.acceptedByAdvocate) {
          CustomDialogs.generalDialogWithCloseButton(
            context,
            "Waiting for the advocate to confirm the consultation timing",
          );
        }
      }
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
