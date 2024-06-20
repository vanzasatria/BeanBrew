import 'package:flutter/material.dart';
import 'package:beanbrewapps/models/order.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart';
import 'tracking_screen.dart'; // Import TrackingScreen

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesanan',
          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        backgroundColor: Color(0xFF052B38),
        iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna panah menjadi putih
        ),
      ),
      body: Consumer<ProductDataProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.orders.isEmpty) {
            return Center(
              child: Text('Tidak ada pesanan.'),
            );
          }

          return ListView.builder(
            itemCount: productProvider.orders.length,
            itemBuilder: (context, index) {
              final order = productProvider.orders[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            order.product.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.product.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('Jumlah: ${order.quantity}'),
                                Text('Total: Rp ${order.totalPrice}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackingScreen(), // Navigasi ke TrackingScreen
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF052B38),
                        ),
                        child: Text('Lacak Pengiriman'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(), // Tambahkan ini
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
            case 0:
              Navigator.pushNamed(context, '/home');
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
