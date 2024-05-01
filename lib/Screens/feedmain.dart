//v4 --- 29apr  1 30pm

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/dashboard.dart';
import 'package:gpt/screens/setting_page.dart';
import 'package:gpt/screens/debate_details.dart'; // Import the debate details page

class FeedMain extends StatefulWidget {
  _FeedMain createState() => _FeedMain();
}

class _FeedMain extends State<FeedMain> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedTopic = 'Politics';
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


// sign out code that Clear User-Specific Data on Logout:
Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Clear user-specific data
    setState(() {
      currentUser = null;
      currentUserId = '';
      username = null;
      // _profilePicUrl = null;
    });
    // Navigate to the login screen or any other screen as needed
    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print('Error signing out: $e');
  }
}


//working just to sign out
  // Future<void> signOut() async {
  //   await Auth().signOut();
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(195, 32, 32, 70),
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
                  signOut(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(195, 32, 32, 70),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trending Debates',
                    style: TextStyle( color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('debates').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final debates = snapshot.data!.docs;
                        // Limit the number of cards shown in the trending debates column to 4
                        final trendingDebates = debates.take(5).toList();
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingDebates.length,
                          itemBuilder: (context, index) {
                            final debate = trendingDebates[index];
                            final debateTopic = debate['title'];
                            final debateHost =
                                debate['userId']; // Fetching host ID
                            // final debateHost = _auth.currentUser?.displayName ??
                            //     'Unknown'; // Assuming displayName is the host
                            final debateId = debate.id; // Fetching debate ID
            
                            return _buildTrendingDebateCard(
                                debateTopic, debate['description'], debateHost, debateId);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Featured Topics',
                    style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
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
                      style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
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
                                  _buildDebateCard(context,
                                      debate['title'], debate['description'], debate['userId'], debate.id),
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
      ),
    );
  }


  Widget _buildTrendingDebateCard(String topic,String desp, String host, String debateId) {
    return InkWell(
      onTap: () {
        Get.to(() => DebateDetailsPage(
              debateId: debateId,
              dtitle: '',
            ));
      },
      child: Card(
        elevation: 5,
        color: Color.fromARGB(255, 32, 32, 70),
        margin: EdgeInsets.only(right: 10),
        child: SingleChildScrollView(
          child: Container(
            width: 200, // Set the width of the card
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String?>(
                      future: _getThumbnailUrl(debateId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        } else {
                          final thumbnailUrl = snapshot.data;
                          return thumbnailUrl != null
                              ? Image.network(
                                  thumbnailUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 135.0,
                                )
                              : Image.asset(
                                  'assets/category/debate.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 135.0,
                                );
                        }
                      },
                    ),
                  Text(
                    topic,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(height: 5),
                  // FutureBuilder(
                  //   future: _getUserName(host), // Fetch host name asynchronously
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return Text('Hosted by: Loading...');
                  //     } else if (snapshot.hasData) {
                  //       return Text('Hosted by ${snapshot.data}');
                  //     } else {
                  //       return Text('');
                  //     }
                  //   },
                  // ),
                  // SizedBox(height: 5),
                  // Text(desp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<String?> _getThumbnailUrl(String debateId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('debates')
          .doc(debateId)
          .get();
      final data = snapshot.data();
      if (data != null && data.containsKey('_thumbnailUrl')) {
        return data['_thumbnailUrl'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching thumbnail URL: $e');
      return null;
    }
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
          backgroundColor: Colors.cyan[600],
          labelStyle: TextStyle(color: const Color.fromARGB(255, 14, 5, 5)),
        ),
      ),
    );
  }
}

Widget _buildDebateCard(context,String topic,String desp, String host, String debateId) {
  return InkWell(
      onTap: () {
        Get.to(() => DebateDetailsPage(
              debateId: debateId,
              dtitle: '',
            ));
      },
  child: Card(
  elevation: 5,
  color: Color.fromARGB(255, 32, 32, 70),
  margin: EdgeInsets.only(right: 10),
  child: Container(
    width: MediaQuery.of(context).size.width, // Set the width to the width of the device
    child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          // FutureBuilder(
          //   future: _getUserName(host),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Text('Host: Loading...');
          //     } else {
          //       return Text('Host: ${snapshot.data}');
          //     }
          //   },
          // ),
          SizedBox(height: 5),
                Text(desp,
                    style: TextStyle(color: Colors.white70),
                  ),

        //join button
              // SizedBox(height: 5),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {},
              //       child: Text('Join'),
              //     ),
              //   ],
              // ),
        ],
      ),
    ),
  ),
)

  );
}



Future<String> _getUserName(String userId) async {
  try {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userSnapshot['username'];
  } catch (e) {
    print('Error fetching username: $e');
    return 'Unknown';
  }
}


// Main Home Page --  1st feed page
/*//v3 with single debate card
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/setting_page.dart';
import 'package:gpt/screens/debate_details.dart'; // Import the debate details page

class FeedMain extends StatefulWidget {
  _FeedMain createState() => _FeedMain();
}

class _FeedMain extends State<FeedMain> {
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
          backgroundColor: Color.fromARGB(255, 32, 32, 70),
           iconTheme: IconThemeData(color: Color.fromARGB(255, 254, 99, 61)),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 32, 32, 70),
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
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Color.fromARGB(255, 32, 32, 70),   
         ///from body till here code is to fill empty bkg space
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 32, 32, 70), // Background color of the body
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trending Debates',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 254, 99, 61)),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _firestore.collection('debates').snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                final debates = snapshot.data!.docs;
                                // Limit the number of cards shown in the trending debates column to 4
                                final trendingDebates = debates.take(4).toList();
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: trendingDebates.length,
                                  itemBuilder: (context, index) {
                                    final debate = trendingDebates[index];
                                    final debateTopic = debate['title'];
                                    final debateHost = _auth.currentUser?.displayName ??
                                        'Unknown'; // Assuming displayName is the host
                                    final debateId = debate.id; // Fetching debate ID
                    
                                    return _buildTrendingDebateCard(
                                        debateTopic, debateHost, debateId);
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Featured Topics',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 254, 99, 61)),
                          ),
                          SizedBox(height: 10),
                          // Featured topics
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildTopicChip('POLITICS'),
                                _buildTopicChip('RELIGIOUS'),
                                _buildTopicChip('SCIENCE AND TECHNOLOGY'),
                                _buildTopicChip('SOCIAL ISSUES'),
                                _buildTopicChip('ENTERTAINMENT'),
                                _buildTopicChip('ENVIRONMENT'),
                                _buildTopicChip('EDUCATION'),
                                _buildTopicChip('HEALTH AND WELLNESS'),
                                _buildTopicChip('SPORTS'),
                                _buildTopicChip('BUSINESS AND ECONOMY'),
                
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          // Debates by selected topic
                          if (selectedTopic != null) ...[
                            Text(
                              'Debates on $selectedTopic',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 254, 99, 61)),
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
                          // if (selectedTopic == null) ...[
                          //   Expanded(
                          //     child: Container(
                          //       color: Color.fromARGB(255, 32, 32, 70), 
                          //     ),
                          //   )
                          // ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingDebateCard(String topic, String host, String debateId) {
    return InkWell(
      onTap: () {
        Get.to(() => DebateDetailsPage(debateId: debateId, dtitle:topic));
        // Get.to(() => AboutUs());
        // print("fdfd");
      },
      child: Card(
        elevation: 3,
        // color: Color.fromARGB(255, 251, 202, 249),
        color: Color.fromARGB(255, 104, 175, 76),

        margin: EdgeInsets.only(right: 10),
        child: Container(
          width: 200, // Set the width of the card
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
                Text('Host: $host'),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
// /* original -without box shadow
  Widget _buildTopicChip(String topic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0), // Add horizontal padding
      child: GestureDetector(
        onTap: () {
          fetchDebatesByTopic(topic);
        },
        child: Chip(
          label: Text(
            topic.toUpperCase(),
            style: TextStyle(color: Colors.white), // Change text color here
          ),
          //Text(topic),
          backgroundColor:  Color.fromARGB(167, 32, 32, 70),
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
// */

Widget _buildDebateCard(String topic, String host) {
  return Card(
    elevation: 3,
    color: Color.fromARGB(255, 245, 14, 14),
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
*/

/*//V2 -- before hiya added Debate_Details.dart
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
*/

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
