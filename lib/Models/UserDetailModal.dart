// To parse this JSON data, do
//
//     final userDetailModal = userDetailModalFromJson(jsonString);

import 'dart:convert';

UserDetailModal userDetailModalFromJson(String str) => UserDetailModal.fromJson(json.decode(str));

String userDetailModalToJson(UserDetailModal data) => json.encode(data.toJson());

class UserDetailModal {
    bool? status;
    Data? data;

    UserDetailModal({
        this.status,
        this.data,
    });

    factory UserDetailModal.fromJson(Map<String, dynamic> json) => UserDetailModal(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    User? user;
    int?isjournal;
    String? errors; // Add this field to capture errors

    Data({
        this.user,
        this.isjournal,
        this.errors,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : User.fromJson(json["user"]),

   isjournal:json["isJournal"]== null?0:json["isJournal"],

        errors: json["errors"], // Parse error messages
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "errors": errors,
        "isJournal":isjournal
    };
}


class User {
    int? id;
    String? name;
    String? email;
    dynamic phone;
    dynamic description;
    String? bucketId;
    dynamic age;
    dynamic profileImage;
    DateTime? emailVerifiedAt;
    int? isAdmin;
    int? userStatus;
    String? subscriptionStatus;
    dynamic subscriptionStartDate;
    dynamic subscriptionEndDate;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? stripeCustomerId;
    dynamic stripeSubscriptionId;
    dynamic tierId;
    String? freeTierUsed;
    dynamic zipBackupStatus;
    dynamic zipBackupExpiredAt;
    dynamic zipBackupUrl;
    int? totalBackupJournal;
    UserSubscription? userSubscription;

    User({
        this.id,
        this.name,
        this.email,
        this.phone,
        this.description,
        this.bucketId,
        this.age,
        this.profileImage,
        this.emailVerifiedAt,
        this.isAdmin,
        this.userStatus,
        this.subscriptionStatus,
        this.subscriptionStartDate,
        this.subscriptionEndDate,
        this.createdAt,
        this.updatedAt,
        this.stripeCustomerId,
        this.stripeSubscriptionId,
        this.tierId,
        this.freeTierUsed,
        this.zipBackupStatus,
        this.zipBackupExpiredAt,
        this.zipBackupUrl,
        this.totalBackupJournal,
        this.userSubscription,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        description: json["description"],
        bucketId: json["bucket_id"],
        age: json["age"],
        profileImage: json["profile_image_url"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        isAdmin: json["is_admin"],
        userStatus: json["user_status"],
        subscriptionStatus: json["Subscription_status"],
        subscriptionStartDate: json["subscription_start_date"],
        subscriptionEndDate: json["subscription_end_date"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        stripeCustomerId: json["stripe_customer_id"],
        stripeSubscriptionId: json["stripe_subscription_id"],
        tierId: json["tier_id"],
        freeTierUsed: json["free_tier_used"],
        zipBackupStatus: json["zip_backup_status"],
        zipBackupExpiredAt: json["zip_backup_expired_at"],
        zipBackupUrl: json["zip_backup_url"],
        totalBackupJournal: json["total_backup_journal"],
        userSubscription: json["user_subscription"] == null ? null : UserSubscription.fromJson(json["user_subscription"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "description": description,
        "bucket_id": bucketId,
        "age": age,
        "profile_image": profileImage,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "is_admin": isAdmin,
        "user_status": userStatus,
        "Subscription_status": subscriptionStatus,
        "subscription_start_date": subscriptionStartDate,
        "subscription_end_date": subscriptionEndDate,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "stripe_customer_id": stripeCustomerId,
        "stripe_subscription_id": stripeSubscriptionId,
        "tier_id": tierId,
        "free_tier_used": freeTierUsed,
        "zip_backup_status": zipBackupStatus,
        "zip_backup_expired_at": zipBackupExpiredAt,
        "zip_backup_url": zipBackupUrl,
        "total_backup_journal": totalBackupJournal,
        "user_subscription": userSubscription?.toJson(),
    };
}

class UserSubscription {
    int? id;
    int? userId;
    String? stripeSubscriptionId;
    int? productId;
    int? pauseProductId;
    int? tierTypeId;
    String? tierName;
    dynamic description;
    String? amount;
    String? tierStorage;
    String? pausePrice;
    String? retrievalPrice;
    DateTime? startDate;
    DateTime? endDate;
    String? status;
    String? type;
    DateTime? createdAt;
    DateTime? updatedAt;

    UserSubscription({
        this.id,
        this.userId,
        this.stripeSubscriptionId,
        this.productId,
        this.pauseProductId,
        this.tierTypeId,
        this.tierName,
        this.description,
        this.amount,
        this.tierStorage,
        this.pausePrice,
        this.retrievalPrice,
        this.startDate,
        this.endDate,
        this.status,
        this.type,
        this.createdAt,
        this.updatedAt,
    });

    factory UserSubscription.fromJson(Map<String, dynamic> json) => UserSubscription(
        id: json["id"],
        userId: json["user_id"],
        stripeSubscriptionId: json["stripe_subscription_id"],
        productId: json["product_id"],
        pauseProductId: json["pause_product_id"],
        tierTypeId: json["tier_type_id"],
        tierName: json["tier_name"],
        description: json["description"],
        amount: json["amount"],
        tierStorage: json["tier_storage"],
        pausePrice: json["pause_price"],
        retrievalPrice: json["retrieval_price"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        status: json["status"].toString(),
        type: json["type"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "stripe_subscription_id": stripeSubscriptionId,
        "product_id": productId,
        "pause_product_id": pauseProductId,
        "tier_type_id": tierTypeId,
        "tier_name": tierName,
        "description": description,
        "amount": amount,
        "tier_storage": tierStorage,
        "pause_price": pausePrice,
        "retrieval_price": retrievalPrice,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "status": status,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}



// // To parse this JSON data, do
// //
// //     final userDetailModal = userDetailModalFromJson(jsonString);

// import 'dart:convert';

// UserDetailModal userDetailModalFromJson(String str) =>
//     UserDetailModal.fromJson(json.decode(str));

// String userDetailModalToJson(UserDetailModal data) =>
//     json.encode(data.toJson());

// class UserDetailModal {
//   bool? status;
//   Data? data;

//   UserDetailModal({
//     this.status,
//     this.data,
//   });

//   factory UserDetailModal.fromJson(Map<String, dynamic> json) =>
//       UserDetailModal(
//         status: json["status"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data?.toJson(),
//       };
// }

// class Data {
//   User? user;

//   Data({
//     this.user,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "user": user?.toJson(),
//       };
// }

// class User {
//   int? id;
//   String? name;
//   String? email;
//   String? phone;
//   String? age;
//   String? profileImage; // Nullable profile image field
//   String? emailVerifiedAt;
//   int? isAdmin;
//   String? userStatus;
//   String? plan;
//   String? createdAt;
//   String? updatedAt;
//   String? subscription_status;
//   String? tier_id;
//   String? subscription_startdate;
//   String? subscription_enddate;
//   String? zip_backup_status;
//   String? zip_backup_expired;
//   String? zip_backup_url;

//   User(
//       {this.id,
//       this.name,
//       this.email,
//       this.phone,
//       this.age,
//       this.profileImage,
//       this.emailVerifiedAt,
//       this.isAdmin,
//       this.userStatus,
//       this.plan,
//       this.createdAt,
//       this.updatedAt,
//       this.subscription_status,
//       this.tier_id,
//       this.subscription_enddate,
//       this.subscription_startdate,
//       this.zip_backup_status,
//       this.zip_backup_expired,
//       this.zip_backup_url});

//   factory User.fromJson(Map<String, dynamic> json) => User(
//       id: json["id"],
//       name: json["name"],
//       email: json["email"],
//       phone: json["phone"] ?? "",
//       age: json["age"] ?? "",
//       profileImage: (json["profile_image"] is Map &&
//               (json["profile_image"] as Map).isEmpty)
//           ? ""
//           : json["profile_image"]?.toString(), // Handle empty object
//       emailVerifiedAt: json["email_verified_at"] ?? "",
//       isAdmin: json["is_admin"] != null
//           ? int.tryParse(json["is_admin"].toString())
//           : null,
//       userStatus: json["user_status"]?.toString() ?? "",
//       plan: json["plan"] ?? "",
//       createdAt: json["created_at"],
//       updatedAt: json["updated_at"],
//       subscription_status: json['Subscription_status'].toString(),
//       tier_id: json['tier_id'].toString(),
//       subscription_startdate: json['subscription_start_date'] == null
//           ? ""
//           : json['subscription_start_date'],
//       subscription_enddate: json['subscription_end_date'] == null
//           ? ""
//           : json['subscription_end_date'],
//       zip_backup_expired: json['zip_backup_expired_at'].toString(),
//       zip_backup_status: json['zip_backup_status'].toString(),
//       zip_backup_url: json['zip_backup_url']);

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "age": age,
//         "profile_image": profileImage,
//         "email_verified_at": emailVerifiedAt,
//         "is_admin": isAdmin,
//         "user_status": userStatus,
//         "plan": plan,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "Subscription_status": subscription_status,
//         "tier_id": tier_id,
//         "subscription_start_date": subscription_startdate,
//         "subscription_end_date": subscription_enddate,
//         "zip_backup_expired_at": zip_backup_expired,
//         "zip_backup_status": zip_backup_status,
//         "zip_backup_url": zip_backup_url
//       };
// }
