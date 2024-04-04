// Main Home Page --  1st feed page

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
/////////////////////////////
//empty feedmain page -- basic prototype -- working
/*
// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/header.dart';
import 'package:gpt/screens/header2.dart';
import 'package:gpt/screens/setting_page.dart';

void main() {
  runApp(FeedMain());
}

// ignore: use_key_in_widget_constructors
class FeedMain extends StatelessWidget {

  final User? user = Auth().currentUser;

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
        backgroundColor: const Color.fromARGB(255, 10, 75, 129),
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
              'assets/logo.png',
              height: dheight * 0.1,
              width: dwidth * 0.1,
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
                'Hii, User',
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
                Get.to(() => AboutUs(),);
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
        //       // appbar logic to user header2 file
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(
        //       kToolbarHeight * 0.9 + 0.15), // Add extra height for the padding
        //   child: Container(
        //     child: Padding(
        //       // This line was added
        //       padding: const EdgeInsets.only(top: 0.15), // This line was added
        //       child: Header2(),
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            Text("Post login main first feed page")
          ]
        ),
    ),
    );
  }
}
*/