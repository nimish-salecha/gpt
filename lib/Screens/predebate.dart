//shedule debate page  -- peedebate details
import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gpt/screens/scheduled_debates_page.dart';
import 'package:gpt/screens/zego/constants.dart';
import 'package:gpt/widgets/custtom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:uuid/uuid.dart';

final buttonColor = Colors.blue;

class PreDebate extends StatefulWidget {
  const PreDebate({Key? key}) : super(key: key);

  @override
  State<PreDebate> createState() => _PreDebateState();
}

class _PreDebateState extends State<PreDebate> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  String? _thumbnailUrl;
  String _meetingCode = "xyzz";
  DateTime? _selectedDateTime;
  String? _selectedCategory; // Selected category
  String? _selectedPrivacy; //for public & private

  @override
  void initState() {
    fetchUser();
    var uuid = Uuid();
    _meetingCode = uuid.v1().substring(0, 5);
    super.initState();
  }

  // List of categories
  final List<String> categories = [
    'Politics',
    'Entertainment',
    'Religious',
    'Social Issues',
    'Science and Technology',
    'Environment',
    'Education',
    'Health and Wellness',
    'Sports',
    'Business and Economy',
    // Add more categories as needed
  ];

  Future<void> _submitData() async {
    // Check if any required field is empty
    if (_titleController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _selectedDateTime == null ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedPrivacy == null ||
        // ignore: unnecessary_null_comparison
        _meetingCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all details')),
      );
      return;
    }

    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      final defaultProfilePicURL =
          'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
      if (user != null) {
        // Upload thumbnail image to Firebase Storage
        // final _thumbnailUrl = await _uploadThumbnail();

        // Add the debate details to Firestore
        await FirebaseFirestore.instance.collection('debates').add({
          'userId': user.uid,
          'title': _titleController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()) ?? 0,
          'scheduledDateTime': _selectedDateTime,
          'description': _descriptionController.text.trim(),
          '_thumbnailUrl': _thumbnailUrl,
          'category': _selectedCategory, // Add category field
          'privacy': _selectedPrivacy,
          'joincode': _meetingCode,
          'emailSent': 'false',
          // Add other fields as needed
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debate details submitted successfully')),
        );

        // Navigate to scheduled debates page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScheduledDebatesPage()),
        );

        // Clear form data
        _titleController.clear();
        _ageController.clear();
        _dateController.clear();
        _descriptionController.clear();
        setState(() {
          _imageFile = null;
          _thumbnailUrl = defaultProfilePicURL;
          _selectedDateTime = null;
          _selectedCategory = null; // Clear selected category
          _selectedPrivacy = null;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error submitting debate details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit debate details')),
      );
    }
  }
//image

// Define _imageFile as Uint8List
  Uint8List? _imageBytes;

// Read image file as bytes
  Future<void> loadImage() async {
    if (_imageFile != null) {
      _imageBytes = await _imageFile!.readAsBytes();
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
            .child('debate_thumnail')
            .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

        await storageRef.putFile(file);

        String downloadURL = await storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'debate_thumnail': downloadURL,
        });

        setState(() {
          _thumbnailUrl = downloadURL;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateTime != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text = _selectedDateTime!.toString();
        });
      }
    }
  }

//perdebate page layout
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      _uploadImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 20.0,
                      ),
                      child: _imageFile != null
                          ? SizedBox(
                              height: 300,
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit
                                    .cover, // Adjust this based on your requirement
                              ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: buttonColor,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Select your thumbnail',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Age',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter age',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Debate Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter title',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date and Time to be Scheduled On',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: TextField(
                                    controller: _dateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Select date and time',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () => _selectDateTime(context),
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Debate Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter description',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value as String?;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select category',
                        ),
                      ),
                      Row(
                        children: [
                          Text('Privacy: '),
                          Radio<String>(
                            value: 'Public',
                            groupValue: _selectedPrivacy,
                            onChanged: (value) {
                              setState(() {
                                _selectedPrivacy = value;
                              });
                            },
                          ),
                          Text('Public'),
                          Radio<String>(
                            value: 'Private',
                            groupValue: _selectedPrivacy,
                            onChanged: (value) {
                              setState(() {
                                _selectedPrivacy = value;
                              });
                            },
                          ),
                          Text('Private'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'Submit',
                      onTap: _submitData,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduledDebatesPage()),
                        );
                      },
                      child: const Text(
                        'View Scheduled Debates',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


/*  all working 8/04 - 12:12am  --  in new code sepreated in 2 files
//hiya updated
//add image picker for bg image, agg public/private option,
// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:gpt/Screens/edit_debate.dart';
import 'package:gpt/screens/edit_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'package:intl/intl.dart';
import 'package:gpt/widgets/custtom_button.dart';
import 'package:gpt/screens/zego/live_page.dart';
import 'package:gpt/screens/zego/constants.dart';

final buttonColor = Colors.blue;

class PreDebate extends StatefulWidget {
  const PreDebate({Key? key}) : super(key: key);

  @override
  State<PreDebate> createState() => _PreDebateState();
}

class _PreDebateState extends State<PreDebate> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  String? _thumbnailUrl;
  String _meetingCode = "abcdfgqw";
  DateTime? _selectedDateTime;
  String? _selectedCategory; // Selected category
  String? _selectedPrivacy; //for public & private

  @override
  void initState() {
    fetchUser();
    var uuid = Uuid();
    _meetingCode = uuid.v1().substring(0, 5);
    super.initState();
  }

  // List of categories
  final List<String> categories = [
    'Politics',
    'Entertainment',
    'Religious',
    'Social Issues',
    'Science and Technology',
    'Environment',
    'Education',
    'Health and Wellness',
    'Sports',
    'Business and Economy',
    // Add more categories as needed
  ];

  Future<void> _submitData() async {
    // Check if any required field is empty
    if (_titleController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _selectedDateTime == null ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedPrivacy == null ||
        _meetingCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all details')),
      );
      return;
    }

    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      final defaultProfilePicURL =
          'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
      if (user != null) {
        // Upload thumbnail image to Firebase Storage
        // final _thumbnailUrl = await _uploadThumbnail();

        // Add the debate details to Firestore
        await FirebaseFirestore.instance.collection('debates').add({
          'userId': user.uid,
          'title': _titleController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()) ?? 0,
          'scheduledDateTime': _selectedDateTime,
          'description': _descriptionController.text.trim(),
          '_thumbnailUrl': _thumbnailUrl,
          'category': _selectedCategory, // Add category field
          'privacy': _selectedPrivacy,
          'joincode': _meetingCode,
          // Add other fields as needed
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debate details submitted successfully')),
        );

        // Navigate to scheduled debates page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScheduledDebatesPage()),
        );

        // Clear form data
        _titleController.clear();
        _ageController.clear();
        _dateController.clear();
        _descriptionController.clear();
        setState(() {
          _imageFile = null;
          _thumbnailUrl = defaultProfilePicURL;
          _selectedDateTime = null;
          _selectedCategory = null; // Clear selected category
          _selectedPrivacy = null;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error submitting debate details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit debate details')),
      );
    }
  }
//image

// Define _imageFile as Uint8List
  Uint8List? _imageBytes;

// Read image file as bytes
  Future<void> loadImage() async {
    if (_imageFile != null) {
      _imageBytes = await _imageFile!.readAsBytes();
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
            .child('debate_thumnail')
            .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

        await storageRef.putFile(file);

        String downloadURL = await storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'debate_thumnail': downloadURL,
        });

        setState(() {
          _thumbnailUrl = downloadURL;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateTime != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text = _selectedDateTime!.toString();
        });
      }
    }
  }

//perdebate page layout
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      _uploadImage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 20.0,
                      ),
                      child: _imageFile != null
                          ? SizedBox(
                              height: 300,
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit
                                    .cover, // Adjust this based on your requirement
                              ),
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: buttonColor,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Select your thumbnail',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Age',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter age',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Debate Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter title',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date and Time to be Scheduled On',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: TextField(
                                    controller: _dateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Select date and time',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () => _selectDateTime(context),
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Debate Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter description',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value as String?;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select category',
                        ),
                      ),
                      Row(
                        children: [
                          Text('Privacy: '),
                          Radio<String>(
                            value: 'Public',
                            groupValue: _selectedPrivacy,
                            onChanged: (value) {
                              setState(() {
                                _selectedPrivacy = value;
                              });
                            },
                          ),
                          Text('Public'),
                          Radio<String>(
                            value: 'Private',
                            groupValue: _selectedPrivacy,
                            onChanged: (value) {
                              setState(() {
                                _selectedPrivacy = value;
                              });
                            },
                          ),
                          Text('Private'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'Submit',
                      onTap: _submitData,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduledDebatesPage()),
                        );
                      },
                      child: const Text(
                        'View Scheduled Debates',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduledDebatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Debates'),
      ),
      body: ScheduledDebatesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PreDebate()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ScheduledDebatesList extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('debates')
          .where('userId', isEqualTo: user!.uid) // Filter debates by user ID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> debates = snapshot.data!.docs;

        return ListView.builder(
          itemCount: debates.length,
          itemBuilder: (context, index) {
            final debate = debates[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(debate['userId'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final userData = snapshot.data!;
                final hostName = userData['username'] ?? 'Unknown';
                // final joincode =
                return DebateCard(debate: debate, hostName: hostName);
              },
            );
          },
        );
      },
    );
  }
}

class DebateCard extends StatefulWidget {
  final QueryDocumentSnapshot debate;
  final String hostName;

  const DebateCard({
    Key? key,
    required this.debate,
    required this.hostName,
  }) : super(key: key);

  @override
  State<DebateCard> createState() => _DebateCardState();
}

class _DebateCardState extends State<DebateCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    // Extracting date and time
    final DateTime scheduledDateTime =
        (widget.debate['scheduledDateTime'] as Timestamp).toDate();
    final String scheduledDate =
        DateFormat('MM/dd/yy').format(scheduledDateTime);
    final String scheduledTime =
        DateFormat('HH:mm:ss').format(scheduledDateTime);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.debate['title'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scheduled Date: $scheduledDate'),
                Text('Scheduled Time: $scheduledTime'),
                const SizedBox(height: 5),
                Text('Age>: ${widget.debate['age']}'),
                Text('Description: ${widget.debate['description']}'),
                Text('Category: ${widget.debate['category'] ?? 'No category'}'),
                Text('Meeting Code : ${widget.debate['joincode']}'),
                Text('Privacy: ${widget.debate['privacy'] ?? 'No privacy'}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text('Go live'),
                    onPressed: () {
                      if (ZegoUIKitPrebuiltLiveStreamingController()
                          .minimize
                          .isMinimizing) {
                        return;
                      }
                      jumpToLivePage(
                        context,
                        liveID: widget.debate['joincode'].trim(),
                        isHost: true,
                      );
                    },
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _showEditDebateScreen(context, widget.debate);
                    },
                    child: const Icon(Icons.edit),
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    child: const Icon(Icons.delete),
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      Share.share("Meeting Code : ${widget.debate['joincode']}");
                    },
                    child: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String liveID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          liveID: liveID,
          isHost: isHost,
          localUserID: localUserID,
        ),
      ),
    );
  }

  void _showEditDebateScreen(
      BuildContext context, QueryDocumentSnapshot<Object?> debate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDebateScreen(debate: debate),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Debate?'),
          content: Text('Are you sure you want to delete this debate?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteDebate();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDebate() async {
    try {
      await _firestore.collection('debates').doc(widget.debate.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debate deleted successfully')),
      );
    } catch (e) {
      print('Error deleting debate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete debate')),
      );
    }
  }
}
*/


/*   all working checking new hiya code 7/04  8:45am

//updated
// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'package:intl/intl.dart';
import 'package:gpt/widgets/custtom_button.dart';
import 'package:gpt/screens/zego/live_page.dart';
import 'package:gpt/screens/zego/constants.dart';


final buttonColor = Colors.blue;

class PreDebate extends StatefulWidget {
  const PreDebate({Key? key}) : super(key: key);

  @override
  State<PreDebate> createState() => _PreDebateState();
}

class _PreDebateState extends State<PreDebate> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
  String? _thumbnailUrl;
  String _meetingCode = "abcdfgqw";
  DateTime? _selectedDateTime;
  String? _selectedCategory; // Selected category
  String? _selectedPrivacy;   //for public & private

   @override
  void initState() {
    fetchUser();
    var uuid = Uuid();
    _meetingCode = uuid.v1().substring(0, 5);
    super.initState();
  }

  // List of categories
  final List<String> categories = [
    'Politics',
    'Entertainment',
    'Religious',
    'Social Issues',
    'Science and Technology',
    'Environment',
    'Education',
    'Health and Wellness',
    'Sports',
    'Business and Economy',
    // Add more categories as needed
  ];

  Future<void> _submitData() async {
    // Check if any required field is empty
    if (_titleController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _selectedDateTime == null ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedPrivacy == null ||
        _meetingCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all details')),
      );
      return;
    }

    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      final defaultProfilePicURL = 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
      if (user != null) {
        // Upload thumbnail image to Firebase Storage
        // final _thumbnailUrl = await _uploadThumbnail();

        // Add the debate details to Firestore
        await FirebaseFirestore.instance.collection('debates').add({
          'userId': user.uid,
          'title': _titleController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()) ?? 0,
          'scheduledDateTime': _selectedDateTime,
          'description': _descriptionController.text.trim(),
          '_thumbnailUrl': _thumbnailUrl,
          'category': _selectedCategory, // Add category field
          'privacy': _selectedPrivacy,
          'joincode': _meetingCode,
          'cohosts': "bhs",
          // Add other fields as needed
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debate details submitted successfully')),
        );

        // Navigate to scheduled debates page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScheduledDebatesPage()),
        );

        // Clear form data
        _titleController.clear();
        _ageController.clear();
        _dateController.clear();
        _descriptionController.clear();
        setState(() {
          _imageFile = null;
          _thumbnailUrl = defaultProfilePicURL;
          _selectedDateTime = null;
          _selectedCategory = null; // Clear selected category
          _selectedPrivacy = null;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error submitting debate details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit debate details')),
      );
    }
  }
//image

// Define _imageFile as Uint8List
Uint8List? _imageBytes;

// Read image file as bytes
Future<void> loadImage() async {
  if (_imageFile != null) {
    _imageBytes = await _imageFile!.readAsBytes();
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
          .child('debate_thumnail')
          .child('${FirebaseAuth.instance.currentUser!.uid}.jpg');

      await storageRef.putFile(file);

      String downloadURL = await storageRef.getDownloadURL();

      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'debate_thumnail': downloadURL,
      });

      setState(() {
        _thumbnailUrl = downloadURL;
      });
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}


  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDateTime != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateController.text = _selectedDateTime!.toString();
        });
      }
    }
  }
//perdebate page layout
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    _uploadImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 20.0,
                    ),
                    child: _imageFile != null
                        ? SizedBox(
                            height: 300,
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover, // Adjust this based on your requirement
                            ),
                          )
                        : DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            color: buttonColor,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: buttonColor.withOpacity(.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Select your thumbnail',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter age',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Debate Title',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter title',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date and Time to be Scheduled On',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: TextField(
                                  controller: _dateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Select date and time',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () => _selectDateTime(context),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Debate Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter description',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButtonFormField(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value as String?;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select category',
                      ),
                    ),
                    Row(
                        children: [
                          Text('Privacy: '),
                          Radio<String>(
                            value: 'Public',
                            groupValue: _selectedPrivacy,
                            onChanged: (value) {
                              setState(() {
                                _selectedPrivacy = value;
                              });
                            },
                          ),
                          Text('Public'),
                          Radio<String>(
                            value: 'Private',
                            groupValue: _selectedPrivacy,
                            onChanged: (value) {
                              setState(() {
                                _selectedPrivacy = value;
                              });
                            },
                          ),
                          Text('Private'),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Submit',
                    onTap: _submitData,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScheduledDebatesPage()),
                      );
                    },
                    child: const Text(
                      'View Scheduled Debates',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
//old but thumbnail not working and dont have public & privacy option
 /* @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      _uploadImage();
                      // if (pickedImage != null) {
                      //   setState(() {
                      //     image = pickedImage.files.single.bytes;
                      //   });
                      // }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 20.0,
                      ),
                      child: _imageFile != null
                          ? SizedBox(
                              height: 300,
                              child: _imageBytes != null
                                  ? Image.memory(
                                      _imageBytes!,
                                      fit: BoxFit.cover, // Adjust this based on your requirement
                                    )
                                  : SizedBox(
                                      height: 100, 
                                      width: 100, 
                                      child: CupertinoActivityIndicator(),
                                    )
                            ) 
                          // SizedBox(
                          //     height: 300,
                          //     child: Image.memory(_imageFile),
                          //   )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: buttonColor,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: buttonColor.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Select your thumbnail',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Age',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter age',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Debate Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter title',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date and Time to be Scheduled On',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: TextField(
                                    controller: _dateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Select date and time',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () => _selectDateTime(context),
                              icon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Debate Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter description',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButtonFormField(
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value as String?;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Select category',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    CustomButton(
                      text: 'Submit',
                      onTap: _submitData,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduledDebatesPage()),
                        );
                      },
                      child: const Text(
                        'View Scheduled Debates',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }*/
}

class ScheduledDebatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Debates'),
      ),
      body: ScheduledDebatesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PreDebate()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ScheduledDebatesList extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('debates')
          .where('userId', isEqualTo: user!.uid) // Filter debates by user ID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> debates = snapshot.data!.docs;

        return ListView.builder(
          itemCount: debates.length,
          itemBuilder: (context, index) {
            final debate = debates[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(debate['userId'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CupertinoActivityIndicator();
                }

                final userData = snapshot.data!;
                final hostName = userData['username'] ?? 'Unknown';
                // final joincode = 
                return DebateCard(debate: debate, hostName: hostName);
              },
            );
          },
        );
      },
    );
  }
}

class DebateCard extends StatefulWidget {
  final QueryDocumentSnapshot debate;
  final String hostName;

  const DebateCard({
    Key? key,
    required this.debate,
    required this.hostName,
  }) : super(key: key);

  @override
  State<DebateCard> createState() => _DebateCardState();
}

class _DebateCardState extends State<DebateCard> {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    // Extracting date and time
    final DateTime scheduledDateTime =
        (widget.debate['scheduledDateTime'] as Timestamp).toDate();
    final String scheduledDate =
        DateFormat('MM/dd/yy').format(scheduledDateTime);
    final String scheduledTime =
        DateFormat('HH:mm:ss').format(scheduledDateTime);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.debate['title'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Host: $hostName'), // Display host name
                // const SizedBox(height: 5),
                Text('Scheduled Date: $scheduledDate'),
                Text('Scheduled Time: $scheduledTime'),
                const SizedBox(height: 5),
                Text('Age>: ${widget.debate['age']}'),
                Text('Description: ${widget.debate['description']}'),
                Text('Category: ${widget.debate['category'] ?? 'No category'}'),
                Text('Meeting Code : ${widget.debate['joincode']}'),
                Text('Privacy: ${widget.debate['privacy'] ?? 'No privacy'}'),
                // Add more details as needed

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  // style: buttonStyle,
                  child: const Text('Go live'),
                  onPressed: () {
                    if (ZegoUIKitPrebuiltLiveStreamingController()
                        .minimize
                        .isMinimizing) {
                      /// when the application is minimized (in a minimized state),
                      /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                      return;
                    }

                    jumpToLivePage(
                      context,
                      liveID: widget.debate['joincode'].trim(),
                      isHost: true,
                    );
                  },
                ),
                SizedBox(width: dwidth*0.03,),
                ElevatedButton(
                  onPressed: () {
                    Share.share("Meeting Code : ${widget.debate['joincode']}");
                  },
                  child: const Icon(Icons.share),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void jumpToLivePage(BuildContext context,
    {required String liveID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          liveID: liveID,
          isHost: isHost,
          localUserID: localUserID,
        ),
      ),
    );
  }
}
*/