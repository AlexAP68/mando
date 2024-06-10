import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:mando/controller/joystickcontrolador.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../utilitis/database_service.dart';

class QRScreen extends StatelessWidget {
  final JoystickControlador joystickController = Get.put(JoystickControlador());
  final DatabaseService databaseService = DatabaseService();

 Future<void> scanQR() async {
  String qrResult = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", "Cancel", true, ScanMode.QR);

  // Verificar que el QR contenga una IP válida
  if (qrResult != '-1' && _isValidIPAddress(qrResult)) {
    joystickController.connect(qrResult);
    joystickController.startReconnectTimer();
    if (joystickController.isConnected.value) {
      // Obtener la IP del dispositivo
      String ipAddress = await getDeviceIpAddress();
      print(qrResult);
      print(ipAddress);
      // Guardar QR y IP en la base de datos
      await databaseService.insertConnectionInfo(qrResult, ipAddress);

      Get.toNamed('/playerName', arguments: {"qrResult": qrResult});
    } else {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  } else {
    Get.snackbar('Error', 'Invalid QR code');
  }
}

bool _isValidIPAddress(String ip) {
  final regex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
  return regex.hasMatch(ip);
}

  Future<String> getDeviceIpAddress() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Utiliza una propiedad que represente la IP o un identificador único
  }

  @override
  Widget build(BuildContext context) {
    // Forzar la orientación horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    double width = MediaQuery.of(context).size.width;

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
        
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inter Mando',
                  style: TextStyle(fontSize: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: const AssetImage('assets/movil.png'),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: width * 0.35,
                      height: 70,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 0, 194, 243)),
                        ),
                        onPressed: () => scanQR(),
                        child: const Text(
                          'Comenzar',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}