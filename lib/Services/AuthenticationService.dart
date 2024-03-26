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
