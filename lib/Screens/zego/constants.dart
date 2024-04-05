// Dart imports:
// import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// final String localUserID = math.Random().nextInt(10000).toString();
late String localUserID;
late String uname;


    Future<void>  fetchUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
            localUserID = user.uid;
        if (userData.exists) {
          // setState(() {
            uname = userData['username'] ?? '';
          // });
          print('uname= $uname  --uid= $localUserID');
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }
