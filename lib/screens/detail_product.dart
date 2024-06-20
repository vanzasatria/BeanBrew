import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/models/product.dart';
import 'package:beanbrewapps/providers/product_provider.dart';
import 'package:beanbrewapps/screens/cart_screen.dart'; // Pastikan untuk mengimpor CartScreen

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _addToCart() {
    Provider.of<ProductDataProvider>(context, listen: false)
        .addToCart(widget.product, _quantity);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.product.image,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Rp ${widget.product.price.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(widget.product.rating.toString()),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                    ),
                    Text('$_quantity'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Deskripsi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _addToCart,
                child: Text(
                  'Tambahkan ke dalam keranjang',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF052B38),),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
