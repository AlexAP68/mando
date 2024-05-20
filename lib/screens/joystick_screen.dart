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
          title: Obx(() => Text('Unity Flutter Controller - Player ${joystickController.playerNumber.value}')),
        ),
        body: Center(
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
                    child: Text('Place Bomb'),
                  ),
                  SizedBox(height: 20),
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
