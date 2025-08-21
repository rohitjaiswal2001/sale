import 'package:bid4style/Models/wishlistproductModal.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlist = [
    Product(
      id: "1",
      brand: "Kotty",
      name: "Blue Jeans",
      imageUrl:
          "https://rukminim2.flixcart.com/image/832/832/xif0q/jean/x/i/a/32-lnb1075-lane-boy-original-imagrxuyjzccfbkc.jpeg",
      price: 599,
      oldPrice: 1999,
      discount: 70,
      rating: 4.0,
      reviews: 216,
    ),
    Product(
      id: "2",
      brand: "Thomas Scott",
      name: "Dark Navy Jeans",
      imageUrl:
          "https://rukminim2.flixcart.com/image/832/832/xif0q/jean/o/n/j/30-15271960-roadster-original-imagkzdpfytxkhjh.jpeg",
      price: 819,
      oldPrice: 3299,
      discount: 75,
      rating: 4.2,
      reviews: 180,
    ),
    Product(
      id: "3",
      brand: "Indian Garage Co",
      name: "Black Slim Jeans",
      imageUrl:
          "https://rukminim2.flixcart.com/image/832/832/xif0q/jean/f/f/t/32-10067846-mast-harbour-original-imag7h6rghmtuv9a.jpeg",
      price: 1019,
      oldPrice: 2549,
      discount: 60,
      rating: 4.1,
      reviews: 351,
    ),
    Product(
      id: "4",
      brand: "Highlander",
      name: "Regular Fit Black Jeans",
      imageUrl:
          "https://rukminim2.flixcart.com/image/832/832/xif0q/jean/9/k/x/32-10045646-roadster-original-imagjyd8xxuqywbp.jpeg",
      price: 769,
      oldPrice: 2749,
      discount: 72,
      rating: 3.6,
      reviews: 402,
    ),
    Product(
      id: "5",
      brand: "Levis",
      name: "Classic Blue Jeans",
      imageUrl:
          "https://rukminim2.flixcart.com/image/832/832/xif0q/jean/v/f/y/32-10098746-levis-original-imag7h8rtyuqwqz6.jpeg",
      price: 1999,
      oldPrice: 3999,
      discount: 50,
      rating: 4.5,
      reviews: 1200,
    ),
  ];

  List<Product> get wishlist => _wishlist;

  void addToWishlist(Product product) {
    _wishlist.add(product);
    notifyListeners();
  }

  void removeFromWishlist(String id) {
    _wishlist.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Example filter by category
  List<Product> filterByCategory(String category) {
    if (category == "All") return _wishlist;
    return _wishlist.where((p) => p.name.contains(category)).toList();
  }
}
