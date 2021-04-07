import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/ui/profile/advocate_profile.dart';
import 'package:ylc/ui/profile/user_profile.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isAdvocate = Provider.of<UserModel>(
      context,
    ).isAdvocate;
    return isAdvocate ? AdvocateProfile() : UserProfile();
  }
}
