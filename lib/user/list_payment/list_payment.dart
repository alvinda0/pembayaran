import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Pembayaran'),
        automaticallyImplyLeading: false, // Menghapus ikon kembali
      ),
      body: Center(child: Text('List Pembayaran')),
    );
  }
}