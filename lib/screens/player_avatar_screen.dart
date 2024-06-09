import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mando/controller/joystickcontrolador.dart';
import 'package:mando/utilitis/database_service.dart';



class PlayerAvatarScreen extends StatefulWidget {
  @override
  _PlayerAvatarScreenState createState() => _PlayerAvatarScreenState();
}

class _PlayerAvatarScreenState extends State<PlayerAvatarScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final JoystickControlador joystickController = Get.find();
  final DatabaseService databaseService = DatabaseService();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  String _convertImageToBase64(File image) {
    final bytes = image.readAsBytesSync();
    return base64Encode(bytes);
  }

  void _showConfirmationDialog() async {
    final Map<String, dynamic> arguments = Get.arguments;
    final qrResult = arguments['qrResult'];
    final name = arguments['name'];

    if (_image == null) {
      Get.snackbar('Error', 'Please select an image');
      return;
    }

    final imageBase64 = _convertImageToBase64(_image!);

    bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar seleccion'),
        content: Text('¿ Te parece bien la configuracion ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Volver a elegir'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Si'),
          ),
        ],
      ),
    );

    if (result == true) {
      // Guardar nombre y path de la imagen en la base de datos
      await databaseService.insertConnectionInfo(qrResult, joystickController.deviceIP!, name: name, imagePath: _image!.path);

      // Navegar a la pantalla del joystick
      Get.toNamed('/joystick', arguments: {
        "qrResult": qrResult,
        "name": name,
        "imageBase64": imageBase64,
        "image": _image!.path,
      });
    } else {
      // Navegar de vuelta a player_name_screen
      Get.toNamed('/playerName', arguments: {"qrResult": qrResult});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleciona Avatar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(_image!),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleciona Imagen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showConfirmationDialog,
              child: Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
