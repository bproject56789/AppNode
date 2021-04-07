import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ylc/keys/keys.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/ui/advocates/custom_consultation.dart';
import 'package:ylc/utils/api_result.dart';

class UserApi {
  static const _endPoint = BaseUrl + "users/";

  static Future<UserModel> createUser({
    String name,
    String email,
    String phone,
    String photo,
    String password,
    bool isAdvocate,
  }) async {
    print("hitting $_endPoint");
    try {
      var result = await http.post(_endPoint,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "name": name,
            "email": email,
            "phone": phone,
            "photo": photo,
            "password": password,
            "isAdvocate": isAdvocate
          }));

      if (result.statusCode == 201) {
        return UserModel.fromMap(json.decode(result.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<UserModel> loginUser({
    String email,
    String password,
  }) async {
    var result = await http.post(_endPoint + 'login',
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode({
          "email": email,
          "password": password,
        }));

    if (result.statusCode == 200) {
      return UserModel.fromMap(json.decode(result.body));
    } else {
      return null;
    }
  }

  static Future<UserModel> getUser({
    String uid,
  }) async {
    var result = await http.get(_endPoint + uid);
    if (result.statusCode == 200) {
      return UserModel.fromMap(json.decode(result.body));
    } else {
      return null;
    }
  }

  // static Future<UserModel> getUserFuture(String id) async {
  //   var document = await YlcCollectionRef.usersCollection.doc(id).get();
  //   if (document != null) {
  //     return UserModel.fromMap(document.data());
  //   } else {
  //     throw Exception("user not found");
  //   }
  // }

  // static Stream<UserModel> getUserStream(String id) async* {
  //   print(id);
  //   var data = YlcCollectionRef.usersCollection.doc(id).snapshots();

  //   yield* data.transform(
  //     StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
  //       handleData: (document, sink) {
  //         try {
  //           var user = UserModel.fromMap(document.data());
  //           log(json.encode(user.toMap()));
  //           sink.add(user);
  //         } catch (e) {
  //           sink.addError(e);
  //         }
  //       },
  //     ),
  //   );
  // }

  static Future<List<UserModel>> getAllAdvocates(String id) async {
    var result = await http.get(_endPoint + 'allAdvocates');
    if (result.statusCode == 200) {
      List<dynamic> data = json.decode(result.body);
      List<UserModel> advocates = [];
      data.forEach((element) {
        if (element['_id'] != id) advocates.add(UserModel.fromMap(element));
      });
      return advocates;
    } else {
      return null;
    }
  }

  static Future<List<UserModel>> getAllAdvocatesWithFilter(
    String id,
    ExperienceData data,
    String type,
    bool isVerified,
  ) async {
    Map<String, dynamic> queryParameters = {};

    if (isVerified != null) {
      queryParameters['isVerified'] = isVerified.toString();
    }
    if (type != null) {
      queryParameters['type'] = type;
    }
    if (data?.separator != null) {
      queryParameters['separator'] = data.separator;
      queryParameters['upperLimit'] = data.upperLimit.toString();
      queryParameters['lowerLimit'] = data.lowerLimit.toString();
    }

    String query = Uri(queryParameters: queryParameters).query;

    var result = await http.get(_endPoint + 'allAdvocates?$query');
    if (result.statusCode == 200) {
      List<dynamic> data = json.decode(result.body);
      List<UserModel> advocates = [];
      data.forEach((element) {
        if (element['_id'] != id) advocates.add(UserModel.fromMap(element));
      });
      return advocates;
    } else {
      return null;
    }
  }

  // static Stream<List<UserModel>> getAllAdvocatesWihoutCurrentUserOfType(
  //   String id,
  //   String type,
  // ) async* {
  //   var data = YlcCollectionRef.usersCollection
  //       .where("isAdvocate", isEqualTo: true)
  //       .where('advocateDetails.areaOfLaw', arrayContains: type)
  //       .where("id", isNotEqualTo: id)
  //       .snapshots();

  //   yield* data.transform(
  //     StreamTransformer<QuerySnapshot, List<UserModel>>.fromHandlers(
  //       handleData: (documents, sink) {
  //         print(documents.metadata.isFromCache);
  //         print(documents.docs.length);
  //         try {
  //           List<UserModel> models = [];
  //           documents.docs.forEach((document) {
  //             models.add(UserModel.fromMap(document.data()));
  //           });
  //           sink.add(models);
  //         } on Exception catch (e) {
  //           sink.addError(e);
  //         }
  //       },
  //     ),
  //   );
  // }

  static Future<ApiResult> updateAdvocateDetails(
    String userId,
    AdvocateDetails details,
  ) async {
    try {
      var result = await http.patch(_endPoint + userId,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "advocateDetails": details.toMap(),
          }));

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('something went wrong ${result.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> updateAdvocateDocuments(
    String userId,
    Documents doc,
  ) async {
    try {
      var result = await http.patch(_endPoint + userId,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "documents": doc.toMap(),
          }));

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('something went wrong ${result.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> updateSeenIntro(String userId) async {
    try {
      var result = await http.patch(_endPoint + userId,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "seenIntro": true,
          }));

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('something went wrong ${result.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  // static Future<void> updateAdvocateDetails(
  //   String userId,
  //   AdvocateDetails details,
  // ) async {
  //   YlcCollectionRef.usersCollection.doc(userId).update(
  //     {
  //       "advocateDetails": details.toMap(),
  //     },
  //   );
  // }

  static Future<ApiResult> updateAdditionalDetails(
    String userId,
    AdditionalDetails details,
  ) async {
    try {
      var result = await http.patch(
        _endPoint + userId,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode(
          {
            "additionalDetails": details.toMap(),
          },
        ),
      );

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('something went wrong ${result.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> changeProfilePhoto(
    String userId,
    String photoUrl,
  ) async {
    try {
      var result = await http.patch(_endPoint + userId,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "photo": photoUrl,
          }));

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('something went wrong ${result.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> verifyPhone(String userId) async {
    try {
      var result = await http.patch(_endPoint + userId,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "phoneVerified": true,
          }));

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('something went wrong ${result.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  static Future<ApiResult> changePhoneNumber(
      String userId, String number) async {
    try {
      var result = await http.patch(_endPoint + userId,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: json.encode({
            "phone": number,
          }));

      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('something went wrong ${result.statusCode}');
      }
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  // static Future<void> setFCMToken(String userId, String token) async {
  //   return await YlcCollectionRef.usersCollection
  //       .doc(userId)
  //       .update({'token': token});
  // }
}
