import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PlayerNameScreen extends StatelessWidget {
  PlayerNameScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    final Map<String, dynamic> arguments = Get.arguments;
    final qrResult = arguments['qrResult'];

    handleSubmit() async {
      if (!_formKey.currentState!.validate()) return;
      final name = _nameController.value.text;

      // Navegar a la pantalla de selección de imagen
      Get.toNamed('/playerAvatar', arguments: {"qrResult": qrResult, "name": name});
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Jugador, introduce tu nombre:',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 400,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Se requiere el nombre';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: 'Name',
                          hintText: 'Name',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: OutlinedButton(
              onPressed: () {
                handleSubmit();
              },
              child: const Text('Siguiente'),
            ),
          )
        ],
      ),
    );
  }
}
