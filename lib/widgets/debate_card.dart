// /*// nimish  - working all except delete card refresh
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpt/screens/edit_debate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gpt/screens/zego/live_page.dart';
import 'package:gpt/screens/zego/constants.dart';
import 'package:intl/intl.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class DebateCard extends StatefulWidget {
  final QueryDocumentSnapshot debate;
  final String hostName;
  

  const DebateCard({
    Key? key,
    required this.debate,
    required this.hostName,
  }) : super(key: key);

  @override
  State<DebateCard> createState() => _DebateCardState();
}

class _DebateCardState extends State<DebateCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLiveEnabled =
      false; // Add a boolean to track whether the "Go live" button should be enabled

  @override
  void initState() {
    super.initState();
// enable go live button 20minutes before the shedule time only
    final scheduledDateTime =
        (widget.debate['scheduledDateTime'] as Timestamp).toDate();
    final currentTimePlus20min = DateTime.now().add(Duration(minutes: 20));
    // Check if current time is after scheduled time
    if (currentTimePlus20min.isAfter(scheduledDateTime)) {
      setState(() {
        isLiveEnabled =
            true; // Enable the button if current time is after scheduled time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    // Extracting date and time
    final DateTime scheduledDateTime =
        (widget.debate['scheduledDateTime'] as Timestamp).toDate();
    final String scheduledDate =
        DateFormat('MM/dd/yy').format(scheduledDateTime);
    final String scheduledTime =
        DateFormat('HH:mm:ss').format(scheduledDateTime);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.debate['title'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scheduled Date: $scheduledDate'),
                Text('Scheduled Time: $scheduledTime'),
                const SizedBox(height: 5),
                Text('Age>: ${widget.debate['age']}'),
                Text('Description: ${widget.debate['description']}'),
                Text('Category: ${widget.debate['category'] ?? 'No category'}'),
                Text('Meeting Code : ${widget.debate['joincode']}'),
                Text('Privacy: ${widget.debate['privacy'] ?? 'No privacy'}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    // Enable/disable the button based on the isLiveEnabled flag
                    onPressed: isLiveEnabled
                        ? () {
                            if (ZegoUIKitPrebuiltLiveStreamingController()
                                .minimize
                                .isMinimizing) {
                              return;
                            }
                            jumpToLivePage(
                              context,
                              liveID: widget.debate['joincode'].trim(),
                              isHost: true,
                            );
                          }
                        : null, // Disable button if not enabled
                    child: const Text('Go live'),
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _showEditDebateScreen(context, widget.debate);
                    },
                    child: const Icon(Icons.edit),
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    child: const Icon(Icons.delete),
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      Share.share(
                          "Meeting Code : ${widget.debate['joincode']}");
                    },
                    child: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  void _showEditDebateScreen(
      BuildContext context, QueryDocumentSnapshot<Object?> debate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDebateScreen(debate: debate),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Debate?'),
          content: Text('Are you sure you want to delete this debate?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteDebate();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDebate() async {
    try {
      await _firestore.collection('debates').doc(widget.debate.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debate deleted successfully')),
      );
    } catch (e) {
      print('Error deleting debate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete debate')),
      );
    }
  }
}
// */





//==========================================================

/* v1 - without -- not showw past debate card
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gpt/screens/edit_debate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gpt/screens/zego/live_page.dart';
import 'package:gpt/screens/zego/constants.dart';
import 'package:intl/intl.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';


class DebateCard extends StatefulWidget {
  final QueryDocumentSnapshot debate;
  final String hostName;

  const DebateCard({
    Key? key,
    required this.debate,
    required this.hostName,
  }) : super(key: key);

  @override
  State<DebateCard> createState() => _DebateCardState();
}

class _DebateCardState extends State<DebateCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    // Extracting date and time
    final DateTime scheduledDateTime =
        (widget.debate['scheduledDateTime'] as Timestamp).toDate();
    final String scheduledDate =
        DateFormat('MM/dd/yy').format(scheduledDateTime);
    final String scheduledTime =
        DateFormat('HH:mm:ss').format(scheduledDateTime);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.debate['title'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scheduled Date: $scheduledDate'),
                Text('Scheduled Time: $scheduledTime'),
                const SizedBox(height: 5),
                Text('Age>: ${widget.debate['age']}'),
                Text('Description: ${widget.debate['description']}'),
                Text('Category: ${widget.debate['category'] ?? 'No category'}'),
                Text('Meeting Code : ${widget.debate['joincode']}'),
                Text('Privacy: ${widget.debate['privacy'] ?? 'No privacy'}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text('Go live'),
                    onPressed: () {
                      if (ZegoUIKitPrebuiltLiveStreamingController()
                          .minimize
                          .isMinimizing) {
                        return;
                      }
                      jumpToLivePage(
                        context,
                        liveID: widget.debate['joincode'].trim(),
                        isHost: true,
                      );
                    },
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _showEditDebateScreen(context, widget.debate);
                    },
                    child: const Icon(Icons.edit),
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    child: const Icon(Icons.delete),
                  ),
                  SizedBox(width: dwidth * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      Share.share("Meeting Code : ${widget.debate['joincode']}");
                    },
                    child: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  void _showEditDebateScreen(
      BuildContext context, QueryDocumentSnapshot<Object?> debate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDebateScreen(debate: debate),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Debate?'),
          content: Text('Are you sure you want to delete this debate?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteDebate();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDebate() async {
    try {
      await _firestore.collection('debates').doc(widget.debate.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debate deleted successfully')),
      );
    } catch (e) {
      print('Error deleting debate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete debate')),
      );
    }
  }
}
*/