import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ylc/keys/keys.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/consultation_type.dart';
import 'package:ylc/ui/consultation/bloc/consultation_bloc.dart';
import 'package:ylc/ui/consultation/consultation_charge_page.dart';
import 'package:ylc/ui/consultation/my_consultations.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/utils/helpers.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

class AdvocateProfileConsultationView extends StatefulWidget {
  @override
  _AdvocateProfileConsultationViewState createState() =>
      _AdvocateProfileConsultationViewState();
}

class _AdvocateProfileConsultationViewState
    extends State<AdvocateProfileConsultationView> {
  ConsultationBloc bloc;
  final _razorpay = Razorpay();
  int duration;
  DateTime startTime;
  ConsultationType selectedType;

  @override
  void initState() {
    super.initState();
    bloc = ConsultationBloc();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(startTime);
    bloc
        .createConsultation(
      advocateId: Provider.of<UserModel>(context, listen: false).id,
      userId: AppConfig.userId,
      duration: duration,
      startTime: startTime,
      type: selectedType,
      paymentId: response.paymentId,
    )
        .then(
      (result) {
        showSnackBar(
          context,
          result: result,
          message: Strings.consultationBooked,
        );
        navigateToPage(
          context,
          MyConsultations(),
        );
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    String message = Strings.paymentFailed;
    try {
      message = json.decode(response.message)["error"]["description"];
    } catch (e) {
      print(e);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  @override
  void dispose() {
    bloc.dispose();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context);
    bool isUserProfile = AppConfig.userId == userModel.id;
    var consultationCharges = userModel.advocateDetails.consultationCharges;

    if (consultationCharges == null) {
      return Center(
        child: Text("Advocate Consultation not set up"),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ConsultationCard(
            leading: Icons.message,
            title: Strings.messageConsultation,
            subtitle: Strings.messageConsultationSubtitle,
            price: consultationCharges.chat.price,
            time: consultationCharges.chat.time,
            onPressed: () => onTap(
              consultationCharges.chat.price,
              consultationCharges.chat.time,
              ConsultationType.Chat,
            ),
            buttonText: isUserProfile ? Strings.modify : Strings.book,
          ),
          ConsultationCard(
            leading: Icons.video_call,
            title: Strings.videoConsultation,
            subtitle: Strings.videoConsultationSubtitle,
            price: consultationCharges.video.price,
            time: consultationCharges.video.time,
            onPressed: () => onTap(
              consultationCharges.video.price,
              consultationCharges.video.time,
              ConsultationType.Video,
            ),
            buttonText: isUserProfile ? Strings.modify : Strings.book,
          ),
          ConsultationCard(
            leading: Icons.call,
            title: Strings.voiceConsultation,
            subtitle: Strings.voiceConsultationSubtitle,
            price: consultationCharges.voice.price,
            time: consultationCharges.voice.time,
            onPressed: () => onTap(
              consultationCharges.voice.price,
              consultationCharges.voice.time,
              ConsultationType.Call,
            ),
            buttonText: isUserProfile ? Strings.modify : Strings.book,
          ),
        ],
      ),
    );
  }

  void openRazorPay(int price, ConsultationType type) {
    var options = {
      'key': RazorPayId,
      'amount': price * 100,
      'name': AppConfig.userName,
      'description': "${type.label} ${Strings.consultation}",
      'timeout': 120,
    };
    _razorpay.open(options);
  }

  Future<void> onTap(int price, int duration, ConsultationType type) async {
    var userModel = Provider.of<UserModel>(context, listen: false);

    if (AppConfig.userId == userModel.id) {
      navigateToPage(
        context,
        ConsultationChargesPage(
          model: userModel,
        ),
      );
    } else {
      var now = DateTime.now();
      var date = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(
          Duration(hours: 2160),
        ), //allows 3 months time in future
      );

      if (date == null) {
        return;
      }

      var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time == null) {
        return;
      }

      startTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);

      if (startTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Looks like you selected a date in past.'),
          ),
        );
      } else {
        this.duration = duration;
        selectedType = type;
        openRazorPay(price, type);
      }
    }
  }
}

class ConsultationCard extends StatelessWidget {
  final IconData leading;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final int price;
  final int time;
  final String buttonText;

  const ConsultationCard(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.onPressed,
      this.price,
      this.time,
      this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(leading),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "₹ ",
                          style: TextStyle(color: Colors.purple),
                        ),
                        TextSpan(
                          text: "$price/-",
                          style: TextStyle(color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 4),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.purple,
                              size: 14,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: "$time Hours",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: onPressed,
              color: Colors.red,
              child: Text(
                buttonText,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
