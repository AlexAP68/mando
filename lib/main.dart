// Archivo: main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/qr_screen.dart';
import 'screens/joystick_screen.dart';

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
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      getPages: [
        GetPage(name: Routes.home, page: () => QRScreen(), transition: Transition.fade),
        GetPage(
          name: Routes.joystickScreen, 
          page: () {
            var ipAddress = Get.arguments as String;  // Recibir argumentos
            return JoystickScreen(ipAddress: ipAddress);
          },
          transition: Transition.cupertino
        ),
      ],
    );
  }
}
