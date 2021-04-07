import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/chat_api.dart';
import 'package:ylc/models/data_models/chat_model.dart';
import 'package:ylc/models/data_models/message_model.dart';
import 'package:ylc/ui/chat/bloc/chat_bloc.dart';
import 'package:ylc/ui/chat/bloc/message_bloc.dart';
import 'package:ylc/utils/helpers.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/countdown.dart';
import 'package:ylc/widgets/message_bubbles.dart';
import 'package:ylc/widgets/message_input.dart';
import 'package:ylc/widgets/profile_image.dart';

import '../../user_config.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  ChatPage({
    Key key,
    this.chatId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  MessageModel messageModel = MessageModel();
  final TextEditingController textcontroller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  String senderId;
  String recieverId;
  final MessageBloc _bloc = MessageBloc();
  ChatModel chatModel;
  bool isChatOpen = true;
  Timer timer;
  @override
  void initState() {
    _bloc.init(widget.chatId);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var chatModel = Provider.of<ChatBloc>(context, listen: false)
          .getChatModel(widget.chatId);

      var timeRemaining = getRemainingTime(chatModel.endTime);

      log("time remaining $timeRemaining");
      timer = Timer(timeRemaining, () {
        if (mounted)
          setState(() {
            isChatOpen = false;
          });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    chatModel = Provider.of<ChatBloc>(context, listen: false)
        .getChatModel(widget.chatId);
    senderId = AppConfig.userId;
    recieverId = chatModel.participants.firstWhere((id) => id != senderId);
    var recieverDetails = chatModel.participantDetails.firstWhere(
      (element) => element.id != senderId,
    );
    isChatOpen = chatModel.endTime > DateTime.now().millisecondsSinceEpoch;
    var timeRemaining = getRemainingTime(chatModel.endTime);

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 24,
        title: Row(
          children: [
            ProfileImage.lightColor(
              radius: 18,
              photo: recieverDetails.photo,
            ),
            SizedBox(width: 8),
            Text(recieverDetails.name),
            Spacer(),
            timeRemaining.isNegative
                ? Container()
                : CountdownFormatted(
                    duration: timeRemaining,
                    builder: (BuildContext ctx, String remaining) {
                      return Text(remaining);
                    },
                  ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _bloc.messages,
              builder: (BuildContext _context,
                  AsyncSnapshot<List<MessageModel>> snapshot) {
                if (snapshot.hasError) {
                  _scrollToBottom();
                  return Text(
                    Strings.generalError,
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data.length == 0) {
                  return Center(
                    child: Text(
                      Strings.noMessages,
                    ),
                  );
                }

                if (chatModel.unreadStatus != null &&
                    chatModel.unreadStatus.containsKey(senderId)) {
                  ChatApi.markMessageAsRead(
                    chatId: widget.chatId,
                    userId: senderId,
                  );
                }

                _scrollToBottom();

                return Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, int index) {
                      MessageModel messageModel = snapshot.data[index];

                      return MessageBubble(
                        message: messageModel.message,
                        isSent: messageModel.fromId == senderId,
                        timestamp: messageModel.timestamp,
                      );

                      //   case MessageType.IMAGE:
                      //     return ImageBubble(
                      //       messageModel: messageModel,
                      //       isSent: messageModel.fromId == widget.senderId,
                      //       isGroupMessage: chatModel.isGroupMessage,
                      //       info: chatModel.isGroupMessage
                      //           ? participantsInfoById[messageModel.fromId]
                      //           : null,
                      //     );
                      //     break;
                      //   case MessageType.URL:
                      //     return Container(child: Text("url"));
                      //     break;
                      //   default:
                      //     return Container(child: Text("error"));
                      //     break;
                      // }
                    },
                  ),
                );
              },
            ),
          ),
          isChatOpen
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 5),
                  child: MessageInput(
                    handleSubmitted: (value) {},
                    textController: textcontroller,
                    handleChange: (String value) {},
                    hintText: Strings.typeMessage,
                    // onCameraPressed: () async {
                    //   List<CameraDescription> cameras = await availableCameras();
                    //   Navigator.of(context)
                    //       .push<ImageCaptionModel>(
                    //     MaterialPageRoute(
                    //       builder: (context) => CameraPage(cameras: cameras),
                    //     ),
                    //   )
                    //       .then((ImageCaptionModel model) {
                    //     if (model != null) {
                    //       pushNewMessage(
                    //         messageContent: model.caption.isEmpty
                    //             ? 'Shared an image'
                    //             : model.caption,
                    //         type: MessageType.IMAGE,
                    //         file: model.file,
                    //       );
                    //     }
                    //   });
                    // },
                    onSend: () {
                      if (textcontroller.text != null &&
                          textcontroller.text.isNotEmpty) {
                        pushNewMessage(
                          userId: senderId,
                          recieverId: recieverId,
                          messageContent: textcontroller.text,
                          type: MessageType.MESSAGE,
                        );
                      }
                    },
                  ))
              : Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Your session has expired",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController?.position?.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void pushNewMessage({
    String userId,
    String recieverId,
    String messageContent,
    MessageType type,
  }) {
    _bloc.pushNewMessage(
      chatId: widget.chatId,
      messageContent: messageContent,
      senderId: userId,
      recieverId: recieverId,
      type: type,
    );

    textcontroller.clear();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _bloc.dispose();
    timer?.cancel();
    super.dispose();
  }
}
