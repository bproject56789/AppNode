import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/services/upload_service.dart';
import 'package:ylc/ui/consultation/advocate_profile_consultation_view.dart';
import 'package:ylc/ui/profile/advocate_profile_tab_view.dart';
import 'package:ylc/ui/reviews/review_listing.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/camera_page.dart';
import 'package:ylc/widgets/loading_view.dart';
import 'package:ylc/widgets/profile_image.dart';

import '../../user_config.dart';

class AdvocateProfile extends StatefulWidget {
  @override
  _AdvocateProfileState createState() => _AdvocateProfileState();
}

class _AdvocateProfileState extends State<AdvocateProfile> {
  bool isLoading = false;
  bool isEditable = false;

  void changeLoadingStatus(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    isEditable = userModel.id == AppConfig.userId;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: LoadingView(
          isLoading: isLoading,
          child: Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      GeneralImages.profileBg,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        Column(
                          children: [
                            InkWell(
                              child: ProfileImage.lightColor(
                                photo: userModel.photo,
                                radius: 40,
                              ),
                              onTap: isEditable
                                  ? () {
                                      try {
                                        openCamera(context).then(
                                          (value) {
                                            if (value != null) {
                                              changeLoadingStatus(true);
                                              UploadService
                                                  .uploadImageToFirebase(
                                                value,
                                              ).then((url) async {
                                                await UserApi
                                                    .changeProfilePhoto(
                                                  userModel.id,
                                                  url,
                                                ).then((value) {
                                                  if (value.isSuccess) {
                                                    Auth.updateUser(
                                                      Provider.of<UserModel>(
                                                              context)
                                                          .copyWith(photo: url),
                                                    );
                                                  }
                                                });
                                                changeLoadingStatus(false);
                                              });
                                            }
                                          },
                                        );
                                      } on Exception catch (e) {
                                        print(e);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(Strings.generalError),
                                          ),
                                        );
                                        changeLoadingStatus(false);
                                      }
                                    }
                                  : null,
                            ),
                            SizedBox(height: 4),
                            Text(
                              userModel.name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    TabBar(
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          text: Strings.profile,
                          icon: Icon(Icons.person),
                        ),
                        Tab(
                          text: Strings.consultation,
                          icon: Icon(Icons.add),
                        ),
                        Tab(
                          text: Strings.reviews,
                          icon: Icon(Icons.rate_review),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    AdvocateProfileTabView(
                      userModel: userModel,
                    ),
                    AdvocateProfileConsultationView(),
                    ReviewListingPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
