import 'package:flutter/material.dart';
import 'package:beanbrewapps/models/product.dart';
import 'package:beanbrewapps/models/order.dart';
import 'package:beanbrewapps/models/address.dart'; // Pastikan mengimpor Address di sini
import 'package:provider/provider.dart';
import 'package:beanbrewapps/providers/product_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;

  CheckoutScreen({required this.selectedItems});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const double adminFee = 5000.0;
  static const double shippingFee = 5000.0;
  String _selectedPaymentMethod = 'credit_card';
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final address = Provider.of<ProductDataProvider>(context, listen: false).userAddress;
    if (address != null) {
      _addressController.text = '${address.title}, ${address.name}, ${address.phone}, ${address.street}, ${address.city}, ${address.province}, ${address.postalCode}, ${address.note}';
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  double _calculateSubtotal() {
    double subtotal = 0.0;
    for (var item in widget.selectedItems) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      subtotal += product.price * quantity;
    }
    return subtotal;
  }

  double _calculateTotalPrice() {
    return _calculateSubtotal() + adminFee + shippingFee;
  }

  void _handlePayment() {
    // Simpan pesanan ke dalam state global
    for (var item in widget.selectedItems) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      final totalPrice = product.price * quantity.toDouble();
      final newOrder = Order(
        product: product,
        quantity: quantity,
        totalPrice: totalPrice,
        status: 'Menunggu Pembayaran',
      );

      Provider.of<ProductDataProvider>(context, listen: false).addOrder(newOrder);
    }

    // Hapus item yang dibayar dari keranjang
    Provider.of<ProductDataProvider>(context, listen: false).removeSelectedItems(widget.selectedItems);

    // Tampilkan pop-up pembayaran berhasil
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pembayaran Berhasil'),
        content: Text('Produk Anda akan segera diproses dan masuk ke halaman pesanan.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              Navigator.of(context).pushReplacementNamed('/orders'); // Arahkan ke OrderScreen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveAddress() {
    final parts = _addressController.text.split(', ');
    if (parts.length == 8) {
      final address = Address(
        title: parts[0],
        name: parts[1],
        phone: parts[2],
        street: parts[3],
        city: parts[4],
        province: parts[5],
        postalCode: parts[6],
        note: parts[7],
      );
      Provider.of<ProductDataProvider>(context, listen: false).setUserAddress(address);
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<ProductDataProvider>(context).userAddress;
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF052B38),
        iconTheme: IconThemeData(
          color: Colors.white, // Ubah warna panah menjadi putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Pesanan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.selectedItems.length,
                      itemBuilder: (context, index) {
                        final item = widget.selectedItems[index];
                        final product = item['product'] as Product;
                        final quantity = item['quantity'] as int;
                        return ListTile(
                          leading: Image.network(
                            product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.name),
                          subtitle: Text('Rp ${product.price.toStringAsFixed(0)} x $quantity'),
                        );
                      },
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      'Subtotal: Rp ${_calculateSubtotal().toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Biaya Admin: Rp ${adminFee.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Ongkir: Rp ${shippingFee.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total: Rp ${_calculateTotalPrice().toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metode Pembayaran',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text('Kartu Kredit'),
                      leading: Radio<String>(
                        value: 'credit_card',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Transfer Bank'),
                      leading: Radio<String>(
                        value: 'bank_transfer',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Cash on Delivery'),
                      leading: Radio<String>(
                        value: 'cash_on_delivery',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat Pengiriman',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if (address != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${address.title}, ${address.name}'),
                          Text('${address.phone}'),
                          Text('${address.street}, ${address.city}'),
                          Text('${address.province}, ${address.postalCode}'),
                          Text('Catatan: ${address.note}'),
                        ],
                      )
                    else
                      Text('Tidak ada alamat yang tersimpan'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Alamat Baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveAddress,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                 foregroundColor: Colors.white, backgroundColor: Color(0xFF052B38),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _handlePayment,
                  child: Text('Bayar'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFF052B38),
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
