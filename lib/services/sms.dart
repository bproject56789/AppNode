import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:ylc/keys/keys.dart';
import 'package:ylc/values/strings.dart';

Future<int> sendOtp(String number) async {
  var username = TWILIO_SID;
  var password = TWILIO_AUTH;
  var authn = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

  int n = 1000 + Random.secure().nextInt(8999);
  try {
    var res = await http.post(
        'https://api.twilio.com/2010-04-01/Accounts/$username/Messages.json',
        headers: {
          'authorization': authn
        },
        body: {
          "From": "+18317041205",
          "To": "+91" + number,
          "Body": "Your otp for ${Strings.yourLegalConsultancy} is $n"
        });
    print(res.statusCode);
    print(res.body);
  } on Exception catch (e) {
    print(e);
  }

  // if (res.statusCode != 200) throw Exception('post error: statusCode= ${res.statusCode}');

  return n;
}
