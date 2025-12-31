import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controller/controller.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.index,
    required this.controller,
  });

  final int? index;
  final EditableTextController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
      ),
      onPressed: index == null
          ? null
          : controller.deleteSelected,
      child: const Text(
        'Delete ',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}