import 'package:flutter/material.dart';

class AuctionItem {
  final String title;
  final String price;
  final String size;
  final String location;
  final String imageUrl;
  final String category;

  AuctionItem({
    required this.title,
    required this.price,
    required this.size,
    required this.location,
    required this.imageUrl,
    required this.category,
  });
}

class AuctionPageViewModel extends ChangeNotifier {
  final List<String> categories = ["All", "Shirts", "Shoes", "Trousers"];

  String _selectedCategory = "All";
  String get selectedCategory => _selectedCategory;

  final List<String> banners = [
    "https://via.placeholder.com/350x150/FF5733/FFFFFF?text=Big+Offer+1",
    "https://via.placeholder.com/350x150/33C1FF/FFFFFF?text=Big+Offer+2",
    "https://via.placeholder.com/350x150/8E44AD/FFFFFF?text=Big+Offer+3",
  ];

  final List<AuctionItem> _items = [
    AuctionItem(
      title: "Premium Shirt",
      price: "₹ 822",
      size: "M / 42",
      location: "India - 95091",
      imageUrl: "https://via.placeholder.com/150x150.png?text=Shirt",
      category: "Shirts",
    ),
    AuctionItem(
      title: "Jordan",
      price: "₹ 1999",
      size: "42",
      location: "India - 95091",
      imageUrl: "https://via.placeholder.com/150x150.png?text=Shoes",
      category: "Shoes",
    ),
    AuctionItem(
      title: "Premium Shirt",
      price: "₹ 899",
      size: "M / 42",
      location: "India - 95091",
      imageUrl: "https://via.placeholder.com/150x150.png?text=Shirt",
      category: "Shirts",
    ),
    AuctionItem(
      title: "Track Pants",
      price: "₹ 699",
      size: "L",
      location: "India - 95091",
      imageUrl: "https://via.placeholder.com/150x150.png?text=Trousers",
      category: "Trousers",
    ),
  ];

  List<AuctionItem> get filteredItems {
    if (_selectedCategory == "All") return _items;
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
