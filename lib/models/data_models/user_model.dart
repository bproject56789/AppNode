import 'package:ylc/models/data_models/consultation_model.dart';
import 'package:ylc/models/enums/availability_enum.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/utils/extensions.dart';

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.following,
    this.followedBy,
    this.phoneVerified,
    this.isVerified,
    this.isSuspended,
    this.isAdvocate,
    this.advocateDetails,
    this.additionalDetails,
    this.seenIntro,
    this.documents,
    this.timestamp,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final bool seenIntro;
  final bool isSuspended;
  final List<String> following;
  final List<String> followedBy;
  final bool phoneVerified;
  final bool isVerified;
  final bool isAdvocate;
  final AdvocateDetails advocateDetails;
  final AdditionalDetails additionalDetails;
  final Documents documents;

  final int timestamp;

  UserModel copyWith({
    String id,
    String name,
    String email,
    String phone,
    String photo,
    List<String> following,
    List<String> followedBy,
    bool phoneVerified,
    bool isVerified,
    bool isAdvocate,
    bool isSuspended,
    AdvocateDetails advocateDetails,
    AdditionalDetails additionalDetails,
    Documents documents,
    int timestamp,
    bool seenIntro,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        phone: phone ?? this.phone,
        following: following ?? this.following,
        followedBy: followedBy ?? this.followedBy,
        phoneVerified: phoneVerified ?? this.phoneVerified,
        isVerified: isVerified ?? this.isVerified,
        isAdvocate: isAdvocate ?? this.isAdvocate,
        isSuspended: isSuspended ?? this.isSuspended,
        advocateDetails: advocateDetails ?? this.advocateDetails,
        additionalDetails: additionalDetails ?? this.additionalDetails,
        documents: documents ?? this.documents,
        timestamp: timestamp ?? this.timestamp,
        seenIntro: seenIntro ?? this.seenIntro,
      );

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        photo: json["photo"],
        following: json.modelCheck("following")
            ? List<String>.from(json["following"].map((x) => x))
            : [],
        followedBy: json.modelCheck("followedBy")
            ? List<String>.from(json["followedBy"].map((x) => x))
            : [],
        phoneVerified: json.containsKey('phoneVerified')
            ? (json["phoneVerified"] ?? false)
            : false,
        isVerified: json.modelCheck("isVerified")
            ? (json["isVerified"] ?? false)
            : false,
        isAdvocate: json["isAdvocate"],
        advocateDetails: json.modelCheck("advocateDetails")
            ? AdvocateDetails.fromMap(json["advocateDetails"])
            : null,
        additionalDetails: json.modelCheck("additionalDetails")
            ? AdditionalDetails.fromMap(json["additionalDetails"])
            : AdditionalDetails(),
        documents: json.modelCheck("documents")
            ? Documents.fromMap(json["documents"])
            : null,
        timestamp: json["timestamp"],
        seenIntro:
            json.containsKey("seenIntro") ? (json["seenIntro"] ?? false) : null,
        isSuspended: json.modelCheck("isSuspended")
            ? (json["isSuspended"] ?? false)
            : false,
      );

  Details get details => Details(
        id: id,
        name: name,
        photo: photo,
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "phone": phone,
        "photo": photo,
        "following": following != null
            ? List<dynamic>.from(following.map((x) => x))
            : null,
        "followedBy": followedBy != null
            ? List<dynamic>.from(followedBy.map((x) => x))
            : null,
        "phoneVerified": phoneVerified,
        "isVerified": isVerified ?? false,
        "isAdvocate": isAdvocate,
        "advocateDetails": advocateDetails?.toMap(),
        "additionalDetails": additionalDetails?.toMap(),
        "documents": documents?.toMap(),
        "seenIntro": seenIntro,
        "timestamp": timestamp,
      };
}

class AdvocateDetails {
  AdvocateDetails({
    this.experience,
    this.about,
    this.educationQualifications,
    this.visitingCourt,
    this.serviceCities,
    this.areaOfLaw,
    this.availability,
    this.consultationCharges,
  });

  final int experience;
  final String about;
  final List<EducationQualification> educationQualifications;
  final String visitingCourt;
  final String serviceCities;
  final List<String> areaOfLaw;
  final List<Availability> availability;
  final ConsultationCharges consultationCharges;

  AdvocateDetails copyWith({
    int experience,
    String about,
    List<EducationQualification> educationQualifications,
    String visitingCourt,
    String serviceCities,
    List<String> areaOfLaw,
    List<String> availability,
    ConsultationCharges consultationCharges,
  }) =>
      AdvocateDetails(
        experience: experience ?? this.experience,
        about: about ?? this.about,
        educationQualifications:
            educationQualifications ?? this.educationQualifications,
        visitingCourt: visitingCourt ?? this.visitingCourt,
        serviceCities: serviceCities ?? this.serviceCities,
        areaOfLaw: areaOfLaw ?? this.areaOfLaw,
        availability: availability ?? this.availability,
        consultationCharges: consultationCharges ?? this.consultationCharges,
      );

  factory AdvocateDetails.fromMap(Map<String, dynamic> json) => AdvocateDetails(
        experience: json.modelCheck('experience') ? json["experience"] : null,
        about: json.modelCheck('about') ? json["about"] : null,
        educationQualifications: json.modelCheck('educationQualifications')
            ? List<EducationQualification>.from(json["educationQualifications"]
                .map((x) => EducationQualification.fromMap(x)))
            : null,
        visitingCourt:
            json.modelCheck('visitingCourt') ? json["visitingCourt"] : null,
        serviceCities:
            json.modelCheck("serviceCities") ? json["serviceCities"] : null,
        areaOfLaw: json.modelCheck('areaOfLaw')
            ? List<String>.from(json["areaOfLaw"])
            : null,
        availability: json.modelCheck("availability")
            ? List<Availability>.from(
                json["availability"].map(
                  (x) => availabilityMapper[x],
                ),
              )
            : Availability.values,
        consultationCharges: json.modelCheck("consultationCharges")
            ? ConsultationCharges.fromMap(json["consultationCharges"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "experience": experience,
        "about": about,
        "educationQualifications": educationQualifications != null
            ? List<dynamic>.from(educationQualifications.map((x) => x.toMap()))
            : null,
        "visitingCourt": visitingCourt,
        "serviceCities": serviceCities,
        "areaOfLaw": areaOfLaw != null
            ? List<dynamic>.from(areaOfLaw.map((x) => x))
            : [],
        "availability": availability != null
            ? List<dynamic>.from(
                availability.map(
                  (x) => x.toString().split('.')[1],
                ),
              )
            : null,
        "consultationCharges": consultationCharges?.toMap(),
      };
}

class EducationQualification {
  EducationQualification({
    this.passingYear,
    this.qualifications,
  });

  final String passingYear;
  final String qualifications;

  EducationQualification copyWith({
    String passingYear,
    String qualifications,
  }) =>
      EducationQualification(
        passingYear: passingYear ?? this.passingYear,
        qualifications: qualifications ?? this.qualifications,
      );

  factory EducationQualification.fromMap(Map<String, dynamic> json) =>
      EducationQualification(
        passingYear: json["passingYear"],
        qualifications: json["qualifications"],
      );

  Map<String, dynamic> toMap() => {
        "passingYear": passingYear,
        "qualifications": qualifications,
      };
}

class Documents {
  Documents({
    this.aadharCard,
    this.enrollmentNumber,
  });

  final String aadharCard;
  final String enrollmentNumber;

  Documents copyWith({
    String aadharCard,
    String enrollmentNumber,
  }) =>
      Documents(
        aadharCard: aadharCard ?? this.aadharCard,
        enrollmentNumber: enrollmentNumber ?? this.enrollmentNumber,
      );

  factory Documents.fromMap(Map<String, dynamic> json) => Documents(
        aadharCard: json["aadharCard"],
        enrollmentNumber: json["enrollmentNumber"],
      );

  Map<String, dynamic> toMap() => {
        "aadharCard": aadharCard,
        "enrollmentNumber": enrollmentNumber,
      };
}

class AdditionalDetails {
  AdditionalDetails({
    this.dateOfBirth,
    this.gender,
    this.state,
    this.city,
    this.address,
  });

  final int dateOfBirth;
  final Gender gender;
  final String state;
  final String city;
  final String address;

  AdditionalDetails copyWith({
    int dateOfBirth,
    Gender gender,
    String state,
    String city,
    String address,
  }) =>
      AdditionalDetails(
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        state: state ?? this.state,
        city: city ?? this.city,
        address: address ?? this.address,
      );

  factory AdditionalDetails.fromMap(Map<String, dynamic> json) =>
      AdditionalDetails(
        dateOfBirth: json["dateOfBirth"],
        gender: json["gender"] != null ? _genderMapper[json["gender"]] : null,
        state: json["state"],
        city: json["city"],
        address: json["address"],
      );

  Map<String, dynamic> toMap() => {
        "dateOfBirth": dateOfBirth,
        "gender": gender?.label,
        "state": state,
        "city": city,
        "address": address,
      };
}

Map<String, Gender> _genderMapper = {
  Gender.Male.label: Gender.Male,
  Gender.Female.label: Gender.Female,
  Gender.Other.label: Gender.Other,
};

class ConsultationCharges {
  ConsultationCharges({
    this.video,
    this.voice,
    this.chat,
  });

  final Charges video;
  final Charges voice;
  final Charges chat;

  ConsultationCharges copyWith({
    Charges video,
    Charges voice,
    Charges chat,
    Charges charges,
  }) =>
      ConsultationCharges(
        video: video ?? this.video,
        voice: voice ?? this.voice,
        chat: chat ?? this.chat,
      );

  factory ConsultationCharges.fromMap(Map<String, dynamic> json) =>
      ConsultationCharges(
        video: Charges.fromMap(json["video"]),
        voice: Charges.fromMap(json["voice"]),
        chat: Charges.fromMap(json["chat"]),
      );

  Map<String, dynamic> toMap() => {
        "video": video.toMap(),
        "voice": voice.toMap(),
        "chat": chat.toMap(),
      };
}

class Charges {
  Charges({
    this.price,
    this.time,
  });

  final int price;
  final int time;

  Charges copyWith({
    int price,
    int time,
  }) =>
      Charges(
        price: price ?? this.price,
        time: time ?? this.time,
      );

  factory Charges.fromMap(Map<String, dynamic> json) => Charges(
        price: json["price"],
        time: json["time"],
      );

  Map<String, dynamic> toMap() => {
        "price": price,
        "time": time,
      };
}
