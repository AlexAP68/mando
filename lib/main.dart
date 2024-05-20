// Archivo: main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mando/screens/qr_screen.dart';
import 'package:mando/screens/joystick_screen.dart';


void main() {
  runApp(MyApp());
}

class Routes {
  static const String home = '/home';
  static const String qrScreen = '/qr';
  static const String joystickScreen = '/joystick';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Unity Flutter Controller',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => QRScreen()),
        GetPage(name: '/joystick', page: () => JoystickScreen()), // playerNumber will be set dynamically
      ],
    );
  }
}
