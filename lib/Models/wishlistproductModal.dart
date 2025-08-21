class Product {
  final String id;
  final String brand;
  final String name;
  final String imageUrl;
  final double price;
  final double oldPrice;
  final double discount;
  final double rating;
  final int reviews;

  Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.reviews,
  });
}
