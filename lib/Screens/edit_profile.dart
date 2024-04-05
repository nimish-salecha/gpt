// edit , update user profile
//gpt  v1 updated
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  EditProfile({required this.onProfileUpdated});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _gender;
  int? _age;
  File? _imageFile;
  String? _profilePicUrl;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  void fetchProfileData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            _usernameController.text = userData['username'] ?? '';
            _bioController.text = userData['bio'] ?? '';
            _gender = userData['gender'] ?? '';
            _age = userData['age'] ?? 0;
            _profilePicUrl = userData['profile_pic'] ?? 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
          });
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> _uploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          _imageFile = file;
        });

        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

        await storageRef.putFile(file);

        String downloadURL = await storageRef.getDownloadURL();

        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'profile_pic': downloadURL,
        });

        setState(() {
          _profilePicUrl = downloadURL;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _removeImage() async {
    try {
      final defaultProfilePicURL = 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg')
          .delete();

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'profile_pic': defaultProfilePicURL,
      });

      setState(() {
        _imageFile = null;
        _profilePicUrl = defaultProfilePicURL;
      });
    } catch (e) {
      print('Error removing image: $e');
    }
  }

  void updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String newUsername = _usernameController.text.trim();
        DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String? currentUsername = userData['username'];
        if (newUsername != currentUsername) {
          bool isUsernameUnique = await isUsernameAvailable(newUsername);
          if (!isUsernameUnique) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Username Not Available'),
                  content: Text('The username you entered is already in use. Please choose a different username.'),
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
            return;
          }
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': newUsername,
          'bio': _bioController.text,
          'gender': _gender,
          'age': _age,
        }, SetOptions(merge: true));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      // Notify Dashboard that profile has been updated
      widget.onProfileUpdated();
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateProfile();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  _profilePicUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_profilePicUrl!),
                          radius: 50,
                        )
                      : CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _uploadImage,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('Add Pic'),
                ),
                ElevatedButton(
                  onPressed: _removeImage,
                  child: Text('Remove Pic'),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                fillColor: Colors.grey[100],
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _bioController,
              maxLines: 2,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Bio (up to 20 letter)',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            SizedBox(height: 20),
             // Gender Dropdown
            //  DropdownButtonFormField<String>(
            //   value: _gender,
            //   onChanged: (value) {
            //     setState(() {
            //       _gender = value;
            //     });
            //   },
            //   items: ['Male', 'Female', 'Other']
            //       .map((gender) => DropdownMenuItem<String>(
            //             value: gender,
            //             child: Text(gender),
            //           ))
            //       .toList(),
            //   decoration: InputDecoration(
            //     labelText: 'Gender: ${_gender ?? ""}',
            //   ),
            // ),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _age = int.tryParse(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Age: $_age',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


/* v1 nimish
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  EditProfile({required this.onProfileUpdated});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _gender;
  int? _age;
  // ignore: unused_field
  File? _imageFile;
  String? _profilePicUrl;
  @override
  void initState() {
    super.initState();
    // Fetch profile data when the page is loaded
    fetchProfileData();
  }

  void fetchProfileData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            _usernameController.text = userData['username'] ?? '';
            _bioController.text = userData['bio'] ?? '';
            _gender = userData['gender'] ?? '';
            _age = userData['age'] ?? 0;
            _profilePicUrl = userData['profile_pic'] ?? 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
          });
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  Future<void> _uploadImage() async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
      });

      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

      await storageRef.putFile(file);

      String downloadURL = await storageRef.getDownloadURL();

      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'profile_pic': downloadURL,
      });

      setState(() {
        _profilePicUrl = downloadURL;
      });
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}

Future<void> _removeImage() async {
  try {
    final defaultProfilePicURL = 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5'; // URL of your default profile picture
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('${FirebaseAuth.instance.currentUser!.uid}.jpg')
        .delete();

    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'profile_pic': defaultProfilePicURL,
    });

    setState(() {
      _imageFile = null;
      _profilePicUrl = defaultProfilePicURL;
    });
  } catch (e) {
    print('Error removing image: $e');
  }
}


void updateProfile() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the username is modified
      String newUsername = _usernameController.text.trim();
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String? currentUsername = userData['username'];
      if (newUsername != currentUsername) {
        // Check if the new username is unique
        bool isUsernameUnique = await isUsernameAvailable(newUsername);
        if (!isUsernameUnique) {
          // Show a pop-up dialog if the username is not unique
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Username Not Available'),
                content: Text('The username you entered is already in use. Please choose a different username.'),
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
          return;
        }
      }

      // Update the profile if the username is unique
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': newUsername,
        'bio': _bioController.text,
        'gender': _gender,
        'age': _age,
      }, SetOptions(merge: true));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
  } catch (e) {
    print('Error updating profile: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
  }
}

// Function to check if the username is available
Future<bool> isUsernameAvailable(String username) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('username', isEqualTo: username)
      .get();
  return querySnapshot.docs.isEmpty;
}


//working properly  - but without checking unique username if modified
/*
  void updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _usernameController.text,
          'bio': _bioController.text,
          'gender': _gender,
          'age': _age,
        }, SetOptions(merge: true));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              updateProfile();
               widget.onProfileUpdated();
              Get.back();
              // Get.to(() => Dashboard());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  _profilePicUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(_profilePicUrl!),
                          radius: 50,
                        )
                      : CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _uploadImage,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('Add Pic'),
                ),
                ElevatedButton(
                  onPressed: _removeImage,
                  child: Text('Remove Pic'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Username Field
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            // Bio Field
            TextFormField(
              controller: _bioController,
              maxLines: 2,
              maxLength: 20,
              decoration: InputDecoration(
                labelText: 'Bio (up to 20 letter)',
              ),
            ),
            SizedBox(height: 20),
            // Gender Dropdown
            
  //           DropdownButtonFormField<String>(
  //             value: _gender,
  //             onChanged: (value) {
  //               setState(() {
  //                 _gender = value;
  //               });
  //             },
  //             items: [
  //   DropdownMenuItem<String>(
  //     value: 'Male',
  //     child: Text('Male'),
  //   ),
  //   DropdownMenuItem<String>(
  //     value: 'Female',
  //     child: Text('Female'),
  //   ),
  //   DropdownMenuItem<String>(
  //     value: 'Other',
  //     child: Text('Other'),
  //   ),
  // ],
  // decoration: InputDecoration(
  //   labelText: 'Gender: $_gender',
  // ),
  //             // items: ['Male', 'Female', 'Other']
  //             //     .map((gender) => DropdownMenuItem<String>(
  //             //           value: gender,
  //             //           child: Text(gender),
  //             //         ))
  //             //     .toList(),
  //             // decoration: InputDecoration(
  //             //   labelText: 'Gender: $_gender',
  //             // ),
  //           ),
            SizedBox(height: 20),
            // Age Field
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _age = int.tryParse(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Age: $_age',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
*/