import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:mando/controller/joystickcontrolador.dart';
import 'package:mando/screens/joystick_screen.dart';

class QRScreen extends StatelessWidget {
  final JoystickControlador joystickController = Get.put(JoystickControlador());

  Future<void> scanQR() async {
    String qrResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);

    if (qrResult != '-1') {
      try {
        joystickController.connect(qrResult);
        Get.to(() => JoystickScreen());
      } catch (e) {
        Get.snackbar("Error", "No se pudo conectar. Verifica la IP y vuelve a intentarlo.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Error", "Escaneo cancelado",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unity Flutter Controller - QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => scanQR(),
              child: Text('Scan QR Code to Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
