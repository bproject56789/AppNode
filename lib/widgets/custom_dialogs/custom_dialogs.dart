import 'package:flutter/material.dart';

class CustomDialogs {
  static Future<bool> generalConfirmationDialogWithMessage(
    BuildContext context,
    String title, {
    Widget actionButton,
  }) async {
    return showDialog(
          context: context,
          builder: (_context) => AlertDialog(
            title: Text(title),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(_context).pop(false);
                },
                child: Text("No"),
              ),
              actionButton != null ? actionButton : Container(),
              FlatButton(
                onPressed: () {
                  Navigator.of(_context).pop(true);
                },
                child: Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// return true when close button is pressed
  static Future<bool> generalDialogWithCloseButton(
    BuildContext context,
    String title,
  ) async {
    return showDialog(
          context: context,
          builder: (_context) => AlertDialog(
            title: Text(title),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(_context).pop(true);
                },
                child: Text("Close"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
