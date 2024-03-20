import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedCountry = ''; // To store the selected country
  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xFF9DBC98), // Set app bar background color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                _isButtonEnabled = _formKey.currentState?.validate() ?? false;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(), // Add border to text field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null; // Return null if validation succeeds
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
  controller: _ageController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Age',
    border: OutlineInputBorder(), // Add border to text field
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    int? age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid number';
    }
    if (age < 8 || age > 100) {
      return 'Age must be between 8 and 100';
    }
    return null; // Return null if validation succeeds
  },
),

                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCountry.isNotEmpty ? _selectedCountry : null,
                  items: <String>[
                      'Afghanistan', 'Albania', 'Algeria', 'Argentina', 'Australia','Austria', 'Bangladesh', 'Brazil', 'Canada', 'China', 
                      'Colombia', 'Egypt', 'Ethiopia', 'France', 'Germany', 'India', 'Indonesia', 'Iran', 'Iraq', 'Italy', 
                      'Japan', 'Kenya', 'South Korea', 'Mexico', 'Nigeria', 'Pakistan', 'Philippines', 'Poland', 'Russia', 'Saudi Arabia', 
                      'South Africa', 'Spain', 'Sudan', 'Tanzania', 'Thailand','Turkey', 'Uganda', 'Ukraine', 'United Kingdom', 'United States', 
                      'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe'
                    ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCountry = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(), // Add border to dropdown
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your country';
                    }
                    return null; // Return null if validation succeeds
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(), // Add border to text field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    // Add custom validation for unique email
                    // Example: check if email already exists in database
                    return null; // Return null if validation succeeds
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(), // Add border to text field
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                      }
                      if (value.length > 10) {
                      return 'Password must not exceed 10 characters';
                      }
                      if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+$').hasMatch(value)) {
                      return 'Password must be alphanumeric';
                      }
                    return null; // Return null if validation succeeds
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          // Implement sign-up logic here
                          _signUpWithEmail();
                        }
                      : null,
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF9DBC98), // Set button background color
                    padding: EdgeInsets.symmetric(vertical: 12), // Add padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Add border radius
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          // Implement sign-up with Google logic here
                          _signUpWithGoogle();
                        }
                      : null,
                  child: Text('Sign Up with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Change color according to your design
                    padding: EdgeInsets.symmetric(vertical: 12), // Add padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Add border radius
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _signUpWithEmail() {}

void _signUpWithGoogle() {}


// // import 'package:flutter/material.dart';

// // class SignUpPage extends StatefulWidget {
// //   @override
// //   _SignUpPageState createState() => _SignUpPageState();
// // }

// // class _SignUpPageState extends State<SignUpPage> {
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Sign Up'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextField(
// //               controller: _emailController,
// //               decoration: InputDecoration(
// //                 labelText: 'Email',
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             TextField(
// //               controller: _passwordController,
// //               obscureText: true,
// //               decoration: InputDecoration(
// //                 labelText: 'Password',
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: () {
// //                 // Implement sign-up logic here
// //               },
// //               child: Text('Sign Up'),
// //               style: ElevatedButton.styleFrom(
// //                 primary: Color(0xFF9DBC98),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }