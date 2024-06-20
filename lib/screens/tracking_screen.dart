import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan dalam Pengiriman', style: TextStyle(color: Colors.white), ),
        backgroundColor: Color(0xFF052B38),
         iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna panah menjadi putih
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimasi diterima tanggal\nMin, 16 Jun 2024',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Dikirim dengan Hemat - JNE',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No. Resi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      'JNEID040929305636',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // Implementasi salin resi
                      },
                      child: Text(
                        'SALIN',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 20, color: Colors.grey),
            TrackingStep(
              status: 'Pesanan dalam Pengiriman',
              description: 'Pesanan sedang diantar ke alamat tujuan',
              time: 'Hari ini 10:37',
              isActive: true,
            ),
            TrackingStep(
              status: 'Kurir sudah ditugaskan',
              description: 'Pesanan segera dikirim',
              time: 'Hari ini 08:25',
            ),
            TrackingStep(
              status: 'Pesanan telah sampai di lokasi transit terakhir',
              description: 'Surabaya Hub',
              time: 'Hari ini 07:58',
            ),
            TrackingStep(
              status: 'Pesanan diproses di lokasi transit terakhir',
              description: '',
              time: 'Hari ini 07:35',
            ),
            TrackingStep(
              status: 'Pesanan sedang dalam perjalanan menuju ke Surabaya Hub',
              description: '',
              time: 'Hari ini 02:06',
            ),
            TrackingStep(
              status: 'Pesanan telah sampai di lokasi sortir Rungkut DC',
              description: '',
              time: 'Hari ini 01:29',
            ),
            TrackingStep(
              status: 'Pesanan diproses di lokasi transit terakhir',
              description: '',
              time: '15 Jun 23:21',
            ),
            TrackingStep(
              status: 'Pesanan sedang dalam perjalanan menuju ke Rungkut DC',
              description: '',
              time: '15 Jun 22:21',
            ),
            TrackingStep(
              status: 'Pesanan telah sampai di lokasi sortir Surabaya DC',
              description: '',
              time: '15 Jun 22:08',
            ),
            TrackingStep(
              status: 'Pesanan telah sampai di lokasi transit Hub',
              description: '',
              time: '15 Jun 20:06',
            ),
          ],
        ),
      ),
    );
  }
}

class TrackingStep extends StatelessWidget {
  final String status;
  final String description;
  final String time;
  final bool isActive;

  TrackingStep({
    required this.status,
    required this.description,
    required this.time,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Icon(
                  Icons.circle,
                  color: isActive ? Colors.green : Colors.grey,
                  size: 16,
                ),
                if (!isActive)
                  Container(
                    width: 2,
                    height: 50,
                    color: Colors.grey,
                  ),
              ],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.green : Colors.black,
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
