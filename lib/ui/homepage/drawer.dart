import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/drawer_item_enum.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/models/local/drawer_item_model.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/ui/advocates/advocates_page.dart';
import 'package:ylc/ui/consultation/my_consultations.dart';
import 'package:ylc/ui/onboarding/upload_documents.dart';
import 'package:ylc/ui/profile/profile.dart';
import 'package:ylc/ui/questions_module/screens/ask_question_page.dart';
import 'package:ylc/ui/questions_module/screens/questions_page.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/custom_back_button.dart';
import 'package:ylc/widgets/drawer_item_card.dart';
import 'package:ylc/widgets/hide_widget.dart';
import 'package:ylc/widgets/navigaton_helper.dart';
import 'package:ylc/widgets/profile_image.dart';

class CustomDrawer extends StatelessWidget {
  final UserMode userMode;

  const CustomDrawer({Key key, this.userMode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      GeneralImages.profileBg,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackButton(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => navigateToProfile(context),
                            child: ProfileImage(
                              photo: userModel.photo,
                              radius: 35,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            userModel.name,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(Strings.general),
                  DrawerItemCard(
                    model: DrawerItem.Profile.data,
                    onTap: () => navigateToProfile(context),
                  ),
                  HideWidget(
                    hide: userMode == UserMode.User,
                    child: userModel.isVerified
                        ? DrawerItemCard(
                            model: DrawerItem.Verified.data,
                            color: Colors.green,
                          )
                        : DrawerItemCard(
                            model: DrawerItem.GetVerified.data,
                            onTap:
                                Provider.of<UserModel>(context, listen: false)
                                        .isVerified
                                    ? null
                                    : () => navigateToVerifyDocuments(context),
                          ),
                  ),
                  DrawerItemCard(
                    model: DrawerItem.Advocates.data,
                    onTap: () => navigateToAdvocatesPage(context),
                  ),
                  DrawerItemCard(
                    model: DrawerItem.Questions.data,
                    onTap: () => navigateToAllQuestions(context),
                  ),
                  DrawerItemCard(
                    model: DrawerItem.MyQuestions.data,
                    onTap: () => navigateToUsersQuestions(context),
                  ),
                  DrawerItemCard(
                    model: DrawerItem.AskQuestion.data,
                    onTap: () => navigateToAskQuestions(context),
                  ),
                  // DrawerItemCard(model: DrawerItem.Following.data),
                  titleText(Strings.myConsultation),
                  DrawerItemCard(
                    model: userMode == UserMode.User
                        ? DrawerItem.MyBookings.data
                        : DrawerItem.BookedByMe.data,
                    onTap: () => navigateToConsultations(context),
                  ),
                  titleText(Strings.others),
                  DrawerItemCard(model: DrawerItem.Share.data),
                  DrawerItemCard(model: DrawerItem.RateApp.data),
                  DrawerItemCard(model: DrawerItem.Settings.data),
                  DrawerItemCard(
                    model: DrawerItemModel(null, 'Logout'),
                    onTap: () {
                      _signOut(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToAskQuestions(context) {
    navigateToPage(context, AskQuestionsPage());
  }

  void navigateToAllQuestions(context) {
    navigateToPage(context, QuestionsPage());
  }

  void navigateToUsersQuestions(context) {
    navigateToPage(
      context,
      QuestionsPage(userId: AppConfig.userId),
    );
  }

  void navigateToProfile(context) {
    navigateToPage(context, Profile());
  }

  void navigateToAdvocatesPage(context) {
    navigateToPage(context, AdvocatesPage());
  }

  void navigateToConsultations(context) {
    navigateToPage(context, MyConsultations());
  }

  void navigateToVerifyDocuments(context) {
    navigateToPage(
      context,
      UploadDocuments(
        shouldPopOnUpload: true,
      ),
    );
  }

  Widget titleText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    var result = await Auth.signOut();
    if (result.isSuccess) {
      Phoenix.rebirth(context);
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => RootWidget(),
      //   ),
      //   (route) => false,
      // );
    }
  }
}
