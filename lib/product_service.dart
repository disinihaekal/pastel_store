import 'dart:convert';

import 'package:http/http.dart' as http;

import 'product.dart';

class ProductService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products?limit=0'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil produk');
    }

    final data = jsonDecode(response.body);
    final List<dynamic> products = data['products'];

    return products.map((item) => Product.fromJson(item)).toList();
  }

  Future<Product> getProductDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail produk');
    }

    return Product.fromJson(jsonDecode(response.body));
  }

  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.https('dummyjson.com', '/products/search', {
      'q': query,
      'limit': '0',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Gagal mencari produk');
    }

    final data = jsonDecode(response.body);
    final List<dynamic> products = data['products'];

    return products.map((item) => Product.fromJson(item)).toList();
  }
}
