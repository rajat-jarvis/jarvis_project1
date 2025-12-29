import 'package:drag_project/view/app_level/app_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class ViewLayout extends StatelessWidget {
  const ViewLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth >= 900
              ? EditableTextScreen()
              : AppEditableTextScreen();
        },
      ),
    );
  }
}
