import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:mando/controller/joystickcontrolador.dart';

class JoystickScreen extends StatelessWidget {
  final JoystickControlador joystickController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Forzar la orientación horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return WillPopScope(
      onWillPop: () async {
        // Restaurar la orientación cuando se salga de la pantalla
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Unity Flutter Controller - Joystick'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Joystick a la izquierda
              Joystick(
                listener: (details) => joystickController.onDirectionChanged(details.x, details.y),
              ),
              // Botón a la derecha
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => joystickController.refreshConnection(),
                    child: Text('Refresh Connection'),
                  ),
                  SizedBox(height: 20),
                  Obx(() => Text(
                    joystickController.isConnected.value ? 'Connected' : 'Disconnected',
                    style: TextStyle(
                      color: joystickController.isConnected.value ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
