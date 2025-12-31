import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controller/controller.dart';

class UndoButton extends StatelessWidget {
  const UndoButton({
    super.key,
    required this.controller,
  });

  final EditableTextController controller;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: controller.lastDeletedItem == null
          ? null
          : controller.restoreLastDeleted,
      child: const Text(
        'Undo',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}