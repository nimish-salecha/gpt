import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DisableAccountPage extends StatefulWidget {
  @override
  _DisableAccountPageState createState() => _DisableAccountPageState();
}

class _DisableAccountPageState extends State<DisableAccountPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disable Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to disable your account?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _disableAccount,
              child: Text('Disable Account'),
            ),
          ],
        ),
      ),
    );
  }

  void _disableAccount() async {
    try {
      await _auth.currentUser?.delete();
      // Account disabled successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account disabled successfully.'),
        ),
      );
    } catch (e) {
      // Error disabling account
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error disabling account: $e'),
        ),
      );
    }
  }
}
