// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  bool? status;
  String? message;
  Data? data;

  ProfileModel({this.status, this.message, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? role;
  String? userName;
  String? bio;
  dynamic profilePic;
  String? email;
  String? password;
  String? passwordSalt;
  dynamic otp;
  dynamic otpExpiration;
  dynamic googleId;
  dynamic customerId;
  dynamic resetToken;
  dynamic resetTokenExpiration;
  bool? isDeactive;
  bool? emailVerify;
  String? storeName;
  String? phoneNo;
  String? location;
  String? kycNo;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic countryCode;
  dynamic countryCodeName;

  Data({
    this.id,
    this.role,
    this.userName,
    this.bio,
    this.profilePic,
    this.email,
    this.password,
    this.passwordSalt,
    this.otp,
    this.otpExpiration,
    this.googleId,
    this.customerId,
    this.resetToken,
    this.resetTokenExpiration,
    this.isDeactive,
    this.emailVerify,
    this.storeName,
    this.phoneNo,
    this.location,
    this.kycNo,
    this.createdAt,
    this.updatedAt,
    this.countryCode,
    this.countryCodeName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    role: json["role"],
    userName: json["user_name"],
    bio: json["bio"],
    profilePic: json["profile_pic"],
    email: json["email"],
    password: json["password"],
    passwordSalt: json["password_salt"],
    otp: json["otp"],
    otpExpiration: json["otp_expiration"],
    googleId: json["google_id"],
    customerId: json["customer_id"],
    resetToken: json["reset_token"],
    resetTokenExpiration: json["reset_token_expiration"],
    isDeactive: json["is_deactive"],
    emailVerify: json["email_verify"],
    storeName: json["store_name"],
    phoneNo: json["phone_no"],
    location: json["location"],
    kycNo: json["kyc_no"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    countryCode: json["country_code"],
    countryCodeName: json["country_code_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "user_name": userName,
    "profile_pic": profilePic,
    "email": email,
    "password": password,
    "password_salt": passwordSalt,
    "otp": otp,
    "otp_expiration": otpExpiration,
    "google_id": googleId,
    "customer_id": customerId,
    "reset_token": resetToken,
    "reset_token_expiration": resetTokenExpiration,
    "is_deactive": isDeactive,
    "email_verify": emailVerify,
    "store_name": storeName,
    "phone_no": phoneNo,
    "location": location,
    "kyc_no": kycNo,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "country_code": countryCode,
    "country_code_name": countryCodeName,
  };
}
