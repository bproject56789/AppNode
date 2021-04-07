import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<T> navigateToPage<T>(context, Widget page) async {
  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future<T> navigateToPageWithProvider<T, P>(
  context,
  Widget page,
) async {
  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (_context) => Provider.value(
        value: Provider.of<P>(context),
        child: page,
      ),
    ),
  );
}
