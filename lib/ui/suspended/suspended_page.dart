import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/values/colors.dart';

class SuspendedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YlcColors.categoryBackGround,
      body: Container(
        padding: const EdgeInsets.all(12.0),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your account has been suspended by YLC as it violated YLC's policies.Till the issue is resolved you wont be able to use your account.Please contact the support team for more information.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("Logout"),
              onPressed: () async {
                var result = await Auth.signOut();
                if (result.isSuccess) {
                  Phoenix.rebirth(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
