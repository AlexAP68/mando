import 'dart:async';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class JoystickControlador extends GetxController {
  late IOWebSocketChannel channel;
  var isConnected = false.obs;
  late Timer _timer;
  late String ipAddress;

  void connect(String ip) {
    ipAddress = ip;
    if (isValidIP(ipAddress)) {
      channel = IOWebSocketChannel.connect('ws://$ipAddress:7890');
      _startTimer();
      isConnected.value = true;
      Get.toNamed('/joystick');
    } else {
      Get.snackbar('Error', 'Invalid IP Address');
      Get.offNamed('/');
    }
  }

  bool isValidIP(String ip) {
    final RegExp ipRegExp = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return ipRegExp.hasMatch(ip);
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

  void refreshConnection() async {
    try {
      channel.sink.close();
      channel = IOWebSocketChannel.connect('ws://$ipAddress:7890');
      isConnected.value = true;
      print('Connection Status: Connected');
    } catch (e) {
      isConnected.value = false;
      print('Connection Error: $e');
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    channel.sink.close();
    super.onClose();
  }
}
