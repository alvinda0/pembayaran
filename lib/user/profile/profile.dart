
import 'package:flutter/material.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false, // Menghapus ikon kembali
      ),
      body: Center(child: Text('Profile Page')),
    );
  }
}
