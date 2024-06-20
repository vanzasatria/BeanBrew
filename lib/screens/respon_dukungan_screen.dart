// respon_dukungan_screen.dart
import 'package:flutter/material.dart';

class ResponDukunganScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respon Dukungan', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF052B38),
         iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna panah menjadi putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Respon Dukungan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Terimakasih karena telah memberikan kritik dan saran dari Aplikasi BeanBrew, Kami akan segera memperbaiki sistem seger. Mohon Maaf atas ketidaknyamanan nya',
              style: TextStyle(fontSize: 16),
            ),
            // Tambahkan elemen lain yang diperlukan
          ],
        ),
      ),
    );
  }
}
