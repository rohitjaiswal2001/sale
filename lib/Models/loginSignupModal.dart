

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
