import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class JoystickControlador extends GetxController {
  late IOWebSocketChannel channel;
  var isConnected = false.obs;
  var playerNumber = 0.obs;
  late String ipAddress;
  String? deviceIP;
  Timer? _reconnectTimer;

  JoystickControlador() {
    _getDeviceIP();
  }

  Future<void> _getDeviceIP() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          deviceIP = addr.address;
          print('Device IP: $deviceIP');
          return;
        }
      }
    }
  }

  void startReconnectTimer() {
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!isConnected.value) {
        print('Attempting to reconnect...');
        connect(ipAddress);
      }
    });
  }

  void connect(String ipAddress) {
    this.ipAddress = ipAddress;
    try {
      channel = IOWebSocketChannel.connect('ws://$ipAddress:7890');
      channel.stream.listen((message) {
        _handleMessage(message);
      },
      onDone: () {
        isConnected.value = false;
        print('Connection closed.');
      },
      onError: (error) {
        isConnected.value = false;
        print('Connection error: $error');
      });
      isConnected.value = true;
      print('Connected to $ipAddress');
      if (_reconnectTimer == null) {
        startReconnectTimer();
      }
      if (deviceIP != null) {
        channel.sink.add('register:$deviceIP');
      }
    } catch (e) {
      isConnected.value = false;
      print('Failed to connect: $e');
    }
  }

  void _handleMessage(String message) {
    if (message.startsWith('playerNumber:')) {
      int number = int.parse(message.split(':')[1]);
      playerNumber.value = number;
      print('Assigned player number: $number');
    } else if (message == 'error:too_many_players') {
      Get.snackbar('Error', 'Too many players connected');
      channel.sink.close();
      isConnected.value = false;
    } else if (message == 'navigate_home') {
      // Navegar de vuelta a la pantalla principal
      Get.offAllNamed('/');
    }
  }

  void sendPlayerInfo(String name, String imageBase64) {
    if (isConnected.value && playerNumber.value > 0) {
      channel.sink.add('name:$name');
      channel.sink.add('image:$imageBase64');
    } else {
      print('WebSocket not connected or player number not assigned');
    }
  }

  void onDirectionChanged(double x, double y) {
    if (isConnected.value && playerNumber.value > 0) {
      print('Sending to WebSocket: $x,$y');
      channel.sink.add('$playerNumber:$x,$y');
    } else {
      print('WebSocket not connected or player number not assigned');
    }
  }

  void sendBombCommand() {
    if (isConnected.value && playerNumber.value > 0) {
      print('Sending bomb command to WebSocket');
      channel.sink.add('$playerNumber:bomb');
    } else {
      print('WebSocket not connected or player number not assigned');
    }
  }

  void refreshConnection() {
    if (isConnected.value) {
      channel.sink.close();
      connect(ipAddress);
      print('Connection refreshed');
    } else {
      print('Cannot refresh, not connected');
    }
  }

  @override
  void onClose() {
    _reconnectTimer?.cancel();
    channel.sink.close();
    super.onClose();
  }
}
