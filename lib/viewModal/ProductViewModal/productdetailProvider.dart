// lib/viewmodels/product_detail_viewmodel.dart
import 'dart:convert';

import 'package:bid4style/resource/aapurl.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../Models/productDetailModal.dart';

class ProductDetailViewModel extends ChangeNotifier {
  Data? data;
  bool isLoading = false;
  String error = '';

  Future<void> fetchProduct(String slug) async {
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      const String baseUrl = AppUrl.baseUrl; // Replace with actual base URL
      final response = await http.get(
        Uri.parse('$baseUrl/item/item-details/$slug'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          data = Data.fromJson(json['data']);
        } else {
          error = json['message'];
        }
      } else {
        error = 'Failed to load product details';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
