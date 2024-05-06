import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final channel = IOWebSocketChannel.connect('ws://192.168.1.214:7890');

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unity Flutter Controller',
      home: JoystickPage(channel: channel),
    );
  }
}

class JoystickPage extends StatefulWidget {
  IOWebSocketChannel channel;

  JoystickPage({Key? key, required this.channel}) : super(key: key);

  @override
  _JoystickPageState createState() => _JoystickPageState();
}

class _JoystickPageState extends State<JoystickPage> {
  bool isConnected = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.channel.sink.close();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      refreshConnection();
    });
  }

  void onDirectionChanged(double x, double y) {
    widget.channel.sink.add('$x,$y');
    print('Sent Data: $x, $y');
  }

  void refreshConnection() {
    // Close the existing channel and connect again
    widget.channel.sink.close();
    setState(() {
      widget.channel = IOWebSocketChannel.connect('ws://192.168.1.214:7890');
      isConnected = true;
    });
    print('Connection Status: Connected');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unity Flutter Controller'),
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
