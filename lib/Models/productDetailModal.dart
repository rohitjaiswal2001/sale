// lib/models/product_detail_model.dart
import 'dart:convert';

ProductDetailModel productDetailModelFromJson(String str) => ProductDetailModel.fromJson(json.decode(str));

class ProductDetailModel {
  bool status;
  String message;
  Data data;

  ProductDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) => ProductDetailModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  int id;
  String title;
  String articleNumber;
  String brandName;
  String condition;
  String originalRetailPrice;
  DateTime auctionStart;
  DateTime auctionEnd;
  String status;
  SellerId sellerId;
  dynamic soldTo;
  List<String> imageUrls;
  DateTime createdAt;
  DateTime updatedAt;
  int categoryId;
  String slug;
  List<Variant> variants;

  Data({
    required this.id,
    required this.title,
    required this.articleNumber,
    required this.brandName,
    required this.condition,
    required this.originalRetailPrice,
    required this.auctionStart,
    required this.auctionEnd,
    required this.status,
    required this.sellerId,
    required this.soldTo,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.slug,
    required this.variants,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    articleNumber: json["article_number"],
    brandName: json["brand_name"],
    condition: json["condition"],
    originalRetailPrice: json["original_retail_price"],
    auctionStart: DateTime.parse(json["auction_start"]),
    auctionEnd: DateTime.parse(json["auction_end"]),
    status: json["status"],
    sellerId: SellerId.fromJson(json["seller_id"]),
    soldTo: json["sold_to"],
    imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    categoryId: json["category_id"],
    slug: json["slug"],
    variants: List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
  );
}

class SellerId {
  int id;
  String userName;
  String email;

  SellerId({
    required this.id,
    required this.userName,
    required this.email,
  });

  factory SellerId.fromJson(Map<String, dynamic> json) => SellerId(
    id: json["id"],
    userName: json["user_name"],
    email: json["email"],
  );
}

class Variant {
  int id;
  String colorName;
  String colorCode;
  String sizeName;
  List<String> imageUrls;

  Variant({
    required this.id,
    required this.colorName,
    required this.colorCode,
    required this.sizeName,
    required this.imageUrls,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"],
    colorName: json["color_name"],
    colorCode: json["color_code"],
    sizeName: json["size_name"],
    imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
  );
}