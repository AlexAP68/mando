import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mando/screens/qr_screen.dart';
import 'package:mando/screens/joystick_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Unity Flutter Controller',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => QRScreen()),
        GetPage(name: '/joystick', page: () => JoystickScreen()),
      ],
    );
  }
}
