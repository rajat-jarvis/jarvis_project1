import 'package:flutter/material.dart';
import '../../controller/app_controller/app_controller.dart';

class AddTextButton extends StatelessWidget {
  const AddTextButton({
    super.key,
    required this.appController,
  });

  final AppController appController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () =>
          appController.showDuplicateTextPopup(),
      icon: const Icon(Icons.add,
      color: Colors.black,),
      label: const Text('Duplicate',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),),
    );
  }
}