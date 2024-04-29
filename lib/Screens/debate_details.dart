// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gpt/screens/zego/constants.dart';
import 'package:gpt/screens/zego/live_page.dart';
import 'package:intl/intl.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';


class DebateDetailsPage extends StatefulWidget {
  final String debateId;
  final String dtitle;

  DebateDetailsPage({required this.debateId, required this.dtitle});

  @override
  State<DebateDetailsPage> createState() => _DebateDetailsPageState();
}

class _DebateDetailsPageState extends State<DebateDetailsPage> {
  bool isHost = false; 

   @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          localUserID = user.uid;
        });
        if (userData.exists) {
          uname = userData['username'] ?? '';
          print('uname= $uname  --uid= $localUserID');
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String controller;
    return Scaffold(
      appBar: AppBar(
        title: Text( '${widget.dtitle}' ?? 'Debate Details'),
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
          String title = debateData['title'].toUpperCase();
          String description = debateData['description'];
          String category = debateData['category'];
          var datetime = debateData['scheduledDateTime'].toDate();
           controller = debateData['joincode'];
          
          // Convert DateTime to time string
          String dateString = DateFormat('yyyy-MM-dd').format(datetime);
          String timeString = DateFormat('HH:mm:ss').format(datetime);

          String summary = generateSummary(title, category, description);

          //for join/golive button ishost or not
          String currentUserId = FirebaseAuth.instance.currentUser!.uid;
          String debateUserId = debateData['userId'];
          // // Compare the two values to determine if the current user is the host
          isHost = currentUserId == debateUserId;
          print(isHost);

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
              String host = hostSnapshot.data!.toUpperCase();
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2), // Background color
                        borderRadius: BorderRadius.circular(10.0), // Add border radius
                      ),
                      child: FutureBuilder<String?>(
                        future: _getImageUrl(), // Future for fetching image URL
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // If image URL is being fetched, show a loading indicator
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            // If image URL is available, show the image
                            return Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4,
                            );
                          } else {
                            // If image URL is not available, show default image based on category
                            switch (category) {
                              case 'Politics':
                                return Image.asset(
                                  'assets/category/politics.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Entertainment':
                                return Image.asset(
                                  'assets/category/entertainment.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Religious':
                                return Image.asset(
                                  'assets/category/relegious.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Social Issues':
                                return Image.asset(
                                  'assets/category/social.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Science and Technology':
                                return Image.asset(
                                  'assets/category/science.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Environment':
                                return Image.asset(
                                  'assets/category/env.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Education':
                                return Image.asset(
                                  'assets/category/edu.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Health and Wellness':
                                return Image.asset(
                                  'assets/category/health.png', 
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Sports':
                                return Image.asset(
                                  'assets/category/sports.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Business and Economy':
                                return Image.asset(
                                  'assets/category/bussiness.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              default:
                                return Image.asset(
                                    'assets/category/debate.png', 
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.4,
                                  );
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Set the width to 80% of the device width
        child: ElevatedButton(
          child: Text(isHost ? 'Start' : 'Join'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () {
            if (ZegoUIKitPrebuiltLiveStreamingController().minimize.isMinimizing) {
              /// when the application is minimized (in a minimized state),
              /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
              return;
            }

            jumpToLivePage(
              context,
              liveID: controller,
              isHost: isHost,
            );
          },
        ),
      ),
    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Topic of the Debate: $title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Hosted By: $host',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '$description',
                      // 'Description: $description',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Category: $category',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Age>= ${debateData['age']}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Date: $dateString',
                    ),
                    SizedBox(height: 10.0),
                    RichText(
                      text: TextSpan(
                        text: 'Scheduled Date: ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: timeString, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
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

  Future<String?> _getImageUrl() async {
    try {
      DocumentSnapshot debateSnapshot = await FirebaseFirestore.instance
          .collection('debates')
          .doc(widget.debateId)
          .get();

      if (debateSnapshot.exists) {
        Map<String, dynamic>? data = debateSnapshot.data() as Map<String, dynamic>?;
        if(data != null) {
          String? thumbnailUrl = data['_thumbnailUrl'] as String?;
          return thumbnailUrl;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching thumbnail URL: $e');
      return null;
    }
  }
}


/* v2 all working - not added join button yet
// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DebateDetailsPage extends StatefulWidget {
  final String debateId;
  final String dtitle;

  DebateDetailsPage({required this.debateId, required this.dtitle});

  @override
  State<DebateDetailsPage> createState() => _DebateDetailsPageState();
}

class _DebateDetailsPageState extends State<DebateDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( '${widget.dtitle}' ?? 'Debate Details'),
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
          String title = debateData['title'].toUpperCase();
          String description = debateData['description'];
          String category = debateData['category'];
          var datetime = debateData['scheduledDateTime'].toDate();
          
          // Convert DateTime to time string
          String dateString = DateFormat('yyyy-MM-dd').format(datetime);
          String timeString = DateFormat('HH:mm:ss').format(datetime);

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
              String host = hostSnapshot.data!.toUpperCase();
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2), // Background color
                        borderRadius: BorderRadius.circular(10.0), // Add border radius
                      ),
                      child: FutureBuilder<String?>(
                        future: _getImageUrl(), // Future for fetching image URL
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // If image URL is being fetched, show a loading indicator
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            // If image URL is available, show the image
                            return Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4,
                            );
                          } else {
              // If image URL is not available, show default image based on category
                            switch (category) {
                              case 'Politics':
                                return Image.asset(
                                  'assets/category/politics.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Entertainment':
                                return Image.asset(
                                  'assets/category/entertainment.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Religious':
                                return Image.asset(
                                  'assets/category/relegious.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Social Issues':
                                return Image.asset(
                                  'assets/category/social.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Science and Technology':
                                return Image.asset(
                                  'assets/category/science.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Environment':
                                return Image.asset(
                                  'assets/category/env.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Education':
                                return Image.asset(
                                  'assets/category/edu.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Health and Wellness':
                                return Image.asset(
                                  'assets/category/health.png', 
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Sports':
                                return Image.asset(
                                  'assets/category/sports.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Business and Economy':
                                return Image.asset(
                                  'assets/category/bussiness.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.4,
                                );
                              default:
                                return Image.asset(
                                    'assets/category/debate.png', 
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.4,
                                  );
                                // return Icon(
                                //   Icons.people, 
                                //   size: 100,
                                //   color: Colors.grey, 
                                // );
                            }
                          }
                        },
                      ),
                    ),



                    SizedBox(height: 20.0),
                    Text(
                      'Topic of the Debate: $title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Hosted By: $host',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '$description',
                      // 'Description: $description',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Category: $category',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Age>= ${debateData['age']}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Date: $dateString',
                    ),
                    SizedBox(height: 10.0),
                    RichText(
                      text: TextSpan(
                        text: 'Scheduled Date: ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: timeString, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
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

  Future<String?> _getImageUrl() async {
  try {
    DocumentSnapshot debateSnapshot = await FirebaseFirestore.instance
        .collection('debates')
        .doc(widget.debateId)
        .get();

    if (debateSnapshot.exists) {
      Map<String, dynamic>? data = debateSnapshot.data() as Map<String, dynamic>?;
      if(data != null) {
        String? thumbnailUrl = data['_thumbnailUrl'] as String?;
        return thumbnailUrl;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching thumbnail URL: $e');
    return null;
  }
}
}
*/



//---------------------------
/* working version1  -- image showing code not set only
// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DebateDetailsPage extends StatefulWidget {
  final String debateId;
  final String dtitle;

  DebateDetailsPage({required this.debateId, required this.dtitle});

  @override
  State<DebateDetailsPage> createState() => _DebateDetailsPageState();
}

class _DebateDetailsPageState extends State<DebateDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( '${widget.dtitle}' ?? 'Debate Details'),
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
          String title = debateData['title'].toUpperCase();
          String description = debateData['description'];
          String category = debateData['category'];
          var datetime = debateData['scheduledDateTime'].toDate();
          
          // Convert DateTime to time string
          String dateString = DateFormat('yyyy-MM-dd').format(datetime);
          String timeString = DateFormat('HH:mm:ss').format(datetime);

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
              String host = hostSnapshot.data!.toUpperCase();
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
                      'Topic of the Debate: $title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Hosted By: $host',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '$description',
                      // 'Description: $description',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Category: $category',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Age>= ${debateData['age']}',
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Date: $dateString',
                    ),
                    SizedBox(height: 10.0),
                    RichText(
                      text: TextSpan(
                        text: 'Scheduled Date: ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: timeString, style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
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
*/