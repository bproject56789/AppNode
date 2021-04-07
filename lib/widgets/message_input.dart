import 'dart:developer';

import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController _textController;
  final ValueChanged<String> _handleChange;
  final VoidCallback onCameraPressed;
  final VoidCallback onSend;
  final String hintText;
  final String errorText;
  final bool hideCameraIcon;

  MessageInput({
    @required TextEditingController textController,
    @required ValueChanged<String> handleSubmitted,
    ValueChanged<String> handleChange,
    this.onCameraPressed,
    this.onSend,
    this.hintText,
    this.hideCameraIcon = false,
    this.errorText,
  })  : _textController = textController,
        _handleChange = handleChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            constraints: BoxConstraints.loose(
              Size(MediaQuery.of(context).size.width, 150),
            ),
            color: Colors.white,
            width: MediaQuery.of(context).size.width - 75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      //  errorText: errorText,
                      hintText: hintText,
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    controller: _textController,
                    // onSubmitted: _handleSubmitted,
                    onChanged: (String text) {
                      if (_handleChange == null) {
                        return;
                      }
                      _handleChange(text);
                    },
                  ),
                ),
                Offstage(
                  offstage: hideCameraIcon,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    color: Theme.of(context).hintColor,
                    onPressed: onCameraPressed ??
                        () {
                          log('Camera pressed');
                        },
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: onSend,
          child: CircleAvatar(
            radius: 24,
            child: Icon(Icons.send),
            backgroundColor: Theme.of(context).accentColor,
            foregroundColor: Colors.white,
          ),
        ),
        Spacer(),
      ],
    );
  }
}
