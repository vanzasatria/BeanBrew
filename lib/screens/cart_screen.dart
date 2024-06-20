import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/models/product.dart';
import 'package:beanbrewapps/providers/product_provider.dart';
import 'package:beanbrewapps/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _selectedItems = [];

  void _toggleSelection(Map<String, dynamic> item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Color(0xFF052B38),
         iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna panah menjadi putih
        ),
        titleTextStyle: TextStyle(
          color: Colors.white, // Ubah warna tulisan menjadi putih
          fontSize: 20, // Ukuran font
          fontWeight: FontWeight.bold, // Berat font
        ),
      ),
      body: Consumer<ProductDataProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.cartItems.isEmpty) {
            return Center(
              child: Text('Keranjang Anda kosong.'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: productProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = productProvider.cartItems[index];
                    final product = item['product'] as Product;
                    final quantity = item['quantity'] as int;

                    return ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      subtitle: Text('Rp ${product.price.toStringAsFixed(0)} x $quantity'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _selectedItems.contains(item),
                            onChanged: (bool? value) {
                              _toggleSelection(item);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              productProvider.removeFromCart(index);
                              setState(() {
                                _selectedItems.remove(item);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _selectedItems.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                selectedItems: _selectedItems,
                              ),
                            ),
                          );
                        },
                  child: Text('Lanjut ke Pembayaran'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF052B38)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
