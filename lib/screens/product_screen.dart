import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart';
import 'package:beanbrewapps/widgets/product_item.dart';
import 'package:beanbrewapps/models/product.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDataProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bean Brew'),
          backgroundColor: Color(0xFF052B38),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rekomendasi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildRecommendationList(),
                SizedBox(height: 20),
                Text(
                  'Biji Kopi Terlaris',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildBestSellerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationList() {
    return Consumer<ProductDataProvider>(
      builder: (context, productProvider, _) {
        if (productProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          final List<Product> recommendedProducts =
              productProvider.recommendations;
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedProducts.length,
              itemBuilder: (context, index) {
                final product = recommendedProducts[index];
                return ProductItem(product: product);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildBestSellerList() {
    return Consumer<ProductDataProvider>(
      builder: (context, productProvider, _) {
        if (productProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          final List<Product> bestSellerProducts = productProvider.bestSellers;
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bestSellerProducts.length,
              itemBuilder: (context, index) {
                final product = bestSellerProducts[index];
                return ProductItem(product: product);
              },
            ),
          );
        }
      },
    );
  }
}
