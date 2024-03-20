// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:gpt/screens/dashboard.dart';
import 'package:gpt/screens/home.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/signin_page.dart';
import 'package:gpt/screens/signup_page.dart';
import 'screens/header.dart';
// import 'screens/home.dart';

// void main() => runApp(MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // addUser("sher", "s@gmail.com");
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPT App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),    //used for first function(page)
      home: Home(),
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

//-------firebase cde- hiyu------
Future<void> addUser(String name, String email) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users
      .add({
        'name': name,
        'email': email,
      })
      .then((value) => print("User added successfully!"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<void> fetchUsers() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users.get().then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {
      print('${doc.id} => ${doc.data()}');
    });
  }).catchError((error) => print("Failed to fetch users: $error"));
}

//updating data:

Future<void> updateUserEmail(String userId, String newEmail) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users
      .doc(userId)
      .update({'email': newEmail})
      .then((value) => print("User email updated successfully!"))
      .catchError((error) => print("Failed to update user email: $error"));
}

Future<void> deleteUser(String userId) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users
      .doc(userId)
      .delete()
      .then((value) => print("User deleted successfully!"))
      .catchError((error) => print("Failed to delete user: $error"));
}

Stream<QuerySnapshot> usersStream =
    FirebaseFirestore.instance.collection('users').snapshots();

// usersStream.listen((QuerySnapshot snapshot) {
//   snapshot.docs.forEach((doc) {
//     print('${doc.id} => ${doc.data()}');
//   });
// });

Future<void> fetchUsersAboveAge(int minAge) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return users
      .where('age', isGreaterThan: minAge)
      .get()
      .then((QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {
      print('${doc.id} => ${doc.data()}');
    });
  }).catchError((error) => print("Failed to fetch users: $error"));
}
//-----------------

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
