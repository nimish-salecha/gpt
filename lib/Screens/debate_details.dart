import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DebateDetailsPage extends StatefulWidget {
  final String debateId;

  DebateDetailsPage({required this.debateId});

  @override
  State<DebateDetailsPage> createState() => _DebateDetailsPageState();
}

class _DebateDetailsPageState extends State<DebateDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debate Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('debates')
            .doc(widget.debateId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Debate not found!'),
            );
          }
          var debateData = snapshot.data!;
          String title = debateData['title'];
          String description = debateData['description'];
          String category = debateData['category'];

          String summary = generateSummary(title, category, description);

          return FutureBuilder(
            future: _getUserName(),
            builder: (context, AsyncSnapshot<String> hostSnapshot) {
              if (hostSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!hostSnapshot.hasData) {
                return Center(
                  child: Text('Host not found!'),
                );
              }
              String host = hostSnapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200, // Adjust height as needed
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2), // Background color
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                      ),
                      child: Icon(
                        Icons.people, // Example debate icon
                        size: 100, // Adjust size as needed
                        color: Colors.grey, // Icon color
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Debate Host: $host',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Title: $title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Description: $description',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Category: $category',
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Summary:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(summary),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String generateSummary(String title, String category, String description) {
    // You can implement your summary generation logic here
    // For example, concatenating title, category, and description
    return '$title - $category\n$description';
  }

  Future<String> _getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.displayName ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }
}
