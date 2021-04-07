import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/local/category_model.dart';
import 'package:ylc/ui/advocates/bloc/advocates_bloc.dart';
import 'package:ylc/ui/advocates/custom_consultation.dart';
import 'package:ylc/ui/profile/advocate_profile.dart';
import 'package:ylc/user_config.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/loading_view.dart';
import 'package:ylc/widgets/navigaton_helper.dart';
import 'package:ylc/widgets/profile_image.dart';

class AdvocatePageData {
  final String type;
  final bool isVerified;
  final ExperienceData data;

  AdvocatePageData(this.type, this.isVerified, this.data);
}

class AdvocatesPage extends StatefulWidget {
  final CategoryModel model;
  final AdvocatePageData advocatePageData;

  const AdvocatesPage({
    Key key,
    this.model,
    this.advocatePageData,
  }) : super(key: key);
  @override
  _AdvocatesPageState createState() => _AdvocatesPageState();
}

class _AdvocatesPageState extends State<AdvocatesPage> {
  final AdvocatesBloc bloc = AdvocatesBloc();
  List<UserModel> advocates = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (widget.advocatePageData != null) {
          var temp = widget.advocatePageData;
          bloc.initWithData(
            AppConfig.userId,
            temp.data,
            temp.type,
            temp.isVerified,
          );
        } else {
          bloc.init(
            AppConfig.userId,
            widget.model?.title ?? null,
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.model?.title ?? Strings.advocates,
        ),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: bloc.advocates,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(Strings.generalError),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingIndicator();
          }
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(
              child: Text(Strings.noAdvocates),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              var user = snapshot.data[index];
              return Card(
                child: ListTile(
                  leading: ProfileImage.lightColor(
                    photo: user.photo,
                    radius: 22,
                  ),
                  title: Text(
                    user.name,
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    navigateToPage(
                      context,
                      Provider<UserModel>.value(
                        value: user,
                        child: AdvocateProfile(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
