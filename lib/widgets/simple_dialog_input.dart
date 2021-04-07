import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/values/strings.dart';

Future<String> openInputDialog(
  BuildContext context, {
  String initialValue,
  String hintText,
  Function(String) validator,
  int maxLength,
  List<TextInputFormatter> formatters,
}) async {
  TextEditingController controller = TextEditingController(text: initialValue);
  final _key = GlobalKey<FormState>();
  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        content: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  maxLength: maxLength,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                  ),
                  validator: validator != null
                      ? validator
                      : (v) => v == null || v.isEmpty
                          ? Strings.fieldCantBeEmpty
                          : null,
                  inputFormatters: formatters,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                  FlatButton(
                    child: Text("Submit"),
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        Navigator.of(context).pop(controller.text);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<Gender> openGenderSelect(
  BuildContext context, {
  Gender initialValue,
}) async {
  return await showDialog<Gender>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select you gender"),
              SizedBox(height: 8),
              ListBody(
                children: Gender.values
                    .map(
                      (e) => RaisedButton(
                        color: e == initialValue
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          e.label,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(e);
                        },
                      ),
                    )
                    .toList(),
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
