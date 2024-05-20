import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mando/controller/qrcontroller.dart';



class QRScreen extends StatelessWidget {
  final QRController controller = Get.put(QRController());

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
              onPressed: controller.scanQR,
              child: Text('Scan QR Code to Connect'),
            ),
          ],
        ),
      ),
    );
  }
}
