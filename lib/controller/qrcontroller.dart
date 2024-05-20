// Archivo: qr_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mando/main.dart';

class QRController extends GetxController {
  Future<void> scanQR() async {
    String qrResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    if (qrResult != '-1' && _isValidIP(qrResult)) {
      Get.offAllNamed(Routes.joystickScreen, arguments: qrResult);
    } else {
      // Muestra un snackbar con un mensaje de error si el QR no contiene una IP válida
      Get.snackbar(
        "Error",  // Título del snackbar
        "QR no válido. Asegúrate de escanear un código QR que contenga una dirección IP válida.",  // Mensaje del snackbar
        snackPosition: SnackPosition.BOTTOM,  // Posición del snackbar
        backgroundColor: Colors.red,  // Color de fondo del snackbar
        colorText: Colors.white,  // Color del texto del snackbar
        duration: Duration(seconds: 3)  // Duración que el snackbar permanecerá visible
      );
    }
  }

  // Función para validar si una cadena es una dirección IP válida
  bool _isValidIP(String ip) {
    final regexIP = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    return regexIP.hasMatch(ip);
  }
}
