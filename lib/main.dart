import 'package:flutter/material.dart';
import 'package:mando/screens/qr_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unity Flutter Controller',
      home: QRScreen(),
    );
  }
}
