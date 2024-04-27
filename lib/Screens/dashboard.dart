//          User Dash Board (profile)

//v1 code to merge with hiya code
// v1 
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
    PrivateDebates(),
    PublicDebates(),
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
              // IconButton(
              //   onPressed: () => _onItemTapped(1),
              //   icon: Icon(Icons.public),
              //   color: _selectedIndex == 1 ? Colors.green : Color.fromARGB(255, 32, 32, 70),
              // ),
              IconButton(
                onPressed: () => _onItemTapped(2),
                icon: Icon(Icons.history),
                color: _selectedIndex == 2 ? Colors.green : Color.fromARGB(255, 32, 32, 70),
              ),
              IconButton(
                onPressed: () => _onItemTapped(3),
                icon: Icon(Icons.schedule),
                color: _selectedIndex == 3 ? Colors.green : Color.fromARGB(255, 32, 32, 70),
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
    return Center(
      child: Text('Private Debates'),
    );
  }
}

class PublicDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Public Debates'),
    );
  }
}

class PastDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Past Debates'),
    );
  }
}

class FutureDebates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Future Debates'),
    );
  }
}


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