import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:mando/controller/joystickcontrolador.dart';

class QRScreen extends StatelessWidget {
  final JoystickControlador joystickController = Get.put(JoystickControlador());

  Future<void> scanQR() async {
    String qrResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    if (qrResult != '-1') {
      joystickController.connect(qrResult);
    } else {
      Get.snackbar('Error', 'Invalid QR Code');
      Get.offNamed('/');
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
