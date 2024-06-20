import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart';
import 'package:beanbrewapps/widgets/product_item.dart';
import 'package:beanbrewapps/screens/detail_product.dart';
import 'package:beanbrewapps/screens/category_screen.dart';
import 'package:beanbrewapps/screens/cart_screen.dart';
import 'package:beanbrewapps/screens/notifikasi_screen.dart';
import 'package:beanbrewapps/models/product.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghapus panah back
        title: Image.asset(
          'assets/logoBeanBrew.png', // Ganti dengan path gambar logo Anda
          height: 30, // Sesuaikan tinggi gambar sesuai kebutuhan
        ),
        backgroundColor: Color(0xFF052B38),
        actions: [
          Consumer<ProductDataProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.hasNewMessage) {
                return IconButton(
                  icon: Icon(Icons.notification_important, color: Colors.white),
                  onPressed: () {
                    productProvider.clearNewMessageFlag();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotifikasiScreen(),
                      ),
                    );
                  },
                );
              }
              return IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotifikasiScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: HomeBody(),
      bottomNavigationBar: BottomNavBar(),
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
    _searchController.addListener(_onSearchChanged);
    // Fetch products when the screen initializes
    Provider.of<ProductDataProvider>(context, listen: false).fetchProducts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<ProductDataProvider>(context, listen: false)
        .setSearchQuery(_searchController.text);
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

        // Filter products based on search query
        List<Product> filteredProducts = productProvider.searchResults;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Halo, Bolo !!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Cart Icon and Search bar
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                  ),
                  Expanded(child: _buildSearchBar()),
                ],
              ),
              SizedBox(height: 20),
              // Display search results if available
              _buildSearchResults(filteredProducts),

              // Categories
              _buildCategorySection(),

              // Recommendations
              _buildRecommendationSection(productProvider),

              // Best sellers
              _buildBestSellerSection(productProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Cari biji kopi',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        suffixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildSearchResults(List<Product> filteredProducts) {
    if (_searchController.text.isNotEmpty) {
      if (filteredProducts.isNotEmpty) {
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
        return Center(
          child: Text('Tidak ada hasil ditemukan'),
        );
      }
    } else {
      return SizedBox.shrink(); // Hide search results if search is empty or no results found
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
        backgroundColor: Color(0xFF052B38),
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

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFF052B38),
        primaryColor: Colors.white,
        textTheme: Theme.of(context).textTheme.copyWith(
              caption: TextStyle(color: Colors.white),
            ),
      ),
      child: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventaris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Customer Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/orders');
              break;
            case 2:
              Navigator.pushNamed(context, '/inventory');
              break;
            case 3:
              Navigator.pushNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
