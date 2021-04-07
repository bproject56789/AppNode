import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final bool isLoading;
  final bool disableTouch;
  final Widget child;

  const LoadingView({
    Key key,
    this.isLoading = false,
    this.disableTouch = true,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(absorbing: isLoading && disableTouch, child: child),
        isLoading ? LoadingIndicator() : SizedBox.shrink(),
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
