import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:mando/controller/joystickcontroller.dart' as my_controller;

class JoystickScreen extends StatelessWidget {
  final String ipAddress;

  JoystickScreen({required this.ipAddress}) {
    Get.put(my_controller.JoystickController(ipAddress));
  }

  @override
  Widget build(BuildContext context) {
    final my_controller.JoystickController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unity Flutter Controller - Joystick'),
      ),
      body: Center(
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Joystick a la izquierda en un contenedor centrado
            Expanded(
              flex: 5, // Proporción para el joystick
              child: Center(  // Asegura que el Joystick esté centrado
                child: Container(
                  width: 200, // Incrementa el tamaño si es necesario
                  height: 200,
                  alignment: Alignment.center, // Alineación central
                  child: Joystick(
                    listener: (details) => controller.onDirectionChanged(details.x, details.y),
                  ),
                ),
              ),
            ),
            Spacer(), // Espacio entre el joystick y el botón
            // Botón a la derecha
            Expanded(
              flex: 2, // Proporción para el botón
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.refreshConnection,
                    child: Text('Refresh Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(controller.connectionStatus.value),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
