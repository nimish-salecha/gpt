// Main Home Page --  1st feed page

//V2
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/setting_page.dart';

class FeedMain extends StatefulWidget {
  _FeedMain createState() => _FeedMain();
}

class _FeedMain extends State<FeedMain> {
  final User? user = Auth().currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedTopic;
  String? username;

  void fetchDebatesByTopic(String topic) {
    setState(() {
      selectedTopic = topic;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          username = userData['username'];
        });
      }
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Image.asset(
            'assets/nexo_logo.png',
            height: dheight * 0.5,
            width: dwidth * 0.5,
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 75, 129),
                ),
                child: Text(
                  'Hii, $username' ?? 'Hii, User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('About Us'),
                onTap: () {
                  Get.to(() => AboutUs());
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Get.to(() => Settings_tab());
                },
              ),
              ListTile(
                leading: Icon(Icons.logout_sharp),
                title: Text('Log Out'),
                onTap: () {
                  signOut();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending Debates',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildDebateCard('Debate Topic 1', 'User1'),
                      _buildDebateCard('Debate Topic 2', 'User2'),
                      _buildDebateCard('Debate Topic 3', 'User3'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Featured Topics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Featured topics
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTopicChip('Politics'),
                      _buildTopicChip('Religious'),
                      _buildTopicChip('Science and Technology'),
                      _buildTopicChip('Social Issues'),
                      _buildTopicChip('Entertainment'),
                      _buildTopicChip('Environment'),
                      _buildTopicChip('Education'),
                      _buildTopicChip('Health and Wellness'),
                      _buildTopicChip('Sports'),
                      _buildTopicChip('Business and Economy'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Debates by selected topic
                if (selectedTopic != null) ...[
                  Text(
                    'Debates on $selectedTopic',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // StreamBuilder to fetch and display debates based on selected topic
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('debates')
                        .where('category', isEqualTo: selectedTopic)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final debates = snapshot.data!.docs;
                        return Column(
                          children: debates.map<Widget>((debate) {
                            // Build debate card widget here
                            return Column(
                              children: [
                                _buildDebateCard(
                                    debate['title'], debate['userId']),
                                SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDebateCard(String topic, String host) {
    return Card(
      elevation: 3,
      color: Color.fromARGB(255, 220, 255, 216),
      margin: EdgeInsets.only(right: 10),
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
            FutureBuilder(
              future: _getUserName(host),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Host: Loading...');
                } else {
                  return Text('Host: ${snapshot.data}');
                }
              },
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding
      child: GestureDetector(
        onTap: () {
          fetchDebatesByTopic(topic);
        },
        child: Chip(
          label: Text(topic),
          backgroundColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<String> _getUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      return userSnapshot['username'];
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }
}


/* V1
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/setting_page.dart';

class FeedMain extends StatefulWidget {
  _FeedMain createState() => _FeedMain();
}

class _FeedMain extends State<FeedMain> {
  final User? user = Auth().currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedTopic;
  String? username;
  void fetchDebatesByTopic(String topic) {
    setState(() {
      selectedTopic = topic;
    });
  }

  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          username = userData['username'];
          // _profilePicUrl = userData['profile_pic'] ?? 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
        });
      }
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side of the header
              //menu drawer
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              //right side
              Image.asset(
                'assets/nexo_logo.png',
                height: dheight * 0.5,
                width: dwidth * 0.5,
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 75, 129),
                ),
                child: Text(
                  'Hii, $username' ?? 'Hii, User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('About Us'),
                onTap: () {
                  Get.to(
                    () => AboutUs(),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Get.to(() => Settings_tab());
                },
              ),
              ListTile(
                leading: Icon(Icons.logout_sharp),
                title: Text('Log Out'),
                onTap: () {
                  signOut();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending Debates',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildDebateCard('Debate Topic 1', 'Host: User1'),
                      _buildDebateCard('Debate Topic 2', 'Host: User2'),
                      _buildDebateCard('Debate Topic 3', 'Host: User3'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Featured Topics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Featured topics
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      children: [
                        _buildTopicChip('Politics'),
                        _buildTopicChip('Technology'),
                        _buildTopicChip('Science'),
                        _buildTopicChip('Entertainment'),
                        _buildTopicChip('Religious'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Debates by selected topic
                if (selectedTopic != null) ...[
                  Text(
                    'Debates on $selectedTopic',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // StreamBuilder to fetch and display debates based on selected topic
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('debates')
                        .where('category', isEqualTo: selectedTopic)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final debates = snapshot.data!.docs;
                        return Column(
                          children: debates.map<Widget>((debate) {
                            // Build debate card widget here
                            return _buildDebateCard(
                                debate['title'], debate['userId']);
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDebateCard(String topic, String host) {
    return Card(
      elevation: 3,
      color: Color.fromARGB(255, 220, 255, 216),
      margin: EdgeInsets.only(right: 10),
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
            Text(host),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return GestureDetector(
      onTap: () {
        fetchDebatesByTopic(topic);
      },
      child: Chip(
        label: Text(topic),
        backgroundColor: Colors.blue,
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
*/

/*   Feedmain wowrking page - before debate shedule and list lask
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/setting_page.dart';


class FeedMain extends StatefulWidget {
  // runApp(FeedMain());
  _FeedMain createState() => _FeedMain();
}

// ignore: use_key_in_widget_constructors
class _FeedMain extends  State<FeedMain> {
  final User? user = Auth().currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? username;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  void fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          username = userData['username'];
          // _profilePicUrl = userData['profile_pic'] ?? 'https://firebasestorage.googleapis.com/v0/b/gptt-6ae89.appspot.com/o/profile_pictures%2FProfile-PNG-File.png?alt=media&token=30c471f4-85b0-48b3-bde8-477364a329c5';
        });
      }
    }
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // backgroundColor: const Color.fromARGB(255, 10, 75, 129),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          automaticallyImplyLeading: false, // Remove default leading icon
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side of the header
              //menu drawer
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              //right side
              Image.asset(
                'assets/nexo_logo.png',
                height: dheight * 0.5,
                width: dwidth * 0.5,
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 75, 129),
                ),
                child: Text(
                  'Hii, $username' ?? 'Hii, User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('About Us'),
                onTap: () {
                  Get.to(
                    () => AboutUs(),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Get.to(() => Settings_tab());
                },
              ),
              ListTile(
                leading: Icon(Icons.logout_sharp),
                title: Text('Log Out'),
                onTap: () {
                  signOut();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending Debates',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildDebateCard('Debate Topic 1', 'Host: User1'),
                      _buildDebateCard('Debate Topic 2', 'Host: User2'),
                      _buildDebateCard('Debate Topic 3', 'Host: User3'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Featured Topics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    _buildTopicChip('Politics'),
                    _buildTopicChip('Technology'),
                    _buildTopicChip('Science'),
                    _buildTopicChip('Entertainment'),
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

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('NexoDeb8'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trending Debates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildDebateCard('Debate Topic 1', 'Host: User1'),
                  _buildDebateCard('Debate Topic 2', 'Host: User2'),
                  _buildDebateCard('Debate Topic 3', 'Host: User3'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Featured Topics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _buildTopicChip('Politics'),
                _buildTopicChip('Technology'),
                _buildTopicChip('Science'),
                _buildTopicChip('Entertainment'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDebateCard(String topic, String host) {
  return Card(
    elevation: 3,
    margin: EdgeInsets.only(right: 10),
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
          Text(host),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Join'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTopicChip(String topic) {
  return Chip(
    label: Text(topic),
    backgroundColor: Colors.blue,
    labelStyle: TextStyle(color: Colors.white),
  );
}
*/
