// ignore_for_file: sort_child_properties_last

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gpt/firebase_options.dart';
import 'package:gpt/Services/AuthenticationService.dart';
// ignore: unused_import
import 'package:gpt/screens/dashboard.dart';
import 'package:gpt/screens/home.dart';
import 'package:gpt/screens/login_register_page.dart';
import 'package:gpt/screens/notification.dart';
import 'package:flutter/foundation.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAvE5vHVjdjeWrmPX5GCmZ4Z6yUosK9D_w",
      authDomain: "gptt-6ae89.firebaseapp.com",
      databaseURL:
          "https://gptt-6ae89-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "gptt-6ae89",
      storageBucket: "gptt-6ae89.appspot.com",
      messagingSenderId: "179804533123",
      appId: "1:179804533123:web:8fbbe5390230ad98c4c6b6",
      measurementId: "G-9VYGYRXL6E",
    ));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//calling notification function in every 
  runApp(const MyApp());
  Timer.periodic(Duration(minutes: 5), (Timer t) => sendEmailNotification());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NexoDeb8',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //used for first function(page)
      home: WidgetTree(),
      routes: {
      //   '/signin': (context) => SignInPage(),
      //   '/signup': (context) => SignUpPage(),
      },
    );
  }
}

// used to navigator after login and registration
class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {

//code for email notification till line 70-71
  // late Timer _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   // Call the function every 1 minute
  //   _timer = Timer.periodic(Duration(minutes: 1), (timer) {
  //     checkDebatesToSendReminder();
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer.cancel(); // Cancel the timer to prevent memory leaks
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return const LoginPage();
          }
        });
  }
}

//code when main.dart and widget_tree.dart wer not merged
/*
//yt try2--hiya

// ignore_for_file: sort_child_properties_last

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gpt/Screens/dashboard.dart';
import 'package:gpt/Screens/feedmain.dart';
import 'package:gpt/firebase_options.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/RegistrationScreen.dart';
import 'package:gpt/screens/header2.dart';
import 'package:gpt/screens/home.dart';
import 'package:gpt/screens/setting_page.dart';

import 'package:gpt/widgets/widget_tree.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPT App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),    //used for first function(page)
      home: WidgetTree(),
      // routes: {
      //   '/signin': (context) => SignInPage(),
      //   '/signup': (context) => SignUpPage(),
      // },
    );
  }
}
*/
