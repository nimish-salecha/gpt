//          User Dash Board (profile)

// ignore_for_file: prefer_const_constructors

// v1 
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/debate_details.dart';
import 'package:gpt/screens/edit_profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get the current user
  User? currentUser = _auth.currentUser;
  // Get the current user's ID
  String currentUserId = currentUser?.uid ?? '';
  
  

class _DashboardState extends State<Dashboard> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  int _selectedIndex = 2;
  String? username;
  String? _profilePicUrl;

//code to refrst new logged in user  -- after onle user is log out
void _updateUserData(User? user) {
  if (user != null) {
    setState(() {
      currentUser = user;
      currentUserId = user.uid;
    });
    fetchFromUsers(); // Refresh user-specific data
  }
}

StreamSubscription<User?>? _authStateSubscription;

@override
void initState() {
  _authStateSubscription = _auth.authStateChanges().listen(_updateUserData);
  super.initState();
  fetchFromUsers();
}

@override
void dispose() {
  _authStateSubscription?.cancel();
  super.dispose();
}

//------------
  // @override
  // void initState() {
  //   fetchFromUsers();
  //   super.initState();
  // }

  Future<void> fetchFromUsers() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          username = userData['username'];
          _profilePicUrl = userData['profile_pic'] ??
              'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
        });
      }
    }
  }

  static List<Widget> _widgetOptions = <Widget>[
    PrivateDebates(),
    PastDebates(),
    FutureDebates(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index % _widgetOptions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Color.fromARGB(255, 32, 32, 70),
        // title: Text('User Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.share,
              color: Color.fromARGB(255, 56, 134, 206),
            ),
            onPressed: () {
              Share.share("User Profile Link");
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Color.fromARGB(255, 32, 32, 70),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor:Color.fromARGB(255, 32, 32, 70),
                  backgroundImage: NetworkImage(_profilePicUrl ??
                      'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5'),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '  Welcome,',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0),
                    Text(
                      '  $username' ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        // backgroundColor: Colors.blue[400],
                      ),
                    ),
                    SizedBox(height: 0),
                    TextButton(
                      onPressed: () {
                        Get.to(() =>
                            EditProfile(onProfileUpdated: fetchFromUsers));
                      },
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () => _onItemTapped(0),
                icon: Icon(Icons.lock),
                color: _selectedIndex == 0 ? Colors.green : Color.fromARGB(255, 32, 32, 70),
              ),
              IconButton(
                onPressed: () => _onItemTapped(1),
                icon: Icon(Icons.history),
                color: _selectedIndex == 1 ? Colors.green : Color.fromARGB(255, 32, 32, 70),
              ),
              IconButton(
                onPressed: () => _onItemTapped(2),
                icon: Icon(Icons.schedule),
                color: _selectedIndex == 2 ? Colors.green : Color.fromARGB(255, 32, 32, 70),
              ),
            ],
          ),
          SizedBox(
            height: dheight * 0.02,
          ),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}

class PrivateDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
                  'Private Debates',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 32, 32, 70)),
                ),
                SizedBox(height: 10),
                // StreamBuilder to fetch and display debates based on selected topic
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('debates')
                      .where('userId', isEqualTo: currentUserId)
                      .where('privacy', isEqualTo: 'Private')
                      .orderBy('scheduledDateTime', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final debates = snapshot.data!.docs;
                      return Column(
                        children: debates.map<Widget>((debate) {
                          // Build debate card widget here
                          return Column(
                            children: [
                              _buildDebateCard(context,debate),
                              SizedBox(height: dheight*0.006),
                            ],
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
          ],
        ),
      ),
    );
  }
}

class PastDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTimePlus30Mins = DateTime.now().add(Duration(minutes: 30));
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Past Debates',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 32, 32, 70)),
          ),
          SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('debates')
                .where('userId', isEqualTo: currentUserId)
                .where('privacy', isEqualTo: 'Public')
                .where('scheduledDateTime', isLessThan: currentTimePlus30Mins)
                .orderBy('scheduledDateTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final debates = snapshot.data!.docs;
                return Column(
                  children: debates.map<Widget>((debate) {
                    return _buildDebateCard(context,debate);
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}

class FutureDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTimePlus40Mins = DateTime.now().add(Duration(minutes: 40));
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Future Debates',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 32, 32, 70)),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('debates')
                .where('userId', isEqualTo: currentUserId)
                .where('privacy', isEqualTo: 'Public')
                .where('scheduledDateTime', isGreaterThan: currentTimePlus40Mins)
                .orderBy('scheduledDateTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final debates = snapshot.data!.docs;
                return Column(
                  children: debates.map<Widget>((debate) {
                    return _buildDebateCard(context,debate);
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}


Widget _buildDebateCard(BuildContext context,DocumentSnapshot debate) {

  final topic = debate['title'];
  final description = debate['description'];
  final scheduledDateTime = debate['scheduledDateTime'];
  final debateType = debate['privacy'];
  final debateId = debate.id; // Get the debate ID

  final currentTime = DateTime.now();
  // Convert scheduledDateTime to DateTime object
  final scheduledTime = scheduledDateTime.toDate();
  // Check if scheduledDateTime is less than current time
  final isPastDebate = scheduledTime.isBefore(currentTime);
  // Define the card color based on whether the debate is past or future
  // final cardColor = isPastDebate ? Color.fromARGB(198, 120, 117, 113):Color.fromARGB(255, 241, 232, 224);
  Color cardColor;
  if (debateType == 'Private') {
    cardColor = isPastDebate ? Color.fromARGB(197, 244, 178, 92):Color.fromARGB(255, 241, 232, 224);
  } else {
    cardColor = Color.fromARGB(255, 241, 232, 224); // Single color for Past and Future debates
  }

  return InkWell(
    onTap: () {
      Get.to(() => DebateDetailsPage(debateId: debateId, dtitle: topic));
    },
    child: Container(
      width: MediaQuery.of(context).size.width, // Set width to device width
      child: Card(
        elevation: 3,
        color: cardColor,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(fontSize: 14),
              ),
              // SizedBox(height: 5),
              
              // Add additional UI elements as needed
            ],
          ),
        ),
      ),
    ),
  );
}


Future<String> _getUserName(String userId) async {
  try {
    User? user = await FirebaseAuth.instance.userChanges().first;
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


// class PublicDebates extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Public Debates'),
//     );
//   }
// }


/* // v1 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/edit_profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 0;
  String? username;
  String? _profilePicUrl;

  @override
  void initState() {
    fetchFromUsers();
    super.initState();
  }

  Future<void> fetchFromUsers() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          username = userData['username'];
          _profilePicUrl = userData['profile_pic'] ??
              'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
        });
      }
    }
  }

  static List<Widget> _widgetOptions = <Widget>[
    PastClashes(),
    FutureDebates(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              title: Text('User Dashboard'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share("User Profile Link");
                  }, //user profil link
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: dheight * 0.01,
                      left: dwidth * 0.02,
                      bottom: dheight * 0.03),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_profilePicUrl ?? 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: dwidth * 0.08),
                        child: Column(
                          children: <Widget>[
                            Text(
                              username?? 'Loading...', // Show 'Loading...' until username is fetched
                              style: TextStyle(
                                fontSize: 24.0,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => EditProfile(onProfileUpdated: fetchFromUsers));
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent), // Remove background color
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent), // Remove overlay color
                              ),
                              child: Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _onItemTapped(0),
                child: Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 6), // Add some spacing between icon and text
                    Text('Past Clashes'),
                  ],
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _onItemTapped(1),
                child: Row(
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 6), // Add some spacing between icon and text
                    Text('Future Clashes'),
                  ],
                ),
              ),
              ],
            ),
            
                SizedBox(height: dheight*0.02,),
                _widgetOptions.elementAt(_selectedIndex),
              ],
            ),
          );
  }
}

class PastClashes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Past Clashes'),
    );
  }
}

class FutureDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Future Debates'),
    );
  }
}
*/