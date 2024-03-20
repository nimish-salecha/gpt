//Search debates and add filter and sort

import 'package:flutter/material.dart';
void main() {
  runApp(Search());
}

// ignore: use_key_in_widget_constructors
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[500],
          title: const Text('Search'),
        ),
      
      ),
    );
  }
}
