// import 'dart:convert';

// UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

// String userModelToJson(UserModel data) => json.encode(data.toJson());

// class UserModel {
//   bool? status;
//   Data? data;

//   UserModel({
//     this.status,
//     this.data,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//         status: json["status"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data?.toJson(),
//       };
// }

// class Data {
//   String? message;
//   String? accessToken;
//   String? tokenType;
//   User? user;
//   bool? otp;
//   Map<String, List<String>>? errors;
//   String? error;
//   String? email;

//   Data({
//     this.message,
//     this.accessToken,
//     this.tokenType,
//     this.user,
//     this.otp,
//     this.errors,
//     this.error,
//     this.email,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         message: json["message"],
//         accessToken: json["access_token"],
//         tokenType: json["token_type"],
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//         otp: json["otp"],
//         errors: json["errors"] == null
//             ? null
//             : Map.from(json["errors"]).map((k, v) =>
//                 MapEntry<String, List<String>>(k, List<String>.from(v))),
//         error: json["error"],
//         email: json["email"],
//       );

//   Map<String, dynamic> toJson() => {
//         "message": message,
//         "access_token": accessToken,
//         "token_type": tokenType,
//         "user": user?.toJson(),
//         "otp": otp,
//         "errors": errors == null
//             ? null
//             : Map.from(errors!).map(
//                 (k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v))),
//         "error": error,
//         "email": email,
//       };
// }

// class User {
//   int? id;
//   String? name;
//   String? email;
//   dynamic phone;
//   dynamic description;
//   dynamic age;
//   dynamic profileImage;
//   DateTime? emailVerifiedAt;

//   int? is_onboaring;
//   int? isAdmin;
//   int? userStatus;
//   DateTime? createdAt;
//   DateTime? updatedAt;


//   User({
//     this.id,
//     this.name,
//     this.email,
//     this.phone,
//     this.description,
//     this.age,
//     this.profileImage,
//     this.emailVerifiedAt,
//     this.isAdmin,
//     this.is_onboaring,
//     this.userStatus,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         phone: json["phone"],
//         description: json["description"],
//         age: json["age"],
//         profileImage: json["profile_image"],
//         emailVerifiedAt: json["email_verified_at"] == null
//             ? null
//             : DateTime.parse(json["email_verified_at"]),
//         isAdmin: json["is_admin"],
//         is_onboaring: json['is_open_onboarding'],
//         userStatus: json["user_status"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "description": description,
//         "age": age,
//         "profile_image": profileImage,
//         "email_verified_at": emailVerifiedAt?.toIso8601String(),
//         "is_admin": isAdmin,
//         "is_open_onboarding":is_onboaring,
//         "user_status": userStatus,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//       };
// }





// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    bool? status;
    String? message;
    Data? data;
    String ? error;

    UserModel({
        this.status,
        this.message,
        this.data,
        this.error,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        message: json["message"],
        error: json["error"],
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
    String? profilePic;
    String? email;
    dynamic googleId;
    dynamic customerId;
    String? bio;
    bool? isDeactive;
    bool? emailVerify;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? token;

    Data({
        this.id,
        this.role,
        this.userName,
        this.profilePic,
        this.email,
        this.googleId,
        this.customerId,
        this.bio,
        this.isDeactive,
        this.emailVerify,
        this.createdAt,
        this.updatedAt,
        this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        role: json["role"],
        userName: json["user_name"],
        profilePic: json["profile_pic"],
        email: json["email"],
        googleId: json["google_id"],
        customerId: json["customer_id"],
        bio: json["bio"],
        isDeactive: json["is_deactive"],
        emailVerify: json["email_verify"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "user_name": userName,
        "profile_pic": profilePic,
        "email": email,
        "google_id": googleId,
        "customer_id": customerId,
        "bio": bio,
        "is_deactive": isDeactive,
        "email_verify": emailVerify,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "token": token,
    };
}
