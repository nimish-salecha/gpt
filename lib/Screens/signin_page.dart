// // ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gpt/Screens/homepage.dart';

// class SignInPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF9DBC98),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
// // Logo
//               Image.asset(
//                 'assets/logo.png',
//                 height: 80,
//                 width: 80,
//               ),
//               Container(
//                 padding: EdgeInsets.all(25),
//                 margin: EdgeInsets.only(top: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.0),
//                   border: Border.all(
//                     color: Color.fromARGB(
//                         255, 42, 42, 42), // Set your desired underline color
//                     width: 2.0, // Set the underline thickness
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 16),

//                     Text(
//                       'Sign In',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     // Email TextField
//                     SizedBox(
//                       width: 300,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Email',
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     // Password TextField
//                     SizedBox(
//                       width: 300,
//                       child: TextField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: 'Password',
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 12),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
// // Forget Password Link
//                     Container(
//                       // padding: EdgeInsets.symmetric(vertical: 10.0),
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom: BorderSide(
//                             color:
//                                 Colors.blue, // Set your desired underline color
//                             width: 2.0, // Set the underline thickness
//                           ),
//                         ),
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           // Implement forget password logic here
//                         },
//                         child: Text(
//                           'Forget Password?',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     // Sign In Button
//                     ElevatedButton(
//                       onPressed: () {
//                         // Implement sign-in logic here
//                       },
//                       child: Text('Sign In'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     // Sign In with Google Button
//                     OutlinedButton(
//                       onPressed: () {
//                         // Implement sign-in with Google logic here
//                       },
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         side: BorderSide(color: Colors.white),
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Image.asset('assets/google_logo.png',
//                               height: 20, width: 20),
//                           SizedBox(width: 8),
//                           Text('Sign In with Google'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ), //border of feilds
//               SizedBox(height: 16),
//               Container(
//                 child: Row(mainAxisSize: MainAxisSize.min, children: [
//                   Text(
//                     "Don't have account?  ",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, '/signup');
//                     },
//                     child: Text(
//                       "Create One",
//                       style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
final GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9DBC98),
      body: SingleChildScrollView(
        // Wrap your Column with SingleChildScrollView
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 80,
                  width: 80,
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Color.fromARGB(255, 42, 42, 42),
                      width: 2.0,
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
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
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Implement sign-in logic here
                        },
                        child: Text('Sign In'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 16),
                      // OutlinedButton(
                      //   onPressed: () {
                      //     // Implement sign-in with Google logic here
                      //   },
                      //   style: OutlinedButton.styleFrom(
                      //     foregroundColor: Colors.white,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     side: BorderSide(color: Colors.white),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 12),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       Image.asset('assets/google_logo.png',
                      //           height: 20, width: 20),
                      //       SizedBox(width: 8),
                      //       Text('Sign In with Google'),
                      //     ],
                      //   ),
                      // ),

                      // ElevatedButton(
                      //   onPressed: _signInWithGoogle,
                      //   child: Text('Sign In with Google'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.blue,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 12),
                      //   ),
                      // ),

                      // ElevatedButton(
                      //   onPressed: () => _signInWithGoogle(context),
                      //   child: Text('Sign In with Google'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor:
                      //         const Color.fromARGB(255, 236, 237, 238),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 12),
                      //   ),
                      // ),
                      ElevatedButton(
                        onPressed: () =>
                            _signInWithGoogle(context), // Pass context here
                        child: Text('Sign In with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don't have an account?  ",
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
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// void _signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser != null) {
//       // Successful sign-in, proceed with your app logic
//       print('Signed in as: ${googleUser.displayName}');
//     } else {
//       // Sign-in process cancelled by the user
//       print('Sign-in process cancelled');
//     }
//   } catch (error) {
//     // Handle sign-in errors
//     print('Error signing in with Google: $error');
//   }
// }
// void _signInWithGoogle(BuildContext context) async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser != null) {
//       // Successful sign-in, navigate to HomePage
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePage(),
//         ),
//       );
//     } else {
//       // Sign-in process cancelled by the user
//       print('Sign-in process cancelled');
//     }
//   } catch (error) {
//     // Handle sign-in errors
//     print('Error signing in with Google: $error');
//   }
// }

void _signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      // Successful sign-in, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // Sign-in process cancelled by the user
      print('Sign-in process cancelled');
    }
  } catch (error) {
    // Handle sign-in errors
    print('Error signing in with Google: $error');
  }
}


// import 'package:flutter/material.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   String _selectedCountry = ''; // To store the selected country
//   bool _isButtonEnabled = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//         backgroundColor: Color(0xFF9DBC98), // Set app bar background color
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             onChanged: () {
//               setState(() {
//                 _isButtonEnabled = _formKey.currentState?.validate() ?? false;
//               });
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                     border: OutlineInputBorder(), // Add border to text field
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null; // Return null if validation succeeds
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _ageController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'Age',
//                     border: OutlineInputBorder(), // Add border to text field
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your age';
//                     }
//                     return null; // Return null if validation succeeds
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: _selectedCountry.isNotEmpty ? _selectedCountry : null,
//                   items: <String>[
//                     'Country 1',
//                     'Country 2',
//                     'Country 3',
//                     // Add more countries as needed
//                   ].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (newValue) {
//                     setState(() {
//                       _selectedCountry = newValue!;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Country',
//                     border: OutlineInputBorder(), // Add border to dropdown
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select your country';
//                     }
//                     return null; // Return null if validation succeeds
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(), // Add border to text field
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an email';
//                     }
//                     // Add custom validation for unique email
//                     // Example: check if email already exists in database
//                     return null; // Return null if validation succeeds
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(), // Add border to text field
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a password';
//                     }
//                     // Add custom validation for password strength
//                     // Example: ensure password meets minimum requirements
//                     return null; // Return null if validation succeeds
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _isButtonEnabled
//                       ? () {
//                           // Implement sign-up logic here
//                           _signUpWithEmail();
//                         }
//                       : null,
//                   child: Text('Sign Up'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Color(0xFF9DBC98), // Set button background color
//                     padding: EdgeInsets.symmetric(vertical: 12), // Add padding
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(10), // Add border radius
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _isButtonEnabled
//                       ? () {
//                           // Implement sign-up with Google logic here
//                           _signUpWithGoogle();
//                         }
//                       : null,
//                   child: Text('Sign Up with Google'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Colors.red, // Change color according to your design
//                     padding: EdgeInsets.symmetric(vertical: 12), // Add padding
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(10), // Add border radius
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void _signUpWithEmail() {}

// void _signUpWithGoogle() {}


// // // ignore_for_file: prefer_const_constructors

// // import 'package:flutter/material.dart';

// // class SignInPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xFF9DBC98),
// //       body: Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// // // Logo
// //               Image.asset(
// //                 'assets/logo.png', 
// //                 height: 80,
// //                 width: 80,
// //               ),
// //               Container(
// //                 padding: EdgeInsets.all(25),
// //                 margin: EdgeInsets.only(top:10),
// //                 decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(20.0), 
// //                       border: Border.all(
// //                           color: Color.fromARGB(255, 42, 42, 42), // Set your desired underline color
// //                           width: 2.0, // Set the underline thickness
// //                         ),
// //                       ),
// //                 child: Column(
// //                   children: [
// //                     SizedBox(height: 16),
                  
// //                 Text(
// //                   'Sign In',
// //                   style: TextStyle(
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //                 SizedBox(height: 16),
// //                 // Email TextField
// //                 SizedBox(
// //                   width: 300,
// //                   child: TextField(
// //                     decoration: InputDecoration(
// //                       hintText: 'Email',
// //                       fillColor: Colors.white,
// //                       filled: true,
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                         borderSide: BorderSide.none,
// //                       ),
// //                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 16),
// //                 // Password TextField
// //                 SizedBox(
// //                   width: 300,
// //                   child: TextField(
// //                     obscureText: true,
// //                     decoration: InputDecoration(
// //                       hintText: 'Password',
// //                       fillColor: Colors.white,
// //                       filled: true,
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                         borderSide: BorderSide.none,
// //                       ),
// //                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 16),
// // // Forget Password Link
// //                 Container(
// //                   // padding: EdgeInsets.symmetric(vertical: 10.0),
// //                     decoration: BoxDecoration(
// //                       border: Border(
// //                         bottom: BorderSide(
// //                           color: Colors.blue, // Set your desired underline color
// //                           width: 2.0, // Set the underline thickness
// //                         ),
// //                       ),
// //                     ),
// //                   child: GestureDetector(
// //                     onTap: () {
// //                     // Implement forget password logic here
// //                     },
// //                     child: Text(
// //                       'Forget Password?',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: 16),
// //                 // Sign In Button
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     // Implement sign-in logic here
// //                   },
// //                   child: Text('Sign In'),
// //                   style: ElevatedButton.styleFrom(
// //                     primary: Colors.blue,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// //                   ),
// //                 ),
// //                 SizedBox(height: 16),
// //                 // Sign In with Google Button
// //                 OutlinedButton(
// //                   onPressed: () {
// //                     // Implement sign-in with Google logic here
// //                   },
// //                   style: OutlinedButton.styleFrom(
// //                     primary: Colors.white,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     side: BorderSide(color: Colors.white),
// //                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Image.asset('assets/google_logo.png', height: 20, width: 20),
// //                       SizedBox(width: 8),
// //                       Text('Sign In with Google'),
// //                     ],
// //                   ),
// //                 ),
// //                 ],
// //                 ),
// //               ),                    //border of feilds
// //               SizedBox(height: 16),
// //               Container(
// //                 child: Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
        
// //                 Text(
// //                         "Don't have account?  ",
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                         ),
// //                       ),
              
// //               GestureDetector(
// //                     onTap: () {
// //                      Navigator.pushNamed(context, '/signup');
// //                     },
// //                     child: Text(
// //                       "Create One",
// //                       style: TextStyle(
// //                         color: Colors.blue,
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.w700
// //                       ),
// //                     ),
// //                   ),
// //                   ]
// //                 ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
