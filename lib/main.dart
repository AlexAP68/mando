import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mando/screens/qr_screen.dart';
import 'package:mando/screens/joystick_screen.dart';
import 'package:mando/screens/player_name_screen.dart';
import 'package:mando/screens/player_avatar_screen.dart';
import 'package:mando/controller/joystickcontrolador.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Unity Flutter Controller',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => QRScreen()),
        GetPage(name: '/playerName', page: () => PlayerNameScreen()),
        GetPage(name: '/playerAvatar', page: () => PlayerAvatarScreen()),
        GetPage(name: '/joystick', page: () => JoystickScreen()), // playerNumber will be set dynamically
      ],
    );
  }
}
