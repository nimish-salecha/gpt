//with unique uname feature
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    
    // Check if the provided username already exists
    final querySnapshot = await usersRef.where('username', isEqualTo: username).get();
    if (querySnapshot.docs.isNotEmpty) {
      throw FirebaseAuthException(message: 'Username is already taken', code: '101');
    }
    
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // After creating user, update user profile to include username
      await _firebaseAuth.currentUser!.updateDisplayName(username);

      // Store the username in Firestore
      await usersRef.doc(_firebaseAuth.currentUser!.uid).set({'username': username});
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
////////////////////////////////////////////////////////////////////////////////////
 /* Future<String?> getEmailFromUsername(String username) async {
    try {
      // Query Firestore to get user details based on username
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      // Check if any user is found with the given username
      if (querySnapshot.docs.isNotEmpty) {
        // If found, return the email
        return querySnapshot.docs[0].data()['email'];
      } else {
        // If no user found, return null
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching user by username: $e');
      return null;
    }
  }

//   Future<User?> getUserByEmail(String email) async {
//     try {
//       // Query Firestore to get user details based on email
//       QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();

//       // Check if any user is found with the given email
//       if (querySnapshot.docs.isNotEmpty) {
//         // If found, return the user
//         return FirebaseAuth.instance.currentUser!;
//         // return User(uid: querySnapshot.docs[0].id, email: querySnapshot.docs[0].data()['email']);
//       } else {
//         // If no user found, return null
//         return null;
//       }
//     } catch (e) {
//       // Handle any errors
//       print('Error fetching user by email: $e');
//       return null;
//     }
//   }   */
}



//working for email and password(but not have feature of uname)
/*
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password, 
    required String uname, 
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
*/


//dont know   -- old
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:gpt/DatabaseManager/DatabaseManager.dart';

// class AuthenticationService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // registration with email and password

//   Future<User?> createNewUser(String name, String email, String password) async {
//     try {
//       UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       User? user = result.user;
//       // await DatabaseManager().createUserData(name, 'Male', 100, user.uid);
//       return user;
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

// }

// // class AuthenticationService {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // // registration with email and password

// //   Future createNewUser(String name, String email, String password) async {
// //     try {
// //       AuthResult result = await _auth.createUserWithEmailAndPassword(
// //           email: email, password: password);
// //       FirebaseUser user = result.user;
// //       await DatabaseManager().createUserData(name, 'Male', 100, user.uid);
// //       return user;
// //     } catch (e) {
// //       print(e.toString());
// //     }
// //   }

// // // sign with email and password

// //   Future loginUser(String email, String password) async {
// //     try {
// //       AuthResult result = await _auth.signInWithEmailAndPassword(
// //           email: email, password: password);
// //       return result.user;
// //     } catch (e) {
// //       print(e.toString());
// //     }
// //   }

// // // signout

// //   Future signOut() async {
// //     try {
// //       return _auth.signOut();
// //     } catch (error) {
// //       print(error.toString());
// //       return null;
// //     }
// //   }
// // }
