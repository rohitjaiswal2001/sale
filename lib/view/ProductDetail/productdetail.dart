import 'package:bid4style/resource/aapurl.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/ProductDetail/widgets/Productcarousal.dart';
import 'package:bid4style/viewModal/ProductViewModal/productdetailProvider.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:bid4style/widgets/flip_clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailPage extends StatefulWidget {
  final String slug;

  const ProductDetailPage({super.key, required this.slug});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<ProductDetailViewModel>(
          context,
          listen: false,
        ).fetchProduct(widget.slug);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return _buildLoadingShimmer();
        }

        if (vm.error.isNotEmpty) {
          return Center(
            child: Text(
              vm.error,
              style: CustomTextStyle.text14.copyWith(color: AppColors.grey),
            ),
          );
        }

        if (vm.data == null) {
          return const Center(
            child: Text('No data found', style: TextStyle(color: Colors.grey)),
          );
        }

        final product = vm.data!;
        final firstVariant = product.variants.isNotEmpty
            ? product.variants.first
            : null;

        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: AppColors.grey400,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductCarousel(
                  imageUrls: product.imageUrls,
                  baseUrl: AppUrl
                      .baseUrl, // Replace with your actual image server URL
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: CustomTextStyle.heading20.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${product.brandName} - ${product.condition}',
                            style: CustomTextStyle.text14.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Starting Bid \$${product.originalRetailPrice}',
                            style: CustomTextStyle.heading20.copyWith(
                              color: AppColors.themecolor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Implement bid functionality
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.themecolor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Buy now',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Icon(
                                Icons.alarm,
                                color: AppColors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Auction ends in: ${formatRemainingTime(product.auctionEnd)}",
                                style: CustomTextStyle.text14.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          Text(
                            'Details',
                            style: CustomTextStyle.heading20.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow('Origin', 'UK'),
                          _buildDetailRow(
                            'Size',
                            firstVariant?.sizeName ?? 'N/A',
                          ),
                          _buildDetailRow(
                            'Color',
                            firstVariant?.colorName ?? 'N/A',
                          ),
                          _buildDetailRow(
                            'Product Type',
                            product.categoryId.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seller',
                            style: CustomTextStyle.heading20.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.grey,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.sellerId.userName,
                                      style: CustomTextStyle.text14,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Implement view store functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.themecolor,
                                  side: BorderSide(color: AppColors.themecolor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                                child: const Text(
                                  'View Store',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Return within 7 days of delivery',
                            style: CustomTextStyle.text14.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Similar Products',
                        style: CustomTextStyle.heading20.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSimilarProductsGrid(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(height: 250, color: Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      6,
                      (index) => Container(
                        height: index == 0 ? 30 : 20,
                        width: double.infinity,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: CustomTextStyle.text14.copyWith(color: AppColors.grey),
          ),
          Text(value, style: CustomTextStyle.text14),
        ],
      ),
    );
  }

  Widget _buildSimilarProductsGrid() {
    final List<Map<String, String>> similar = [
      {'image': 'assets/icons/bid1.png', 'title': 'Vintage Knit'},
      {'image': 'assets/icons/bid1.png', 'title': 'Vintage Knit'},
      {'image': 'assets/icons/bid1.png', 'title': 'Vintage Knit'},
      {'image': 'assets/icons/bid1.png', 'title': 'Vintage Knit'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: similar.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  similar[index]['image']!,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  similar[index]['title']!,
                  style: CustomTextStyle.text14,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatRemainingTime(DateTime endTime) {
    final now = DateTime.now();
    final diff = endTime.difference(now);

    if (diff.isNegative) return "Ended";

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;

    return "$days d $hours h $minutes m";
  }
}
