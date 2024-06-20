import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart' as MyProductProvider;
import 'package:beanbrewapps/models/product.dart';
import 'package:beanbrewapps/screens/detail_product.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category,
          style: TextStyle(color: Colors.white), // Warna teks header menjadi putih
        ),
        backgroundColor: Color(0xFF052B38), // Warna latar belakang header
        iconTheme: IconThemeData(
          color: Colors.white, // Warna panah navigasi menjadi putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<MyProductProvider.ProductDataProvider>(
          builder: (context, productProvider, _) {
            // Periksa isLoading
            if (productProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              // Filter produk berdasarkan kategori
              final productsInCategory = productProvider.products
                  .where((product) => product.category == category)
                  .toList();

              // Periksa apakah ada produk dalam kategori
              if (productsInCategory.isEmpty) {
                return Center(
                  child: Text('Tidak ada produk dalam kategori ini'),
                );
              }

              // Jika ada produk, tampilkan GridView
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: productsInCategory.length,
                itemBuilder: (context, index) {
                  final product = productsInCategory[index];
                  return ProductItemWidget(product: product);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final Product product;

  ProductItemWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Rp ${product.price.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(product.rating.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
