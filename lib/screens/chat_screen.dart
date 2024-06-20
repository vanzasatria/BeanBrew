import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  String _messageType = 'Keluhan';
  final _messageController = TextEditingController();

  void _submitMessage() {
    if (_formKey.currentState!.validate()) {
      final messageType = _messageType;
      final messageText = _messageController.text;

      Provider.of<ProductDataProvider>(context, listen: false)
          .addMessage('[$messageType] $messageText');

      _showNotification();
    }
  }

  void _showNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesan Terkirim'),
          content: Text(
              'Mohon maaf atas ketidaknyamanannya, Kami akan merespon pertanyaan/keluhan Anda secepatnya.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Layanan Pelanggan',
          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        backgroundColor: Color(0xFF052B38),
        iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna panah menjadi putih
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _messageType,
                decoration: InputDecoration(
                  labelText: 'Pilih Jenis Pesan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                items: ['Keluhan', 'Pertanyaan']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _messageType = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Pesan Anda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pesan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitMessage,
                  child: Text('Kirim'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF052B38),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            case 1:
              Navigator.pushNamed(context, '/orders');
              break;
            case 2:
              Navigator.pushNamed(context, '/inventory');
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
