import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountPage extends StatefulWidget {
  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8, // Set button width to 80% of screen width
                  child: ElevatedButton(
                    onPressed: () => _deleteAccount(context),
                    child: Text('Delete Account'),
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
    );
  }

  void _deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser?.delete();
      // Account deleted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account deleted successfully.'),
        ),
      );
      // Navigate back to the login and registration page
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      // Error deleting account
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: $e'),
        ),
      );
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DeleteAccountPage extends StatefulWidget {
//   @override
//   _DeleteAccountPageState createState() => _DeleteAccountPageState();
// }

// class _DeleteAccountPageState extends State<DeleteAccountPage> {
//   final _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Delete Account'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Are you sure you want to delete your account?',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _deleteAccount,
//               child: Text('Delete Account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _deleteAccount() async {
//     try {
//       await _auth.currentUser?.delete();
//       // Account deleted successfully
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Account deleted successfully.'),
//         ),
        
//       );
//     } catch (e) {
//       // Error deleting account
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error deleting account: $e'),
//         ),
//       );
//     }
//   }
// }
