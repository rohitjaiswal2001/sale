import 'package:flutter/material.dart';

class WishlistHeader extends StatelessWidget {
  final int itemCount;

  const WishlistHeader({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(),
        Text("Wishlist ($itemCount items)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag)),
      ],
    );
  }
}
