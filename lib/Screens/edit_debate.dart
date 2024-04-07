import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class EditDebateScreen extends StatefulWidget {
//   final QueryDocumentSnapshot debate;

//   const EditDebateScreen({Key? key, required this.debate}) : super(key: key);

//   @override
//   _EditDebateScreenState createState() => _EditDebateScreenState();
// }

// class _EditDebateScreenState extends State<EditDebateScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   String? _selectedCategory;
//   String? _selectedPrivacy;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFields();
//   }

//   final List<String> categories = [
//     'Politics',
//     'Entertainment',
//     'Religious',
//     'Social Issues',
//     'Science and Technology',
//     'Environment',
//     'Education',
//     'Health and Wellness',
//     'Sports',
//     'Business and Economy',
//     // Add more categories as needed
//   ];

//   void _initializeFields() {
//     _titleController.text = widget.debate['title'] ?? '';
//     _ageController.text = (widget.debate['age'] ?? 0).toString();
//     _descriptionController.text = widget.debate['description'] ?? '';
//     _selectedCategory = widget.debate['category'];
//     _selectedPrivacy = widget.debate['privacy'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Debate'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Debate Title'),
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Age'),
//             TextField(
//               controller: _ageController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Description'),
//             TextField(
//               controller: _descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Category'),
//             DropdownButtonFormField(
//               value: _selectedCategory,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value as String?;
//                 });
//               },
//               items: categories.map((category) {
//                 return DropdownMenuItem(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('Privacy'),
//             DropdownButtonFormField(
//               value: _selectedPrivacy,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedPrivacy = value as String?;
//                 });
//               },
//               items: ['Public', 'Private'].map((privacy) {
//                 return DropdownMenuItem(
//                   value: privacy,
//                   child: Text(privacy),
//                 );
//               }).toList(),
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _updateDebate,
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _updateDebate() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('debates')
//           .doc(widget.debate.id)
//           .update({
//         'title': _titleController.text.trim(),
//         'age': int.tryParse(_ageController.text.trim()) ?? 0,
//         'description': _descriptionController.text.trim(),
//         'category': _selectedCategory,
//         'privacy': _selectedPrivacy,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Debate details updated successfully')),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       print('Error updating debate details: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update debate details')),
//       );
//     }
//   }
// }
class EditDebateScreen extends StatefulWidget {
  final QueryDocumentSnapshot debate;

  const EditDebateScreen({Key? key, required this.debate}) : super(key: key);

  @override
  _EditDebateScreenState createState() => _EditDebateScreenState();
}

class _EditDebateScreenState extends State<EditDebateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedPrivacy;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

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

  void _initializeFields() {
    _titleController.text = widget.debate['title'] ?? '';
    _ageController.text = (widget.debate['age'] ?? 0).toString();
    _descriptionController.text = widget.debate['description'] ?? '';
    _selectedCategory = widget.debate['category'];
    _selectedPrivacy = widget.debate['privacy'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Debate'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Debate Title'),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Age'),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Description'),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text('Category'),
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
                ),
              ),
              SizedBox(height: 16),
              Text('Privacy'),
              DropdownButtonFormField(
                value: _selectedPrivacy,
                onChanged: (value) {
                  setState(() {
                    _selectedPrivacy = value as String?;
                  });
                },
                items: ['Public', 'Private'].map((privacy) {
                  return DropdownMenuItem(
                    value: privacy,
                    child: Text(privacy),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateDebate,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateDebate() async {
    try {
      await FirebaseFirestore.instance
          .collection('debates')
          .doc(widget.debate.id)
          .update({
        'title': _titleController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory,
        'privacy': _selectedPrivacy,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debate details updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error updating debate details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update debate details')),
      );
    }
  }
}
