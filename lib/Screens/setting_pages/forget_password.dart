// Add a feature in below code so that if corrdct email format , but not registered with the app so Show a AlertDialog with text "Email not registered"
//Forget Password page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Password Reset Email Sent'),
              content: Text('Please check your email to reset your password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        print('Error sending password reset email: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to send password reset email. Please try again with correct email.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter correct email address.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 32, 70),
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mail your e-mail ♡',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 254, 99, 61),
                  fontWeight: FontWeight.bold, // Make text bold
                  fontFamily: 'YourFontFamily', // Change font style (replace 'YourFontFamily' with your desired font family)
                ),
              ),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Color.fromARGB(255, 254, 99, 61)),
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                    color: Color.fromARGB(255, 254, 99, 61),
                  ),
                  errorStyle: TextStyle(color: Color.fromARGB(255, 254, 99, 61)),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 254, 99, 61)),
                  hintStyle: TextStyle(color: Color.fromARGB(255, 254, 99, 61)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 254, 99, 61)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 254, 99, 61)),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 254, 99, 61)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () => _resetPassword(context),
              //   child: Text('Send Email'),
              // ),
              ElevatedButton(
                onPressed: () => _resetPassword(context),
                child: Text(
                  'Send Email',
                  style: TextStyle(fontSize: 18), // Increase font size
                ),                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 254, 99, 61),
                  foregroundColor: Color.fromARGB(255, 32, 32, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Set radius to 0
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
