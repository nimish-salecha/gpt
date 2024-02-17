// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9DBC98),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
// Logo
              Image.asset(
                '../../assets/logo.png', 
                height: 80,
                width: 80,
              ),
              Container(
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.only(top:10),
                decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0), 
                      border: Border.all(
                          color: Color.fromARGB(255, 42, 42, 42), // Set your desired underline color
                          width: 2.0, // Set the underline thickness
                        ),
                      ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                  
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                // Email TextField
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Password TextField
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
// Forget Password Link
                Container(
                  // padding: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.blue, // Set your desired underline color
                          width: 2.0, // Set the underline thickness
                        ),
                      ),
                    ),
                  child: GestureDetector(
                    onTap: () {
                    // Implement forget password logic here
                    },
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    // Implement sign-in logic here
                  },
                  child: Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
                SizedBox(height: 16),
                // Sign In with Google Button
                OutlinedButton(
                  onPressed: () {
                    // Implement sign-in with Google logic here
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('../../assets/google_logo.png', height: 20, width: 20),
                      SizedBox(width: 8),
                      Text('Sign In with Google'),
                    ],
                  ),
                ),
                ],
                ),
              ),                    //border of feilds
              SizedBox(height: 16),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
        
                Text(
                        "Don't have account?  ",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
              
              GestureDetector(
                    onTap: () {
                     Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "Create One",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  ]
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
