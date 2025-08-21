import 'package:bid4style/view/Wishlist/widgets/filterchip.dart';
import 'package:bid4style/view/Wishlist/widgets/product_card.dart';
import 'package:bid4style/view/Wishlist/widgets/wishlist_header.dart';
import 'package:bid4style/viewModal/ProductViewModal/wishlist_providerviewmodal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WishlistProvider(),
      child: const WishlistScreenI(),
    );
  }
}
  
class WishlistScreenI extends StatefulWidget {
  const WishlistScreenI({super.key});

  @override
  State<WishlistScreenI> createState() => _WishlistScreenIState();
}

class _WishlistScreenIState extends State<WishlistScreenI> {
  String selectedFilter = "All";
  final filters = ["All", "Jeans", "Sarees", "Dresses"];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WishlistProvider>(context);
    final products = provider.filterByCategory(selectedFilter);

    return Scaffold(
      appBar: AppBar(
        title: WishlistHeader(itemCount: provider.wishlist.length),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          FilterChips(
            filters: filters,
            selected: selectedFilter,
            onSelected: (filter) {
              setState(() {
                selectedFilter = filter;
              });
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onRemove: () => provider.removeFromWishlist(product.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
