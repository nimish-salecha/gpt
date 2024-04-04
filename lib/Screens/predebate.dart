import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gpt/widgets/custtom_button.dart';

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
  Uint8List? image;
  DateTime? _selectedDateTime;
  String? _selectedCategory; // Selected category

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
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all details')),
      );
      return;
    }

    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload thumbnail image to Firebase Storage
        final thumbnailUrl = await _uploadThumbnail();

        // Add the debate details to Firestore
        await FirebaseFirestore.instance.collection('debates').add({
          'userId': user.uid,
          'title': _titleController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()) ?? 0,
          'scheduledDateTime': _selectedDateTime,
          'description': _descriptionController.text.trim(),
          'thumbnailUrl': thumbnailUrl,
          'category': _selectedCategory, // Add category field
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
          image = null;
          _selectedDateTime = null;
          _selectedCategory = null; // Clear selected category
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

  Future<String> _uploadThumbnail() async {
    try {
      if (image != null) {
        // Upload image to Firebase Storage
        final fileName = DateTime.now().toString();
        final ref = FirebaseStorage.instance.ref().child(fileName);
        final uploadTask = ref.putData(image!);
        final taskSnapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await taskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      }
      return '';
    } catch (e) {
      print('Error uploading thumbnail: $e');
      throw Exception('Failed to upload thumbnail');
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
                      final pickedImage = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          image = pickedImage.files.single.bytes;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 20.0,
                      ),
                      child: image != null
                          ? SizedBox(
                              height: 300,
                              child: Image.memory(image!),
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('debates').snapshots(),
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
            return DebateCard(debate: debate);
          },
        );
      },
    );
  }
}

class DebateCard extends StatelessWidget {
  final QueryDocumentSnapshot debate;

  const DebateCard({Key? key, required this.debate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(debate['title'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scheduled Time: ${debate['scheduledDateTime']}'),
            Text('Age: ${debate['age']}'),
            Text('Description: ${debate['description']}'),
            // Text('Category: ${debate['category']}'),
            Text('Category: ${debate['category'] ?? 'No category'}'),

            // Add more details as needed
          ],
        ),
        trailing: const Text('Status: Scheduled'),
      ),
    );
  }
}
