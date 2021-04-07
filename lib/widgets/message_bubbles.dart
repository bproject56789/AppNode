import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final bool isSent;
  final String message;
  final int timestamp;

  const MessageBubble({
    Key key,
    this.isSent,
    this.message,
    this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Container(
            decoration: isSent
                ? MessageDecoration.sendDecoration()
                : MessageDecoration.receiveDecoration(),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(message),
                Text(
                  DateFormat.jm()
                      .format(DateTime.fromMillisecondsSinceEpoch(timestamp)),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageDecoration {
  static BoxDecoration sendDecoration() {
    return BoxDecoration(
      color: Colors.indigo[200],
      border: Border.all(width: 0.1),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(15),
        topLeft: Radius.circular(8),
      ),
    );
  }

  static BoxDecoration receiveDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(width: 0.1),
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(15),
          topRight: Radius.circular(8)),
    );
  }
}
