import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:beanbrewapps/models/product.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    String apiUrl = 'https://example.com/api/products';

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Product> products = data.map((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        print('Failed to load products: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error loading products: $error');
      return [];
    }
  }
}
