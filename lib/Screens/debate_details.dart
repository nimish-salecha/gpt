//v4- used to buld a single debate detail page
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
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
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
        title: Text('${widget.dtitle}' ?? 'Debate Details'),
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
          // String date = debateData['scheduledDateTime'];
          // String host = debateData['userId'];
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
            future: _getHostName(debateData['userId']),
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
                        borderRadius:
                            BorderRadius.circular(10.0), // Add border radius
                      ),
                      child: FutureBuilder<String?>(
                        future: _getImageUrl(), // Future for fetching image URL
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Entertainment':
                                return Image.asset(
                                  'assets/category/entertainment.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Religious':
                                return Image.asset(
                                  'assets/category/relegious.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Social Issues':
                                return Image.asset(
                                  'assets/category/social.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Science and Technology':
                                return Image.asset(
                                  'assets/category/science.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Environment':
                                return Image.asset(
                                  'assets/category/env.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Education':
                                return Image.asset(
                                  'assets/category/edu.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Health and Wellness':
                                return Image.asset(
                                  'assets/category/health.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Sports':
                                return Image.asset(
                                  'assets/category/sports.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              case 'Business and Economy':
                                return Image.asset(
                                  'assets/category/bussiness.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                              default:
                                return Image.asset(
                                  'assets/category/debate.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                );
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.8, // Set the width to 80% of the device width
                        child: ElevatedButton(
                          child: Text(isHost ? 'Start' : 'Join'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
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
                          TextSpan(
                              text: timeString,
                              style: TextStyle(fontWeight: FontWeight.bold)),
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

  String generateSummary(
    String title,
    String category,
    String description,
  ) {
    // Get the current time
    // String currentTime = DateFormat('HH:mm').format(DateTime.now());

    // Generate the detailed summary based on the category
    String summary = '';

    switch (category) {
      case 'Politics':
        //                          Debate: $title
        //                          Start Time: $currentTime
        summary = '''
         Explore the intricacies of political discourse in this engaging debate. From heated exchanges on government policies to insightful analyses of global affairs, participants delve into pressing political issues and propose innovative solutions. Join us as we navigate the complex landscape of political ideologies and strive to shape the future of governance.
      ''';
        break;
      case 'Entertainment':
        summary = '''
         Immerse yourself in the world of entertainment with this captivating debate. From spirited discussions on the latest blockbuster films to lively debates about chart-topping music, participants explore the ever-evolving landscape of entertainment. Join us as we celebrate creativity, diversity, and the power of storytelling in shaping our cultural zeitgeist.
      ''';
        break;
      case 'Religious':
        summary = '''
        Embark on a journey of spiritual discovery with this enlightening debate. From profound reflections on religious beliefs to respectful dialogues about faith traditions, participants engage in meaningful conversations that foster mutual understanding and respect. Join us as we explore the rich tapestry of religious diversity and celebrate the universal values that unite humanity.
      ''';
        break;
      case 'Social Issues':
        summary = '''
        Join the conversation on pressing social issues with this thought-provoking debate. From discussions on human rights and social justice to explorations of environmental sustainability and economic equality, participants delve into the complex challenges facing society today. Join us as we advocate for positive change, challenge entrenched systems, and work towards a more equitable and inclusive world.
      ''';
        break;
      case 'Science and Technology':
        summary = '''
        Delve into the frontiers of science and technology with this stimulating debate. From debates on emerging technologies and their ethical implications to discussions on scientific breakthroughs and their societal impact, participants explore the ever-changing landscape of innovation. Join us as we celebrate human ingenuity, push the boundaries of knowledge, and shape the future of technology.
      ''';
        break;
      case 'Environment':
        summary = '''
        Engage in meaningful discussions on environmental sustainability with this impactful debate. From debates on climate change and biodiversity conservation to conversations about renewable energy and ecological stewardship, participants explore solutions to the pressing environmental challenges of our time. Join us as we advocate for environmental justice, protect our planet's precious ecosystems, and build a more sustainable future for generations to come.
      ''';
        break;
      case 'Education':
        summary = '''
        Join us for an enlightening debate on educational innovation and reform. From discussions on curriculum development and pedagogical approaches to debates on educational equity and access, participants explore the key issues shaping the future of learning. Join us as we reimagine education, empower learners, and build a more equitable and inclusive society through knowledge and learning.
      ''';
        break;
      case 'Health and Wellness':
        summary = '''
        Dive into discussions on health and wellness with this informative debate. From debates on public health policies and healthcare systems to conversations about mental health awareness and holistic well-being, participants explore the multidimensional aspects of human health. Join us as we promote health equity, raise awareness about preventive care, and empower individuals to lead healthier, happier lives.
      ''';
        break;
      case 'Sports':
        summary = '''
        Get in the game with this dynamic debate on sports and athleticism. From discussions on sportsmanship and fair play to debates on the role of sports in society and culture, participants explore the intersections of athleticism, competition, and human achievement. Join us as we celebrate the power of sports to inspire, unite, and transform lives.
      ''';
        break;
      case 'Business and Economy':
        summary = '''
        Join us for an insightful debate on business and economics. From discussions on market trends and economic policies to debates on corporate responsibility and sustainable development, participants explore the complexities of the global economy. Join us as we analyze key issues, propose innovative solutions, and shape the future of business and commerce.
      ''';
        break;
      default:
        summary = '''
         Join us for an engaging debate on various topics. Together, we'll exchange ideas, challenge assumptions, and foster meaningful dialogue.
      ''';
        break;
    }

    return summary;
  }

  Future<String> _getHostName(String hostUserId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(hostUserId)
          .get();

      if (userData.exists) {
        String hostName = userData['username'] ?? 'Unknown';
        return hostName;
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching host username: $e');
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
        Map<String, dynamic>? data =
            debateSnapshot.data() as Map<String, dynamic>?;
        if (data != null) {
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



/*// v3complete working - start/join button not disable after debate and summary not generated
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
            future: _getHostName(debateData['userId']),
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
  /*Fetching current user name instead of hostname
          FutureBuilder(
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
              String host = hostSnapshot.data!.toUpperCase();*/
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

Future<String> _getHostName(String hostUserId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(hostUserId)
        .get();

    if (userData.exists) {
      String hostName = userData['username'] ?? 'Unknown';
      return hostName;
    } else {
      return 'Unknown';
    }
  } catch (e) {
    print('Error fetching host username: $e');
    return 'Unknown';
  }
}
/*Fetching current user name instead of hostname
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
  }*/

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


///================================================

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