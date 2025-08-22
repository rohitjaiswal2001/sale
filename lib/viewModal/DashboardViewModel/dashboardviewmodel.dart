import 'dart:convert';
import 'dart:io';
import 'package:bid4style/resource/aapurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Category Model
class AuctionCategory {
  final int id;
  final String name;

  AuctionCategory({required this.id, required this.name});

  factory AuctionCategory.fromJson(Map<String, dynamic> json) {
    return AuctionCategory(id: json['id'], name: json['name']);
  }
}

/// Auction Item Model
class AuctionItem {
  final String title;
  final String price;
  final String size;
  final String location;
  final String imageUrl;

  AuctionItem({
    required this.title,
    required this.price,
    required this.size,
    required this.location,
    required this.imageUrl,
  });

  factory AuctionItem.fromJson(Map<String, dynamic> json) {
    return AuctionItem(
      title: json['title'] ?? "Untitled",
      price: json['original_retail_price']?.toString() ?? "N/A",
      size: json['size'] ?? "-",
      location: json['location'] ?? "-",
      imageUrl:
          (json['image_urls'] != null &&
              json['image_urls'] is List &&
              json['image_urls'].isNotEmpty)
          ? AppUrl.baseUrl + json['image_urls'][0]
          : "https://via.placeholder.com/150x150.png?text=No+Image",
    );
  }
}

/// ViewModel
class AuctionPageViewModel extends ChangeNotifier {
  List<AuctionCategory> categories = [];
  List<AuctionItem> items = [];
  List<OfferBanner> banners = [];
  bool isLoadingBanners = false;
  int _selectedCategoryId = 0; // default "All"
  int get selectedCategoryId => _selectedCategoryId;

  bool isLoadingCategories = false;
  bool isLoadingItems = false;

  AuctionPageViewModel() {
    Future.microtask(() async {
      await fetchCategories();
    });
  }

  /// Fetch carousel banners
  Future<void> fetchBanners() async {
    try {
      isLoadingBanners = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse("https://bid4stylepgre.visionvivante.in/cms/list-offers"),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body["status"] == true && body["data"] != null) {
          banners = (body["data"] as List)
              .map((e) => OfferBanner.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("fetchBanners error: $e");
    } finally {
      isLoadingBanners = false;
      notifyListeners();
    }
  }

  /// Fetch categories from API
  Future<void> fetchCategories() async {
    isLoadingCategories = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://bid4stylepgre.visionvivante.in/item/category-list"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        categories = (data['data'] as List)
            .map((e) => AuctionCategory.fromJson(e))
            .toList();

        // default select first category
        if (categories.isNotEmpty) {
          _selectedCategoryId = categories.first.id;
          await fetchItemsForCategory(_selectedCategoryId);
        }
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }

    isLoadingCategories = false;
    notifyListeners();
  }

  /// Fetch items for selected category
  Future<void> fetchItemsForCategory(int categoryId) async {
    _selectedCategoryId = categoryId;
    isLoadingItems = true;
    notifyListeners();

    try {
      String url =
          // "https://bid4stylepgre.visionvivante.in/item/list?category_id=$categoryId";
          "https://bid4stylepgre.visionvivante.in/item/list?category_id=9";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        items = (data['data'] as List)
            .map((e) => AuctionItem.fromJson(e))
            .toList();
      } else {
        items = [];
      }
    } catch (e) {
      debugPrint("Error fetching items: $e");
      items = [];
    }

    isLoadingItems = false;
    notifyListeners();
  }
}

class OfferBanner {
  final int id;
  final String name;
  final String imageUrl;
  final String title;
  final String subtitle;

  OfferBanner({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  factory OfferBanner.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> content =
        (json["content"] is Map<String, dynamic>) ? json["content"] : {};

    return OfferBanner(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      imageUrl:
          "https://bid4stylepgre.visionvivante.in${content["image"] ?? ""}",
      title: content["title"] ?? "",
      subtitle: content["subtitle"] ?? "",
    );
  }
}
