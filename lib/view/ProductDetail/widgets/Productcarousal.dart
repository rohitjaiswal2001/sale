// lib/widgets/product_carousel.dart
import 'package:bid4style/view/ProductDetail/productdetail.dart';
import 'package:bid4style/view/ProductDetail/widgets/fullscreenimage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ProductCarousel extends StatelessWidget {
  final List<String> imageUrls;
  final String baseUrl; // Base URL for images

  const ProductCarousel({
    super.key,
    required this.imageUrls,
    this.baseUrl = 'https://your-api-base-url.com', // Replace with actual base URL
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: imageUrls.map((url) {
        final fullUrl = '$baseUrl$url';
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImage(imageUrl: fullUrl),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              child: CachedNetworkImage(
                imageUrl: fullUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}