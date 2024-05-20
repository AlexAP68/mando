import 'dart:async';
import 'package:get/get.dart';
import 'package:mando/utility/NetworkUtils.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/services.dart'; // Import for device orientation control

class JoystickController extends GetxController {
  final String ipAddress;
  late IOWebSocketChannel channel;
  RxBool isConnected = false.obs;
  late Timer _timer;

  JoystickController(this.ipAddress) {
    channel = IOWebSocketChannel.connect('ws://$ipAddress:7890');
    _startTimer();
    // Set device orientation to landscape mode when controller is initialized
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void onClose() {
    // Reset device orientation to portrait mode when controller is being disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _timer.cancel();
    channel.sink.close();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      refreshConnection();
    });
  }

Future<void> onDirectionChanged(double x, double y) async {
  // Assuming you have a method to get the device IP
 String ip = await NetworkUtils().getDeviceIP();
 print('IP: $ip');

  channel.sink.add("$ip,$x,$y");
}


  void refreshConnection() {
    channel.sink.close();
    channel = IOWebSocketChannel.connect('ws://$ipAddress:7890');
    isConnected.value = true;
  }

  RxString connectionStatus = 'Disconnected'.obs;

  
}
