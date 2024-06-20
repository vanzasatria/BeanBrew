import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final newItem = {
        'id': DateTime.now().toString(), // Generate unique ID
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'category': _categoryController.text,
        'image': _imageController.text,
        'rating': 0.0,
        'isRecommended': false,
        'isBestSeller': false,
      };

      final url = Uri.parse('http://localhost:3000/api/items');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newItem),
        );
        if (response.statusCode == 201) {
          // If the server returns an OK response, display a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully!')),
          );
          _nameController.clear();
          _descriptionController.clear();
          _priceController.clear();
          _categoryController.clear();
          _imageController.clear();
        } else {
          // If the server returns an error response, display an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add product!')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventaris',
          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
        backgroundColor: Color(0xFF052B38),
        iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna panah menjadi putih
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input Inventaris',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Warna teks hitam
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: Colors.black), // Warna teks hitam
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black), // Warna teks hitam
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama produk';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: Colors.black), // Warna teks hitam
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black), // Warna teks hitam
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan deskripsi produk';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                style: TextStyle(color: Colors.black), // Warna teks hitam
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                  labelStyle: TextStyle(color: Colors.black), // Warna teks hitam
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga produk';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                style: TextStyle(color: Colors.black), // Warna teks hitam
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black), // Warna teks hitam
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kategori produk';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                style: TextStyle(color: Colors.black), // Warna teks hitam
                decoration: InputDecoration(
                  labelText: 'URL Gambar',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black), // Warna teks hitam
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan URL gambar produk';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addProduct,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color(0xFF052B38),
                  ), // Warna latar belakang
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white), // Warna teks putih
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
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
