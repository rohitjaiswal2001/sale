// To parse this JSON data, do
//
//     final choosePlanModal = choosePlanModalFromJson(jsonString);

import 'dart:convert';

ChoosePlanModal choosePlanModalFromJson(String str) =>
    ChoosePlanModal.fromJson(json.decode(str));

String choosePlanModalToJson(ChoosePlanModal data) =>
    json.encode(data.toJson());

class ChoosePlanModal {
  bool? success;
  List<Datum>? data;
  int? currentPlanId;

  ChoosePlanModal({
    this.success,
    this.data,
    this.currentPlanId,
  });

  factory ChoosePlanModal.fromJson(Map<String, dynamic> json) =>
      ChoosePlanModal(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        currentPlanId: json["active_tier_id"] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "active_tier_id": currentPlanId,
      };
}

class Datum {
  int? id;

  int? isFree;
  int? isFreeDays;
  dynamic parentId;
  String? tierName;
  String? tierLogo;
  String? tierPricing;
  String? tierStorage;
  dynamic duration;
  String? tierFeatures;
  TierType? tierType;
  dynamic userIds;
  int? isCustom;
  int? status;
  dynamic priceId;
  dynamic productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? tierText;
  dynamic pausedText;
  String? type;
  int? tierTypeId;
  String? tierLogoUrl;
  dynamic tierFeaturesTags;
  PauseTier? pauseTier;
  String? thanksmessage;

  Datum(
      {this.id,
      this.isFree,
      this.isFreeDays,
      this.parentId,
      this.tierName,
      this.tierLogo,
      this.tierPricing,
      this.tierStorage,
      this.duration,
      this.tierFeatures,
      this.tierType,
      this.userIds,
      this.isCustom,
      this.status,
      this.priceId,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.tierText,
      this.pausedText,
      this.type,
      this.tierTypeId,
      this.tierLogoUrl,
      this.tierFeaturesTags,
      this.pauseTier,
      this.thanksmessage});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        parentId: json["parent_id"],
        tierName: json["tier_name"],
        tierLogo: json["tier_logo"],
        tierPricing: json["tier_pricing"],
        tierStorage: json["tier_storage"],
        duration: json["duration"],
        isFree: json["is_free"] ?? 0,
        isFreeDays: json['free_days'] ?? 0,
        tierFeatures: json["tier_features"],
        tierType: json["tier_type"] == null
            ? null
            : TierType.fromJson(json["tier_type"]),
        userIds: json["user_ids"],
        isCustom: json["is_custom"],
        status: json["status"],
        priceId: json["price_id"],
        productId: json["product_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        tierText: json["tier_text"],
        pausedText: json["paused_text"],
        type: json["type"],
        tierTypeId: json["tier_type_id"],
        tierLogoUrl: json["tier_logo_url"],
        tierFeaturesTags: json["tier_features_tags"],
        pauseTier: json["pause_tier"] == null
            ? null
            : PauseTier.fromJson(json["pause_tier"]),
        thanksmessage: json["thankyou_text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "tier_name": tierName,
        "tier_logo": tierLogo,
        "tier_pricing": tierPricing,
        "tier_storage": tierStorage,
        "duration": duration,
        "tier_features": tierFeatures,
        "tier_type": tierType?.toJson(),
        "user_ids": userIds,
        "is_custom": isCustom,
        "status": status,
        "price_id": priceId,
        "product_id": productId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "tier_text": tierText,
        "paused_text": pausedText,
        "type": type,
        "tier_type_id": tierTypeId,
        "tier_logo_url": tierLogoUrl,
        "tier_features_tags": tierFeaturesTags,
        "pause_tier": pauseTier?.toJson(),
        "thankyou_text": thanksmessage,
      };
}

class PauseTier {
  int? id;
  int? parentId;
  String? tierPricing;
  dynamic tierLogoUrl;
  dynamic tierFeaturesTags;
  dynamic tierType;

  PauseTier({
    this.id,
    this.parentId,
    this.tierPricing,
    this.tierLogoUrl,
    this.tierFeaturesTags,
    this.tierType,
  });

  factory PauseTier.fromJson(Map<String, dynamic> json) => PauseTier(
        id: json["id"],
        parentId: json["parent_id"],
        tierPricing: json["tier_pricing"],
        tierLogoUrl: json["tier_logo_url"],
        tierFeaturesTags: json["tier_features_tags"],
        tierType: json["tier_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "tier_pricing": tierPricing,
        "tier_logo_url": tierLogoUrl,
        "tier_features_tags": tierFeaturesTags,
        "tier_type": tierType,
      };
}

class TierType {
  int? id;
  String? name;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  TierType({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory TierType.fromJson(Map<String, dynamic> json) => TierType(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
