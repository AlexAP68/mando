import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:mando/controller/joystickcontrolador.dart';
import 'package:mando/utilitis/joystickdirection.dart';
import 'dart:async';

class JoystickScreen extends StatefulWidget {
  @override
  _JoystickScreenState createState() => _JoystickScreenState();
}

class _JoystickScreenState extends State<JoystickScreen> {
  final JoystickControlador joystickController = Get.find();
  JoystickDirection lastDirection = JoystickDirection(0.0, 0.0);
  Timer? _timer;
  JoystickDirection currentDirection = JoystickDirection(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    _startSendingDirections();

    final Map<String, dynamic> arguments = Get.arguments;
    final name = arguments['name'] ?? 'Unknown';
    final imageBase64 = arguments['imageBase64'] ?? '';

    joystickController.sendPlayerInfo(name, imageBase64);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

void _startSendingDirections() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        print('Sending direction: x=${currentDirection.x}, y=${currentDirection.y}');
        joystickController.onDirectionChanged(currentDirection.x, currentDirection.y);
        lastDirection = JoystickDirection(currentDirection.x, currentDirection.y);

        if (currentDirection.x == 0 && currentDirection.y == 0) {
            _timer?.cancel();
        }
    });
}

  void _updateDirection(JoystickDirection newDirection) {
    setState(() {
      currentDirection = newDirection;
    });
  }

  Color _getBackgroundColor(int playerNumber) {
    switch (playerNumber) {
      case 1:
        return Colors.white;
      case 2:
        return Colors.black;
      case 3:
        return Colors.red;
      case 4:
        return Colors.blue;
      default:
        return Colors.grey; // default background color
    }
  }

  Color _getAppBarColor(int playerNumber) {
    switch (playerNumber) {
      case 1:
        return Colors.white;
      case 2:
        return Colors.black;
      case 3:
        return Colors.red;
      case 4:
        return Colors.blue;
      default:
        return Colors.grey; // default app bar color
    }
  }

  Color _getAppBarBrightness(int playerNumber) {
    switch (playerNumber) {
      case 2:
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  Color _getAppBarTextColor(int playerNumber) {
    switch (playerNumber) {
      case 2:
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Salida'),
        content: Text('¿Quieres volver al menu de Inicio?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Get.toNamed("/"),
            child: Text('Si'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final name = arguments['name'] ?? 'Unknown';
    final imageBase64 = arguments['imageBase64'] ?? '';
    final image = arguments['image'] ?? '';

    // Forzar la orientación horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: _getAppBarColor(joystickController.playerNumber.value),
            shadowColor: _getAppBarBrightness(joystickController.playerNumber.value),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jugador ${joystickController.playerNumber.value} - $name',
                  style: TextStyle(
                    color: _getAppBarTextColor(joystickController.playerNumber.value),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: image.isNotEmpty ? FileImage(File(image)) : null,
                      child: image.isEmpty ? Icon(Icons.person, size: 20) : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Container(
            color: _getBackgroundColor(joystickController.playerNumber.value),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Joystick(
                    listener: (details) {
                      double x = details.x > 0.5 ? 1.0 : details.x < -0.5 ? -1.0 : 0.0;
                      double y = details.y > 0.5 ? 1.0 : details.y < -0.5 ? -1.0 : 0.0;

                      // Priorizar la dirección principal del movimiento
                      if (x != 0 && y != 0) {
                        if (details.x.abs() > details.y.abs()) {
                          y = 0.0;
                        } else {
                          x = 0.0;
                        }
                      }

                      JoystickDirection newDirection = JoystickDirection(x, y);

                      _updateDirection(newDirection);
                      if (_timer == null || !_timer!.isActive) {
                        _startSendingDirections();
                      }
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     ElevatedButton(
                    onPressed: () {
                      print('Sending bomb command');
                      joystickController.sendBombCommand(); // Enviar comando de bomba
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // background
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(40), // Tamaño más grande
                    ),
                    child: Image.asset(
                      'assets/bomba.png',
                      width: 100,
                      height: 100,
                    ),
                  ),

                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () => joystickController.refreshConnection(),
                        child: Text('Refresh Connection'),
                      ),
                      SizedBox(height: 5),
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
      }),
    );
  }
}
