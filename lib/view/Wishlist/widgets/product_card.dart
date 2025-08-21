import 'package:bid4style/Models/wishlistproductModal.dart';
import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const ProductCard({super.key, required this.product, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Image.network(product.imageUrl, height: 150, fit: BoxFit.cover),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onRemove,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.brand,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("₹${product.price}  ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "₹${product.oldPrice} (${product.discount.toInt()}% OFF)",
              style: const TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.green),
                Text("${product.rating} (${product.reviews})"),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text("MOVE TO BAG")),
        ],
      ),
    );
  }
}
