import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/services/upload_service.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/camera_page.dart';
import 'package:ylc/widgets/loading_view.dart';
import 'package:ylc/widgets/profile_image.dart';
import 'package:ylc/widgets/simple_dialog_input.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isLoading = false;
  UserModel user;

  void changeLoadingStatus(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: LoadingView(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                try {
                                  openCamera(context).then(
                                    (value) {
                                      if (value != null) {
                                        changeLoadingStatus(true);
                                        UploadService.uploadImageToFirebase(
                                          value,
                                        ).then((url) async {
                                          await UserApi.changeProfilePhoto(
                                            user.id,
                                            url,
                                          ).then((value) {
                                            if (value.isSuccess) {
                                              Auth.updateUser(
                                                Provider.of<UserModel>(context,
                                                        listen: false)
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(Strings.generalError),
                                    ),
                                  );
                                  changeLoadingStatus(false);
                                }
                              },
                              child: ProfileImage.lightColor(
                                photo: user.photo,
                                radius: 40,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              user.name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText("Basic Information"),
                    userDetails(
                      CustomIcons.user,
                      "Gender",
                      user.additionalDetails?.gender?.label,
                      onTap: () async {
                        Gender result = await openGenderSelect(context);
                        if (result != null &&
                            result != user.additionalDetails?.gender) {
                          var details = user.additionalDetails.copyWith(
                            gender: result,
                          );
                          UserApi.updateAdditionalDetails(user.id, details)
                              .then(
                            (value) {
                              if (value.isSuccess) {
                                Auth.updateUser(
                                  Provider.of<UserModel>(context, listen: false)
                                      .copyWith(additionalDetails: details),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    userDetails(
                      CustomIcons.calendar,
                      "Date of Birth",
                      user.additionalDetails?.dateOfBirth != null
                          ? DateFormat.yMMMd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                user.additionalDetails?.dateOfBirth,
                              ),
                            )
                          : '',
                      onTap: () async {
                        var result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1920, 1, 1),
                          lastDate: DateTime.now(),
                        );
                        if (result != null) {
                          var details = user.additionalDetails.copyWith(
                            dateOfBirth: result.millisecondsSinceEpoch,
                          );
                          UserApi.updateAdditionalDetails(user.id, details)
                              .then(
                            (value) {
                              if (value.isSuccess) {
                                Auth.updateUser(
                                  Provider.of<UserModel>(context, listen: false)
                                      .copyWith(additionalDetails: details),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    headingText("Location Information"),
                    userDetails(
                      CustomIcons.address,
                      "Address",
                      user.additionalDetails?.address,
                      onTap: () async {
                        var result = await openInputDialog(
                          context,
                          initialValue: user.additionalDetails?.address,
                          hintText: Strings.addressHint,
                        );
                        if (result != null) {
                          var details =
                              user.additionalDetails.copyWith(address: result);
                          UserApi.updateAdditionalDetails(user.id, details)
                              .then(
                            (value) {
                              if (value.isSuccess) {
                                Auth.updateUser(
                                  Provider.of<UserModel>(context, listen: false)
                                      .copyWith(additionalDetails: details),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    userDetails(
                      CustomIcons.city,
                      "City",
                      user.additionalDetails?.city,
                      onTap: () async {
                        var result = await openInputDialog(
                          context,
                          initialValue: user.additionalDetails?.city,
                          hintText: Strings.cityHint,
                        );
                        if (result != null) {
                          var details =
                              user.additionalDetails.copyWith(city: result);
                          UserApi.updateAdditionalDetails(user.id, details)
                              .then(
                            (value) {
                              if (value.isSuccess) {
                                Auth.updateUser(
                                  Provider.of<UserModel>(context, listen: false)
                                      .copyWith(additionalDetails: details),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    userDetails(
                      CustomIcons.government,
                      "State",
                      user.additionalDetails?.state,
                      onTap: () async {
                        var result = await openInputDialog(
                          context,
                          initialValue: user.additionalDetails?.state,
                          hintText: Strings.stateHint,
                        );
                        if (result != null) {
                          var details =
                              user.additionalDetails.copyWith(state: result);
                          UserApi.updateAdditionalDetails(user.id, details)
                              .then(
                            (value) {
                              if (value.isSuccess) {
                                Auth.updateUser(
                                  Provider.of<UserModel>(context, listen: false)
                                      .copyWith(additionalDetails: details),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headingText(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(color: YlcColors.textColor1, fontSize: 18),
      ),
    );
  }

  Widget userDetails(
    String image,
    String labelText,
    String value, {
    VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: YlcColors.textColor1, width: 2),
        ),
      ),
      child: ListTile(
        leading: Image.asset(image),
        title: Text(
          labelText,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(value ?? ''),
        onTap: onTap,
      ),
    );
  }
}
