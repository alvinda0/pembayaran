import 'package:flutter/material.dart';
import 'package:pembayaran/onbording.dart';

void main() => runApp(ThynkUnlimitedApp());

class ThynkUnlimitedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thynk Unlimited',
      home: ThynkUnlimitedHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
