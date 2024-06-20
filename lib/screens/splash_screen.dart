import 'package:flutter/material.dart';
import 'package:beanbrewapps/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF052B38), // Background color sesuai gambar
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/beanbrewlogosplash.png'),
            ],
          ),
        ),
      ),
    );
  }
}
