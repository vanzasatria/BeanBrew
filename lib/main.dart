import 'package:beanbrewapps/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart';
import 'package:beanbrewapps/screens/home_screen.dart';
import 'package:beanbrewapps/screens/chat_screen.dart';
import 'package:beanbrewapps/screens/inventory_screen.dart';
import 'package:beanbrewapps/screens/order_screen.dart';
import 'package:beanbrewapps/screens/profile_screen.dart';
import 'package:beanbrewapps/screens/category_screen.dart';
import 'package:beanbrewapps/models/product.dart';
import 'package:beanbrewapps/screens/detail_product.dart';
import 'package:beanbrewapps/screens/cart_screen.dart';
import 'package:beanbrewapps/screens/checkout_screen.dart';
import 'package:beanbrewapps/models/order.dart';
import 'package:beanbrewapps/screens/tracking_screen.dart';
import 'package:beanbrewapps/screens/notifikasi_screen.dart';
import 'package:beanbrewapps/screens/respon_dukungan_screen.dart';
import 'package:beanbrewapps/screens/login_screen.dart';
import 'package:beanbrewapps/screens/register_screen.dart';
import 'package:beanbrewapps/screens/splash_screen.dart'; // Import SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductDataProvider()),
      ],
      child: BeanBrewApp(),
    ),
  );
}

class BeanBrewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bean Brew',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Tambahkan baris ini
      home: SplashScreen(), // Set SplashScreen as the initial route
      routes: {
        '/inventory': (context) => InventoryScreen(),
        '/chat': (context) => ChatScreen(),
        '/profile': (context) => ProfileScreen(),
        '/productDetail': (context) => ProductDetailScreen(
            product: ModalRoute.of(context)!.settings.arguments as Product),
        '/cart': (context) => CartScreen(),
        '/orders': (context) => OrdersScreen(),
        '/tracking': (context) => TrackingScreen(),
        '/notifikasi': (context) => NotifikasiScreen(),
        '/responDukungan': (context) => ResponDukunganScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/category') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return CategoryScreen(category: args['category']);
            },
          );
        } else if (settings.name == '/checkout') {
          final selectedItems =
              settings.arguments as List<Map<String, dynamic>>;
          return MaterialPageRoute(
            builder: (context) {
              return CheckoutScreen(selectedItems: selectedItems);
            },
          );
        } else if (settings.name == '/orders') {
          return MaterialPageRoute(
            builder: (context) {
              return OrdersScreen();
            },
          );
        }
        return null;
      },
    );
  }
}


class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ProductDataProvider>(context, listen: false).fetchProducts();

    _searchController.addListener(() {
      setState(() {
        Provider.of<ProductDataProvider>(context, listen: false)
            .setSearchQuery(_searchController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDataProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Product> filteredProducts = productProvider.searchResults;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              _buildSearchResults(filteredProducts),
              _buildCategorySection(),
              _buildRecommendationSection(productProvider),
              _buildBestSellerSection(productProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hallo, bolo!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Temukan biji kopi terbaikmu',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Cari biji kopi',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            suffixIcon: Icon(Icons.search),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSearchResults(List<Product> filteredProducts) {
    if (_searchController.text.isNotEmpty && filteredProducts.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil Pencarian',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: ProductItem(product: product),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryItem(context, 'Arabica'),
            _buildCategoryItem(context, 'Robusta'),
            _buildCategoryItem(context, 'Liberica'),
            _buildCategoryItem(context, 'Excelsa'),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(category: category),
          ),
        );
      },
      child: Chip(
        label: Text(
          category,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection(ProductDataProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rekomendasi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productProvider.recommendations.length,
            itemBuilder: (context, index) {
              final product = productProvider.recommendations[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: ProductItem(product: product),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildBestSellerSection(ProductDataProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biji Kopi Terlaris',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productProvider.bestSellers.length,
            itemBuilder: (context, index) {
              final product = productProvider.bestSellers[index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: ProductItem(product: product),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              product.image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  'Rp ${product.price}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF052B38),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 5),
                    Text(
                      product.rating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
