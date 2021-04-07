import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/utils/regex.dart';
import 'package:ylc/values/strings.dart';

class ConsultationChargesPage extends StatefulWidget {
  final UserModel model;

  const ConsultationChargesPage({Key key, this.model}) : super(key: key);
  @override
  _ConsultationChargesPageState createState() =>
      _ConsultationChargesPageState();
}

class _ConsultationChargesPageState extends State<ConsultationChargesPage> {
  TextEditingController videoTime;
  TextEditingController callTime;
  TextEditingController chatTime;

  TextEditingController videoPrice;
  TextEditingController callPrice;
  TextEditingController chatPrice;

  @override
  void initState() {
    if (widget.model != null) {
      var details = widget.model.advocateDetails.consultationCharges;
      videoTime = TextEditingController(text: details.video.time.toString());
      callTime = TextEditingController(text: details.voice.time.toString());
      chatTime = TextEditingController(text: details.chat.time.toString());

      videoPrice = TextEditingController(text: details.video.price.toString());
      callPrice = TextEditingController(text: details.voice.price.toString());
      chatPrice = TextEditingController(text: details.chat.price.toString());
    } else {
      videoTime = TextEditingController();
      callTime = TextEditingController();
      chatTime = TextEditingController();

      videoPrice = TextEditingController();
      callPrice = TextEditingController();
      chatPrice = TextEditingController();
    }
    super.initState();
  }

  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultation Charges"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              ConsultationInputWidget(
                time: videoTime,
                price: videoPrice,
                heading: Strings.videoConsultation,
              ),
              SizedBox(height: 8),
              ConsultationInputWidget(
                time: callTime,
                price: callPrice,
                heading: Strings.voiceConsultation,
              ),
              SizedBox(height: 8),
              ConsultationInputWidget(
                time: chatTime,
                price: chatPrice,
                heading: Strings.messageConsultation,
              ),
              SizedBox(height: 30),
              RaisedButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("Save"),
                onPressed: () async {
                  if (_key.currentState.validate()) {
                    ConsultationCharges consultationCharges =
                        ConsultationCharges(
                      video: Charges(
                        price: int.parse(videoPrice.text),
                        time: int.parse(videoTime.text),
                      ),
                      voice: Charges(
                        price: int.parse(callPrice.text),
                        time: int.parse(callTime.text),
                      ),
                      chat: Charges(
                        price: int.parse(chatPrice.text),
                        time: int.parse(chatTime.text),
                      ),
                    );
                    var user = Provider.of<UserModel>(context, listen: false);
                    var details = user.advocateDetails
                        .copyWith(consultationCharges: consultationCharges);
                    await UserApi.updateAdvocateDetails(
                      user.id,
                      details,
                    );
                    Auth.updateUser(
                      user.copyWith(advocateDetails: details),
                    );
                    if (widget.model != null) {
                      Navigator.of(context).maybePop();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConsultationInputWidget extends StatelessWidget {
  const ConsultationInputWidget({
    Key key,
    @required this.time,
    @required this.price,
    this.heading,
  }) : super(key: key);

  final String heading;
  final TextEditingController time;
  final TextEditingController price;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              heading,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: CustomConsultationTextField(
                    controller: time,
                    hintText: "Time in hours",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return Strings.fieldCantBeEmpty;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: CustomConsultationTextField(
                    controller: price,
                    hintText: "Cost",
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return Strings.fieldCantBeEmpty;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomConsultationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> validator;
  const CustomConsultationTextField({
    Key key,
    this.controller,
    this.hintText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(Regex.onlyNumberInput),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        hintText: hintText,
      ),
      validator: validator,
    );
  }
}
