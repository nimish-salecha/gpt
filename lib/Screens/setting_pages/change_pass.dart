//V2 nimish   - with reauthenticate (old password) and asking for new then 
            // - also reset with email 

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  // final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  Future<void> _resetPassword() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Create a credential using the current user's email and old password
      AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: _oldPasswordController.text);
      
      // Reauthenticate the user with the credential
      try {
        // to check old password
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Incorrect Old Password'),
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
      // await user.reauthenticateWithCredential(credential);

      // Check if new password matches confirm password
      if (_newPasswordController.text == _confirmPasswordController.text) {
        // Update the password
        await user.updatePassword(_newPasswordController.text);

        // Password updated successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password updated successfully.'),
          ),
        );
      } else {
        // Show dialog if new password does not match confirm password
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Passwords Do Not Match'),
              content: Text('New password and confirm password do not match.'),
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
      // User is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user logged in.'),
        ),
      );
    }
  } catch (e) {
    
    // Error updating password or reauthenticating
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating password: $e'),
      ),
    );
  }
}
  
 Future<void> _emailResetPassword() async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Send a password reset email to the user's email address
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);

      // Password reset email sent successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent successfully.'),
        ),
      );
    } else {
      // User is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user logged in.'),
        ),
      );
    }
  } catch (e) {
    // Error sending password reset email
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error sending password reset email: ')  //$e,
      ),
    );
  }
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField(
              //   controller: _emailController,
              //   decoration: InputDecoration(labelText: 'Email'),
              // ),
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Old Password'),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm New Password'),
              ),
              SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // Set button width to 80% of screen width
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    child: Text('Reset Password'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromARGB(255, 32, 32, 70),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // Set button width to 80% of screen width
                  child: ElevatedButton(
                    onPressed: _emailResetPassword,
                    child: Text('Send Reset Password Link'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromARGB(255, 32, 32, 70),
                      foregroundColor: Colors.white,
                    ),
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


              //  v1 - hiya  (main logic)
  // Future<void> _resetPassword() async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await user.updatePassword(_newpasswordController.text);
  //       // Password updated successfully
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Password updated successfully.'),
  //         ),
  //       );
  //     } else {
  //       // User is not logged in
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('No user logged in.'),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     // Error updating password
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error updating password: $e'),
  //       ),
  //     );
  //   }
  // }
