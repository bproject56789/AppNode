import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:ylc/api/review_api.dart';
import 'package:ylc/models/data_models/review_model.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/ui/reviews/give_review.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/widgets/navigaton_helper.dart';
import 'package:ylc/widgets/profile_image.dart';

class ReviewListingPage extends StatefulWidget {
  @override
  _ReviewListingPageState createState() => _ReviewListingPageState();
}

class _ReviewListingPageState extends State<ReviewListingPage> {
  final _controller = BehaviorSubject<List<ReviewModel>>();
  Timer _timer;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ReviewApi.fetchUserReviews(
        Provider.of<UserModel>(context, listen: false).id,
      ).then((value) {
        if (value != null) {
          _controller.add(value);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var advocateDetails = Provider.of<UserModel>(context);
    return Scaffold(
      floatingActionButton: advocateDetails.id == AppConfig.userId
          ? null
          : RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("Give Review"),
              onPressed: () {
                navigateToPage(
                  context,
                  GiveReviewPage(
                    reviewedId: advocateDetails.id,
                  ),
                );
              },
            ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.isEmpty) {
            return Center(child: Text("No Reviews"));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var model = snapshot.data[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ProfileImage(photo: model.creatorDetails.photo),
                          SizedBox(width: 12),
                          Text(model.creatorDetails.name),
                        ],
                      ),
                      SizedBox(height: 8),
                      SmoothStarRating(
                        rating: model.rating,
                        color: Colors.yellow,
                        isReadOnly: true,
                      ),
                      SizedBox(height: 8),
                      Text(model.review),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
