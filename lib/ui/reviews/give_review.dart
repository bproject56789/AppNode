import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:ylc/api/review_api.dart';
import 'package:ylc/values/strings.dart';

class GiveReviewPage extends StatefulWidget {
  final String reviewedId;

  const GiveReviewPage({Key key, this.reviewedId}) : super(key: key);
  @override
  _GiveReviewPageState createState() => _GiveReviewPageState();
}

class _GiveReviewPageState extends State<GiveReviewPage> {
  bool isLoading = false;
  bool isButtonEnabled = false;
  double rating;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.writeReview),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: Strings.writeReviewHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                validator: (v) => v == null || v.isEmpty
                    ? Strings.askQuestionValidation
                    : null,
              ),
              SizedBox(height: 20),
              SmoothStarRating(
                color: Colors.yellow,
                borderColor: Theme.of(context).primaryColor,
                size: 35,
                onRated: (value) {
                  rating = value;
                },
              ),
              SizedBox(height: 40),
              RaisedButton(
                child: Text(Strings.postReview.toUpperCase()),
                onPressed: () async {
                  if (controller.text != null &&
                      controller.text.isNotEmpty &&
                      rating != null) {
                    setState(() {
                      isLoading = true;
                    });
                    var result = await ReviewApi.createReview(
                      rating: rating,
                      review: controller.text,
                      reviewedId: widget.reviewedId,
                    );
                    if (result.isSuccess) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Strings.writeReviewSuccess),
                        ),
                      );
                      Future.delayed(Duration(seconds: 1)).then(
                        (value) => Navigator.pop(context),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Strings.generalError),
                        ),
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
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
