import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:beanbrewapps/models/product.dart';
import 'package:beanbrewapps/models/order.dart';
import 'package:beanbrewapps/models/address.dart';
import 'dart:collection'; // Pastikan mengimpor dart:collection

class ProductDataProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Product> _products = [];
  List<Product> _recommendations = [];
  List<Product> _bestSellers = [];
  List<Product> _searchResults = [];
  List<Map<String, dynamic>> _cartItems = [];
  List<Order> _orders = [];
  Address? _userAddress;
  bool _hasNewMessage = false;

  // User profile data
  String _userName = 'Gabriella Abigail';
  String _userEmail = 'ellay@gmail.com';
  String _userPhone = '+1234567890';

  final _searchSubject = BehaviorSubject<String>();

  bool get isLoading => _isLoading;
  List<Product> get products => _products;
  List<Product> get recommendations => _recommendations;
  List<Product> get bestSellers => _bestSellers;
  List<Product> get searchResults => _searchResults;
  List<Map<String, dynamic>> get cartItems => UnmodifiableListView(_cartItems);
  List<Order> get orders => UnmodifiableListView(_orders);
  Address? get userAddress => _userAddress;
  bool get hasNewMessage => _hasNewMessage;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;

  ProductDataProvider() {
    fetchProducts();
    fetchUserAddress();
    _searchSubject.stream
        .debounceTime(Duration(milliseconds: 300))
        .distinct()
        .listen((query) {
      _searchProducts(query);
    });
  }

  Future<void> fetchProducts({String category = ''}) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        'http://localhost:3000/api/items${category.isNotEmpty ? '?category=$category' : ''}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> extractedData = json.decode(response.body);
        final List<Product> loadedProducts = extractedData
            .map<Product>((json) => Product.fromJson(json))
            .toList();

        _products = loadedProducts;
        _recommendations =
            _products.where((prod) => prod.isRecommended).toList();
        _bestSellers = _products.where((prod) => prod.isBestSeller).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _searchProducts(String query) async {
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _searchResults = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    final url = Uri.parse('http://localhost:3000/api/items?query=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> extractedData = json.decode(response.body);
        final List<Product> loadedProducts = extractedData
            .map<Product>((json) => Product.fromJson(json))
            .toList();

        _searchResults = loadedProducts;
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchSubject.add(query);
  }

  Future<void> fetchUserAddress() async {
    final url = Uri.parse('http://localhost:3000/api/address');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> extractedData = json.decode(response.body);
        _userAddress = Address.fromJson(extractedData);
      } else {
        throw Exception('Failed to load address');
      }
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> setUserAddress(Address address) async {
    final url = Uri.parse('http://localhost:3000/api/address');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(address.toJson()),
      );
      if (response.statusCode == 201) {
        _userAddress = address;
      } else {
        throw Exception('Failed to set address');
      }
    } catch (error) {
      throw error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> filterProductsByCategory(String category) async {
    await fetchProducts(category: category);
  }

  void addToCart(Product product, int quantity) {
    final existingIndex =
        _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex]['quantity'] += quantity;
    } else {
      _cartItems.add({'product': product, 'quantity': quantity});
    }
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void removeSelectedItems(List<Map<String, dynamic>> selectedItems) {
    selectedItems.forEach((selectedItem) {
      _cartItems.removeWhere(
          (item) => item['product'].id == selectedItem['product'].id);
    });
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void addMessage(String message) {
    _hasNewMessage = true;
    notifyListeners();
  }

  void clearNewMessageFlag() {
    _hasNewMessage = false;
    notifyListeners();
  }

  void updateUserProfile(String name, String email, String phone) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchSubject.close();
    super.dispose();
  }
}
