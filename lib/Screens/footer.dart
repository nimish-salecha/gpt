import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue,
      child: Text(
        '© 2023 My App. All rights reserved.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
