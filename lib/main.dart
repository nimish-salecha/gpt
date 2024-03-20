//yt 

// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/RegistrationScreen.dart';
import 'package:gpt/screens/home.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/dashboard': (context) => Home(),
      },
    ));

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  // final AuthenticationService _auth = AuthenticationService();

  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _emailContoller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password cannot be empty';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white)),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextButton(
                        child: Text('Not registerd? Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => RegistrationScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: Text('Login'),
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                // signInUser();
                              }
                            },
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//   void signInUser() async {
//     dynamic authResult =
//         await _auth.loginUser(_emailContoller.text, _passwordController.text);
//     if (authResult == null) {
//       print('Sign in error. could not be able to login');
//     } else {
//       _emailContoller.clear();
//       _passwordController.clear();
//       Navigator.pushNamed(context, '/dashboard');
//     }
//   }
}


// ignore_for_file: prefer_const_constructors, unused_import
/*
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

void main() => runApp(MyApp());

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   // addUser("sher", "s@gmail.com");
//   runApp(MyApp());
// }

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
*/

//-------firebase cde- hiyu------
/*
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
*/