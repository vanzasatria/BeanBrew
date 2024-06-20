import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart';
import 'package:beanbrewapps/screens/login_screen.dart'; // Import LoginScreen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductDataProvider>(context, listen: false);
    _nameController.text = productProvider.userName;
    _emailController.text = productProvider.userEmail;
    _phoneController.text = productProvider.userPhone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    final productProvider = Provider.of<ProductDataProvider>(context, listen: false);
    productProvider.updateUserProfile(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  void _logout() {
    // Tambahkan logika logout di sini (seperti menghapus token)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(color: Colors.white)), // Ubah warna tulisan menjadi putih
        backgroundColor: Color(0xFF052B38),
        iconTheme: IconThemeData(color: Colors.white), // Ubah warna panah kembali menjadi putih
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Akun',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                color: Color.fromRGBO(255, 255, 255, 1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/ellaprofil.jpg'),
                        radius: 30,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama: ${_nameController.text}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Email: ${_emailController.text}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'Nomor Telepon: ${_phoneController.text}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Pengaturan Akun',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Ubah Nama'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  _showEditDialog('Nama', _nameController);
                },
              ),
              ListTile(
                title: Text('Ubah Email'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  _showEditDialog('Email', _emailController);
                },
              ),
              ListTile(
                title: Text('Ubah Nomor Telepon'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  _showEditDialog('Nomor Telepon', _phoneController);
                },
              ),
              SizedBox(height: 20),
              Text(
                'Developer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildDeveloperCard(
                        'Vanza Satria Pringga Pratama',
                        '22082010032',
                        'Batam, 19 Agustus 2024',
                        '089654576801',
                        '22082010032@student.upnjatim.ac.id',
                        'assets/vanzaprofil.png'),
                    SizedBox(width: 10),
                    buildDeveloperCard(
                        'Nadiyah Syaidatus Shofa Abdul Hayat',
                        '22082010038',
                        'Gresik, 13 Mei 2004',
                        '081252168212',
                        '22082010038@student.upnjatim.ac.id',
                        'assets/nanadprofil.jpg'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF052B38),),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  void _showEditDialog(String field, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Masukkan $field baru',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
              _updateProfile();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget buildDeveloperCard(String name, String npm, String birthInfo, String phoneNumber, String email, String imagePath) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagePath),
              radius: 30,
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              npm,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              birthInfo,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              phoneNumber,
              style: TextStyle(color: Colors.black),
            ),
            Text(
              email,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
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
            case 3:
              Navigator.pushNamed(context, '/chat');
              break;
          }
        },
      ),
    );
  }
}
