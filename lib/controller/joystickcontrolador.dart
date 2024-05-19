import 'dart:async';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class JoystickControlador extends GetxController {
  late IOWebSocketChannel channel;
  var isConnected = false.obs;
  late String ipAddress;
  Timer? _reconnectTimer;

  void startReconnectTimer() {
    // Intentar reconectar cada 5 segundos si no está conectado
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
      isConnected.value = true;
      print('Connected to $ipAddress'); // Añadir log
      // Escuchar los eventos de cierre de la conexión
      channel.stream.listen((message) {},
          onDone: () {
            isConnected.value = false;
            print('Connection closed.'); // Añadir log
          },
          onError: (error) {
            isConnected.value = false;
            print('Connection error: $error'); // Añadir log
          });
      // Iniciar el temporizador de reconexión después de la conexión inicial
      if (_reconnectTimer == null) {
        startReconnectTimer();
      }
    } catch (e) {
      isConnected.value = false;
      print('Failed to connect: $e'); // Añadir log
    }
  }

  void onDirectionChanged(double x, double y) {
    if (isConnected.value) {
      print('Sending to WebSocket: $x, $y'); // Añadir log
      channel.sink.add('$x,$y');
    } else {
      print('WebSocket not connected'); // Añadir log
    }
  }

  void sendBombCommand() {
    if (isConnected.value) {
      print('Sending bomb command to WebSocket'); // Añadir log
      channel.sink.add('bomb');
    } else {
      print('WebSocket not connected'); // Añadir log
    }
  }

  void refreshConnection() {
    if (isConnected.value) {
      channel.sink.close();
      connect(ipAddress);
      print('Connection refreshed'); // Añadir log
    } else {
      print('Cannot refresh, not connected'); // Añadir log
    }
  }

  @override
  void onClose() {
    _reconnectTimer?.cancel();
    channel.sink.close();
    super.onClose();
  }
}
