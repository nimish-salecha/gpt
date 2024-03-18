// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gpt/screens/header.dart';

void main() {
  runApp(Home());
}

// ignore: use_key_in_widget_constructors
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 0.15), // Add extra height for the padding
        child: Container(
          child: Padding( // This line was added
            padding: const EdgeInsets.only(top: 0.15), // This line was added
            child: Header(),
          ),
        ),
      ),
        
        body: Text("jdwnekad"),        
          
      ),
    );
  }
}