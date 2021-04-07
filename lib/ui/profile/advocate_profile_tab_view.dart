import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ylc/api/questions_api.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/availability_enum.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/ui/onboarding/select_area_of_expertise.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/utils/regex.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/navigaton_helper.dart';
import 'package:ylc/widgets/simple_dialog_input.dart';

class AdvocateProfileTabView extends StatelessWidget {
  final color = YlcColors.textColor1;
  final UserModel userModel;

  const AdvocateProfileTabView({Key key, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingText(Strings.profileActivites),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: FutureBuilder(
                    future: QuestionsApi.getCountOfAnswersByUser(userModel.id),
                    builder: (_, snapshot) {
                      return activityBuilder(
                        title: Strings.answers,
                        subtitle: "${snapshot.data ?? 0}",
                      );
                    }),
              ),
              Expanded(
                child: activityBuilder(
                  title: Strings.followers,
                  subtitle: userModel.followedBy.length.toString(),
                  showVerticalBorder: true,
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: isLoggedInProfile(context)
                      ? () async {
                          var result = await openInputDialog(
                            context,
                            initialValue: userModel.advocateDetails?.experience
                                ?.toString(),
                            hintText: Strings.experienceHint,
                            validator: (v) => v.isNotEmpty && int.parse(v) != 0
                                ? null
                                : 'Enter valid experience',
                            formatters: [
                              FilteringTextInputFormatter.allow(
                                Regex.onlyNumberInput,
                              ),
                            ],
                          );
                          if (result != null) {
                            var details = userModel.advocateDetails
                                .copyWith(experience: int.parse(result));
                            UserApi.updateAdvocateDetails(
                                userModel.id, details);
                            Auth.updateUser(
                                userModel.copyWith(advocateDetails: details));
                          }
                        }
                      : null,
                  child: activityBuilder(
                    title: Strings.experience,
                    subtitle:
                        "${userModel.advocateDetails?.experience ?? 0} ${Strings.years}",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              headingText(Strings.availability),
              Spacer(),
              Text(Strings.allTimingHint),
              SizedBox(width: 12),
            ],
          ),
          availabilityBuilder(Availability.values),
          headingText(Strings.practiceAreas),
          Column(
            children: [
              ListTile(
                leading: Image.asset(CustomIcons.city),
                title: Text(Strings.serviceCities),
                subtitle: Text(userModel.advocateDetails?.serviceCities ?? ''),
                onTap: isLoggedInProfile(context)
                    ? () async {
                        var result = await openInputDialog(
                          context,
                          initialValue:
                              userModel.advocateDetails?.serviceCities,
                          hintText: Strings.serviceCityHint,
                        );
                        if (result != null) {
                          var details = userModel.advocateDetails
                              .copyWith(serviceCities: result);
                          UserApi.updateAdvocateDetails(userModel.id, details);
                          Auth.updateUser(
                              userModel.copyWith(advocateDetails: details));
                        }
                      }
                    : null,
              ),
              ListTile(
                leading: Image.asset(CustomIcons.law),
                title: Text(Strings.areaOfLaw),
                subtitle:
                    Text(userModel.advocateDetails?.areaOfLaw?.join(',') ?? ''),
                onTap: isLoggedInProfile(context)
                    ? () {
                        navigateToPage(
                          context,
                          SelectAreaOfExpertise(),
                        );
                      }
                    : null,
              ),
              ListTile(
                leading: Image.asset(CustomIcons.court),
                title: Text(Strings.visitingCourts),
                subtitle: Text(userModel.advocateDetails?.visitingCourt ?? ''),
                onTap: isLoggedInProfile(context)
                    ? () async {
                        var result = await openInputDialog(
                          context,
                          initialValue:
                              userModel.advocateDetails?.visitingCourt,
                          hintText: Strings.visitingCourtHint,
                        );
                        if (result != null) {
                          var details = userModel.advocateDetails
                              .copyWith(visitingCourt: result);
                          UserApi.updateAdvocateDetails(userModel.id, details);
                          Auth.updateUser(
                              userModel.copyWith(advocateDetails: details));
                        }
                      }
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }

  bool isLoggedInProfile(BuildContext context) {
    return AppConfig.userId == userModel.id;
  }

  Widget activityBuilder(
      {String title, String subtitle, bool showVerticalBorder = false}) {
    final borderSide = BorderSide(width: 2, color: color);
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border(
          top: borderSide,
          bottom: borderSide,
          right: showVerticalBorder ? borderSide : BorderSide.none,
          left: showVerticalBorder ? borderSide : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget headingText(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 18),
      ),
    );
  }

  Widget availabilityBuilder(List<Availability> availableOn) {
    Availability today = availabilityMapper[(DateFormat.EEEE().format(
      DateTime.now(),
    ))];

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Availability.values
                .map(
                  (e) => Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: today == e ? Border.all() : null,
                    ),
                    child: Text(e.toString().split('.')[1][0]),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 8),
          Divider(
            height: 0,
            thickness: 1,
            color: color,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.message),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.video_call),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.people),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
