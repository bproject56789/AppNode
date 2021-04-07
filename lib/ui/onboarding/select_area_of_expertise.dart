import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/category_enum.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/utils/helpers.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/category_card.dart';
import 'package:ylc/widgets/custom_app_bar.dart';
import 'package:ylc/widgets/loading_view.dart';

class SelectAreaOfExpertise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectAreaOfExpertiseBuilder(
      model: Provider.of<UserModel>(context, listen: false),
    );
  }
}

class SelectAreaOfExpertiseBuilder extends StatefulWidget {
  final UserModel model;

  const SelectAreaOfExpertiseBuilder({Key key, this.model}) : super(key: key);
  @override
  _SelectAreaOfExpertiseBuilderState createState() =>
      _SelectAreaOfExpertiseBuilderState();
}

class _SelectAreaOfExpertiseBuilderState
    extends State<SelectAreaOfExpertiseBuilder> {
  List<String> selectedValues = [];
  bool isLoading = false;

  @override
  void initState() {
    if (widget.model?.advocateDetails?.areaOfLaw != null ||
        (widget.model?.advocateDetails?.areaOfLaw?.isNotEmpty ?? false)) {
      selectedValues = widget.model.advocateDetails.areaOfLaw;
    }
    super.initState();
  }

  void changeStatus(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingView(
      isLoading: isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Strings.expertise,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: CategoryType.values
                      .map(
                        (e) => CategoryCard(
                          model: e.data,
                          isSelected: selectedValues.contains(
                            e.data.title,
                          ),
                          onTap: () {
                            if (selectedValues.contains(
                              e.data.title,
                            )) {
                              selectedValues.remove(e.data.title);
                            } else {
                              selectedValues.add(e.data.title);
                            }
                            setState(() {});
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: YlcColors.categoryBackGround,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.white,
                child: Text(Strings.selectAreaOfExpertise),
                onPressed: selectedValues.length > 0
                    ? () async {
                        changeStatus(true);
                        var user =
                            Provider.of<UserModel>(context, listen: false);
                        var details = user.advocateDetails
                            .copyWith(areaOfLaw: selectedValues);
                        var result = await UserApi.updateAdvocateDetails(
                          user.id,
                          user.advocateDetails
                              .copyWith(areaOfLaw: selectedValues),
                        );
                        Auth.updateUser(
                          user.copyWith(advocateDetails: details),
                        );
                        showSnackBar(
                          context,
                          result: result,
                          message: Strings.updatedAreaOfExpertise,
                          onSuccess: () {
                            changeStatus(false);
                            if (Navigator.canPop(context))
                              Navigator.of(context).pop();
                          },
                          onError: () {
                            changeStatus(false);
                          },
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
