import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/setting_pages/forget_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _controllerEmailOrUsername = TextEditingController();

Future<void> signInWithEmailAndPassword() async {
  try {
    // Check if the input contains '@', assuming it's an email
    if (_controllerEmailOrUsername.text.contains('@')) {
      // If it's an email, attempt to log in using email
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmailOrUsername.text,
        password: _controllerPassword.text,
      );
    } else {
      // If it's not an email, assume it's a username
      // Fetch user's email using username from database
      String? email = await getEmailFromUsername(_controllerEmailOrUsername.text);
      print(email);
      if (email != null) {
        // If email found, log in using retrieved email
        await Auth().signInWithEmailAndPassword(
          email: email,
          password: _controllerPassword.text,
        );
      } else {
        // If username not found, show error message
        setState(() {
          errorMessage = 'Username not found';
        });
      }
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message;
    });
  }
}
            //problem with this function is that it is still
            //unable to login with username
  Future<String?> getEmailFromUsername(String username) async {
    try {
      // Query Firestore to get user details based on username
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    // Check if any user is found with the given username
    if (querySnapshot.docs.isNotEmpty) {
      String uid = querySnapshot.docs[0].id;
      // Retrieve current user from Firebase Authentication
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      print("wda");
      print(firebaseUser);
      // Check if the current user matches the UID from Firestore
      if (firebaseUser != null && firebaseUser.uid == uid) {
        // Return the email associated with the user
        return firebaseUser.email;
      }
    }
    // If no user found or UID does not match, return null
    return null;
/*      // Query Firestore to get user details based on username
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      // Check if any user is found with the given username
      if (querySnapshot.docs.isNotEmpty) {
      // if (len>0) {
        // If found, return the email
print(querySnapshot.docs[0].data());
print(querySnapshot.docs[0].data()['email']);
        return querySnapshot.docs[0].data()['email'];
      } else {
        // If no user found, return null 
        return null;
      }*/
    } catch (e) {
      // Handle any errors
      print('Error fetching user by username: $e');
      return null;
    }
  }
  


  
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
        username: _usernameController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Text(
          isLogin ? 'Welcome Back' : 'Sign up',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text(isLogin ? 'Enter your credentials to login' : 'Create your account'),
      ],
    );
  }
  Widget _inputField(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
       if (isLogin) ...[  //only front end
      TextField(
        controller: _controllerEmailOrUsername,
        decoration: InputDecoration(
          hintText: 'Email or Uname',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.purple.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(Icons.email),
        ),
      ),
      SizedBox(height: 10),
      ],
      if (!isLogin) ...[  //only front end
      TextField(
        controller: _controllerEmail,
        decoration: InputDecoration(
          hintText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.purple.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(Icons.email),
        ),
      ),
      SizedBox(height: 10),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 10),
      ],
        TextField(
        controller: _controllerPassword,
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.purple.withOpacity(0.1),
          filled: true,
          prefixIcon: Icon(Icons.password),
        ),
        obscureText: true,
      ),
      SizedBox(height: 10),
      // if (!isLogin) ...[      //only front end
      //   TextField(
      //     decoration: InputDecoration(
      //       hintText: 'Confirm Password',
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(18),
      //         borderSide: BorderSide.none,
      //       ),
      //       fillColor: Colors.purple.withOpacity(0.1),
      //       filled: true,
      //       prefixIcon: Icon(Icons.password),
      //     ),
      //     obscureText: true,
      //   ),
      //   SizedBox(height: 10),
      // ],
      
      ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.black87,
        ),
        child: Text(isLogin ? 'Login' : 'Sign up', style: TextStyle(fontSize: 20)),
      ),
      // "Forgot Password?" button
      TextButton(
        onPressed: () {
          Get.to(() => ForgotPassword());
        },
        child: Text("Forgot Password?"),
      ),
    ],
  );
}

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Hmm? $errorMessage');
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
              //clearing all textbox when switch between login or register
          // _controllerEmailOrUsername.clear();
          _controllerPassword.clear();
          _controllerEmail.clear();
          _usernameController.clear();
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NexoDeb8')),    //can add app logo, applogo
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _header(context),
              _inputField(context),
              _errorMessage(),
              _loginOrRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
