// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/homepage.dart';
import 'package:gpt/screens/signin_page.dart';
import 'package:gpt/screens/signup_page.dart';
// import 'screens/header.dart';
// import 'screens/home.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPT App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

// // ignore: use_key_in_widget_constructors
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('GPT App'),
//       //   actions: [
//       //     TextButton(
//       //       onPressed: () {
//       //         Navigator.pushNamed(context, '/signin');
//       //       },
//       //       child: Text(
//       //         'Sign In',
//       //         style: TextStyle(color: Colors.black),
//       //       ),
//       //     ),
//       //     TextButton(
//       //       onPressed: () {
//       //         Navigator.pushNamed(context, '/signup');
//       //       },
//       //       child: Text(
//       //         'Sign Up',
//       //         style: TextStyle(color: Colors.black),
//       //       ),
//       //     )
//       //   ],
//       // ),
//       body: Column(
//         children: [
//           Header(),
//           // Home(),
//           // Your page content goes here
//            Text('Welcome to my app!'),
//           // Footer(),
//         ],
//       ),
//       // Center(
//       //   child: Text('Welcome to GPT App!'),
//       // ),
//     );
//   }
// }
