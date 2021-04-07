import 'package:flutter/material.dart';
import 'package:ylc/values/strings.dart';

class StreamDataBuilder extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final Widget Function(AsyncSnapshot) builder;

  const StreamDataBuilder({Key key, this.snapshot, this.builder})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Center(
        child: Text(Strings.generalError),
      );
    } else if (snapshot.connectionState == ConnectionState.waiting ||
        snapshot.data == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return builder(snapshot);
    }
  }
}
