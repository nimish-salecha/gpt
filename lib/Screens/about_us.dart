// ABOUT US

import 'package:flutter/material.dart';
void main() {
  runApp(AboutUS());
}

// ignore: use_key_in_widget_constructors
class AboutUS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[500],
          title: const Text('About US'),
        ),

        body: Column(),
      ),
    );
  }
}