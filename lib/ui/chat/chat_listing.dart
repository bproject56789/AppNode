import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/models/data_models/chat_model.dart';
import 'package:ylc/ui/chat/bloc/chat_bloc.dart';
import 'package:ylc/ui/chat/chat_page.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/navigaton_helper.dart';
import 'package:ylc/widgets/profile_image.dart';

import '../../user_config.dart';

class ChatListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = AppConfig.userId;
    return Scaffold(
      appBar: AppBar(title: Text(Strings.chat)),
      body: StreamBuilder<List<ChatModel>>(
        stream: Provider.of<ChatBloc>(context).chats,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(Strings.generalError));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(child: Text(Strings.noChat));
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var chat = snapshot.data[index];

              var details = chat.participantDetails
                  .firstWhere((element) => element.id != userId);
              return ListTile(
                leading: ProfileImage.darkColor(
                  photo: details.photo,
                ),
                title: Text(details.name),
                subtitle: Text(chat.lastMessage ?? "No Message"),
                onTap: () {
                  navigateToPage(
                    context,
                    ChatPage(chatId: chat.id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
