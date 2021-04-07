import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/api/user_api.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/services/auth_service.dart';
import 'package:ylc/services/upload_service.dart';
import 'package:ylc/utils/api_result.dart';
import 'package:ylc/utils/helpers.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/image_upload_widget.dart';
import 'package:ylc/widgets/loading_view.dart';

class UploadDocuments extends StatefulWidget {
  final bool shouldPopOnUpload;
  const UploadDocuments({
    Key key,
    this.shouldPopOnUpload = false,
  }) : super(key: key);

  @override
  _UploadDocumentsState createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  bool isLoading = false;
  File aadhar, registration;

  void changeStatus(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.uploadDocuments),
      ),
      body: LoadingView(
        isLoading: isLoading,
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Upload aadhar card photo"),
                ImageUpload(
                  size: Size(
                    MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.width * 0.7,
                  ),
                  onChanged: (file) {
                    setState(() {
                      aadhar = file;
                    });
                  },
                ),
                Text("Upload license"),
                ImageUpload(
                  size: Size(
                    MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.width * 0.7,
                  ),
                  onChanged: (file) {
                    setState(() {
                      registration = file;
                    });
                  },
                ),
                RaisedButton(
                  onPressed: (aadhar == null || registration == null)
                      ? null
                      : () async {
                          changeStatus(true);
                          Future.wait<String>([
                            UploadService.uploadImageToFirebase(aadhar),
                            UploadService.uploadImageToFirebase(registration),
                          ]).then((urls) async {
                            var user =
                                Provider.of<UserModel>(context, listen: false);
                            var documents = Documents(
                              aadharCard: urls[0],
                              enrollmentNumber: urls[1],
                            );
                            var result = await UserApi.updateAdvocateDocuments(
                              user.id,
                              documents,
                            );
                            Auth.updateUser(
                                user.copyWith(documents: documents));
                            showSnackBar(
                              context,
                              result: result,
                              message: Strings.documentsUploadedSuccessfully,
                            );
                            changeStatus(false);
                            if (widget.shouldPopOnUpload) {
                              Navigator.of(context).pop();
                            }
                          }).catchError((e) {
                            print(e);
                            showSnackBar(
                              context,
                              result: ApiResult.failure(e),
                              message: '',
                            );
                            changeStatus(false);
                          });
                        },
                  child: Text(Strings.upload),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
