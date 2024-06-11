import 'package:products_app/data/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductRepository {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> fetchProductDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<List<Product>> fetchProductsByRating(double minRating) async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Product> allProducts = data.map((json) => Product.fromJson(json)).toList();
      return allProducts.where((product) => product.rating.rate >= minRating).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
