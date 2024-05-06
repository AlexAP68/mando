import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:web_socket_channel/io.dart';

class JoystickScreen extends StatefulWidget {
  final String ipAddress;

  JoystickScreen({required this.ipAddress});

  @override
  _JoystickScreenState createState() => _JoystickScreenState();
}

class _JoystickScreenState extends State<JoystickScreen> {
  late IOWebSocketChannel channel;
  bool isConnected = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://${widget.ipAddress}:7890');
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    channel.sink.close();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      refreshConnection();
    });
  }

  void onDirectionChanged(double x, double y) {
    channel.sink.add('$x,$y');
    print('Sent Data: $x, $y');
  }

  void refreshConnection() {
    // Close the existing channel and connect again
    channel.sink.close();
    setState(() {
      channel = IOWebSocketChannel.connect('ws://${widget.ipAddress}:7890');
      isConnected = true;
    });
    print('Connection Status: Connected');
    print('ip'+ widget.ipAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unity Flutter Controller - Joystick'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Joystick(
              listener: (details) => onDirectionChanged(details.x, details.y),
            ),
             SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => refreshConnection(),
              child: Text('Refresh Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
