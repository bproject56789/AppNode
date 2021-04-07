import 'package:ylc/models/local/drawer_item_model.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';

enum DrawerItem {
  Profile,
  Advocates,
  GetVerified,
  Verified,
  Questions,
  MyQuestions,
  AskQuestion,
  Following,
  MyBookings,
  BookedByMe,
  Share,
  RateApp,
  Settings,
}

extension Data on DrawerItem {
  DrawerItemModel get data {
    DrawerItemModel _model;
    switch (this) {
      case DrawerItem.Profile:
        _model = DrawerItemModel(CustomIcons.userProfile, Strings.profile);
        break;
      case DrawerItem.Advocates:
        _model = DrawerItemModel(CustomIcons.manager, Strings.advocates);
        break;
      case DrawerItem.Questions:
        _model = DrawerItemModel(CustomIcons.qa, Strings.questions);
        break;
      case DrawerItem.MyQuestions:
        _model = DrawerItemModel(CustomIcons.questions, Strings.myQuestions);
        break;
      case DrawerItem.AskQuestion:
        _model = DrawerItemModel(CustomIcons.question, Strings.askQuestion);
        break;
      case DrawerItem.Following:
        _model = DrawerItemModel(CustomIcons.like, Strings.following);
        break;
      case DrawerItem.MyBookings:
        _model = DrawerItemModel(CustomIcons.consultation, Strings.myBookings);
        break;
      case DrawerItem.BookedByMe:
        _model = DrawerItemModel(CustomIcons.consultation, Strings.bookedByMe);
        break;
      case DrawerItem.Share:
        _model = DrawerItemModel(CustomIcons.share, Strings.share);
        break;
      case DrawerItem.RateApp:
        _model = DrawerItemModel(CustomIcons.rate, Strings.rateApp);
        break;
      case DrawerItem.Settings:
        _model = DrawerItemModel(CustomIcons.settings, Strings.settings);
        break;
      case DrawerItem.GetVerified:
        _model = DrawerItemModel(CustomIcons.verified, Strings.getVerified);
        break;
      case DrawerItem.Verified:
        _model = DrawerItemModel(CustomIcons.verified, Strings.verified);
        break;
    }
    return _model;
  }
}
