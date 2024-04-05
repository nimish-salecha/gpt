//aagora
//certificate =   adc93ee71c3c4cffa4a40ae646e87c25
// /* trying to develop ui - agora ui kit
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:agora_token_service/agora_token_service.dart';

const appId = '8adade7c65554a28907be8616ffaba5e';

void main() {
  runApp(VideoCall(channelName: 'test'));
}

class VideoCall extends StatefulWidget {
  final String channelName;

  const VideoCall({Key? key, required this.channelName}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient client;
  int? uid; // UID of the local user
  // int uid = 10;

  @override
  void initState() {
    super.initState();
    // Fetch UID from Firebase Authentication
    fetchUidFromFirebase();
  }

  Future<void> fetchUidFromFirebase() async {
    // Fetch UID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = _hashUid(user.uid); // Hash UID to get a numeric representation
      });
      // Initialize Agora client after fetching UID
      initAgora();
    } else {
      // Handle if user is not authenticated
      print("User is not authenticated");
    }
  }

  int _hashUid(String uid) {
    // Hash the UID using SHA-256 to get a numeric representation
    var bytes = utf8.encode(uid);
    var digest = sha256.convert(bytes);
    return int.parse(digest.toString().substring(0, 8), radix: 16);
  }

  void initAgora() async {
    if (uid != null) {
      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appId,
          channelName: widget.channelName,
          tempToken: _generateToken(widget.channelName, uid!),
          uid: uid,
        ),
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ],
      );
      await client.initialize();
      // client.engine.muteLocalAudioStream(true);
    }
  }
  
  String _generateToken(String channelName, int uid) {
        // String token = '007eJxTYBDemDVhZeQRA/YslVm7XX6LGZ8OWndxgeJ/t1P2z0Wn7HdVYLBITElMSTVPNjM1NTVJNLKwNDBPSrUwMzRLS0tMSjRN5fnEndYQyMgwV9GOiZEBAkF8FoaS1OISBgYAL9Ae2g=='; // Generate or fetch token based on channelName and uid
     String appId = '8adade7c65554a28907be8616ffaba5e';
    String appCertificate = 'adc93ee71c3c4cffa4a40ae646e87c25';
    // String channelName = 'test';
    // int uid = 123456; // Integer user ID
    const role = RtcRole.publisher;
    int expirationTimeInSeconds = 3600;

    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    final token = RtcTokenBuilder.build(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      uid: uid.toString(),
      role: role,
      expireTimestamp: privilegeExpiredTs,
    );
    print("Generated Token: $token");
    return token;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              // if (client.agoraConnectionData.uid == 123) // Check if the user is the host
              
              // enableHostControls: true, // Add this to enable host controls

            ),
            AgoraVideoButtons(
              client: client,
              // autoHideButtons: true,
              // autoHideButtonTime: 5,
              // addScreenSharing: true, 
              disconnectButtonChild: IconButton(
                onPressed: () async {
                  await client!.engine.leaveChannel();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
      ),
    );
  }



//   @override 
// Widget build(BuildContext context) { 
//   return MaterialApp( 
//     home: Scaffold( 
//       body: SafeArea( 
//         child: Stack( 
//           children: [ 
//             AgoraVideoViewer(client: client),  
//             AgoraVideoButtons(
//               client: client,
//               // disconnectButtonChild: 
//               // disconnectButtonChild: IconButton(
//               //         onPressed: () async {
//               //           await client!.engine.leaveChannel();
//               //           Navigator.pop(context);
//               //         },
//               //         icon: const Icon(Icons.call_end),
//               //       ),
//             ), 
//           ], 
//         ), 
//       ), 
//     ), 
//   ); 
// }
  
 
}
// */

/* completely working - but without custom ui
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:agora_token_service/agora_token_service.dart';

const appId = '8adade7c65554a28907be8616ffaba5e';

void main() {
  runApp(VideoCall(channelName: 'test'));
}

class VideoCall extends StatefulWidget {
  final String channelName;

  const VideoCall({Key? key, required this.channelName}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient client;
  int? uid; // UID of the local user
  // int uid = 10;

  @override
  void initState() {
    super.initState();
    // Fetch UID from Firebase Authentication
    fetchUidFromFirebase();
  }

  Future<void> fetchUidFromFirebase() async {
    // Fetch UID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = _hashUid(user.uid); // Hash UID to get a numeric representation
      });
      // Initialize Agora client after fetching UID
      initAgora();
    } else {
      // Handle if user is not authenticated
      print("User is not authenticated");
    }
  }

  int _hashUid(String uid) {
    // Hash the UID using SHA-256 to get a numeric representation
    var bytes = utf8.encode(uid);
    var digest = sha256.convert(bytes);
    return int.parse(digest.toString().substring(0, 8), radix: 16);
  }

  void initAgora() async {
    if (uid != null) {
      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appId,
          channelName: widget.channelName,
          tempToken: _generateToken(widget.channelName, uid!),
          uid: uid,
        ),
      );
      await client.initialize();
    }
  }
  
  String _generateToken(String channelName, int uid) {
        // String token = '007eJxTYBDemDVhZeQRA/YslVm7XX6LGZ8OWndxgeJ/t1P2z0Wn7HdVYLBITElMSTVPNjM1NTVJNLKwNDBPSrUwMzRLS0tMSjRN5fnEndYQyMgwV9GOiZEBAkF8FoaS1OISBgYAL9Ae2g=='; // Generate or fetch token based on channelName and uid
     String appId = '8adade7c65554a28907be8616ffaba5e';
    String appCertificate = 'adc93ee71c3c4cffa4a40ae646e87c25';
    // String channelName = 'test';
    // int uid = 123456; // Integer user ID
    const role = RtcRole.publisher;
    int expirationTimeInSeconds = 3600;

    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    final token = RtcTokenBuilder.build(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      uid: uid.toString(),
      role: role,
      expireTimestamp: privilegeExpiredTs,
      
    );

    print("Generated Token: $token");
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Debate name'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (uid != null)
                AgoraVideoViewer(
                  client: client,
                  layoutType: Layout.floating,
                  enableHostControls: true, // Add this to enable host controls
                ),
              AgoraVideoButtons(
                client: client,
                 disconnectButtonChild: IconButton(
                onPressed: () async {
                  await client.engine.leaveChannel();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.call_end),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

//----------------------------------------old codes--------------------------------------------------------

/* generate token don- 0 error but not runed ----   with default channel name
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:agora_token_service/agora_token_service.dart';


const appId = '8adade7c65554a28907be8616ffaba5e';
String channelName = 'test';

void main() {
  runApp(VideoCall());
}

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient client;
  int? uid; // UID of the local user
  // int uid = 10;

  @override
  void initState() {
    super.initState();
    // Fetch UID from Firebase Authentication
    fetchUidFromFirebase();
  }

  Future<void> fetchUidFromFirebase() async {
    // Fetch UID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = _hashUid(user.uid); // Hash UID to get a numeric representation
      });
      // Initialize Agora client after fetching UID
      initAgora();
    } else {
      // Handle if user is not authenticated
      print("User is not authenticated");
    }
  }

  int _hashUid(String uid) {
    // Hash the UID using SHA-256 to get a numeric representation
    var bytes = utf8.encode(uid);
    var digest = sha256.convert(bytes);
    return int.parse(digest.toString().substring(0, 8), radix: 16);
  }

  void initAgora() async {
    if (uid != null) {
      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appId,
          channelName: channelName,
          tempToken: _generateToken(channelName, uid!),
          uid: uid,
        ),
      );
      await client.initialize();
    }
  }
  
  String _generateToken(String channelName, int uid) {
        // String token = '007eJxTYBDemDVhZeQRA/YslVm7XX6LGZ8OWndxgeJ/t1P2z0Wn7HdVYLBITElMSTVPNjM1NTVJNLKwNDBPSrUwMzRLS0tMSjRN5fnEndYQyMgwV9GOiZEBAkF8FoaS1OISBgYAL9Ae2g=='; // Generate or fetch token based on channelName and uid
     String appId = '8adade7c65554a28907be8616ffaba5e';
    String appCertificate = 'adc93ee71c3c4cffa4a40ae646e87c25';
    // String channelName = 'test';
    // int uid = 123456; // Integer user ID
    const role = RtcRole.publisher;
    int expirationTimeInSeconds = 3600;

    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    final token = RtcTokenBuilder.build(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      uid: uid.toString(),
      role: role,
      expireTimestamp: privilegeExpiredTs,
      
    );

    print("Generated Token: $token");
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Debate name'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (uid != null)
                AgoraVideoViewer(
                  client: client,
                  layoutType: Layout.floating,
                  enableHostControls: true, // Add this to enable host controls
                ),
              AgoraVideoButtons(
                client: client,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
//////////////////////////////////////////////


/*  update 2 -- all done except token generation
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';

const appId = '8adade7c65554a28907be8616ffaba5e';
String channelName = 'test';

void main() {
  runApp(VideoCall());
}

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient client;
  int? uid; // UID of the local user
  // int uid = 10;

  @override
  void initState() {
    super.initState();
    // Fetch UID from Firebase Authentication
    fetchUidFromFirebase();
  }

  Future<void> fetchUidFromFirebase() async {
    // Fetch UID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = _hashUid(user.uid); // Hash UID to get a numeric representation
      });
      // Initialize Agora client after fetching UID
      initAgora();
    } else {
      // Handle if user is not authenticated
      print("User is not authenticated");
    }
  }

  int _hashUid(String uid) {
    // Hash the UID using SHA-256 to get a numeric representation
    var bytes = utf8.encode(uid);
    var digest = sha256.convert(bytes);
    return int.parse(digest.toString().substring(0, 8), radix: 16);
  }

  void initAgora() async {
    if (uid != null) {
      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appId,
          channelName: channelName,
          tempToken: _generateToken(channelName, uid!),
          uid: uid,
        ),
      );
      await client.initialize();
    }
  }

  String _generateToken(String channelName, int uid) {
    // Your logic to generate a token goes here
    // This is a placeholder logic; replace it with your own token generation logic
    String token = '007eJxTYBDemDVhZeQRA/YslVm7XX6LGZ8OWndxgeJ/t1P2z0Wn7HdVYLBITElMSTVPNjM1NTVJNLKwNDBPSrUwMzRLS0tMSjRN5fnEndYQyMgwV9GOiZEBAkF8FoaS1OISBgYAL9Ae2g=='; // Generate or fetch token based on channelName and uid
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Debate name'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (uid != null)
                AgoraVideoViewer(
                  client: client,
                  layoutType: Layout.floating,
                  enableHostControls: true, // Add this to enable host controls
                ),
              AgoraVideoButtons(
                client: client,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/

// =======================================================================================================

//////working -- agora dcument
/*
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

const appId = '8adade7c65554a28907be8616ffaba5e';
String channelName = 'test';
String token = '007eJxTYOgx9CjX7J1r3ie2qGz631yuhqTXqx9mytQJrVs2c1Yg22QFBovElMSUVPNkM1NTU5NEIwtLA/OkVAszQ7O0tMSkRNPUlqVcaQ2BjAyFs+YzMEIhiM/CUJJaXMLAAAAN6h73';
int uid = 0; // uid of the local user

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: channelName,
      tempToken: token,
      uid: uid,
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  //Build
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora UI Kit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                client: client,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
*/

//old working code but unable to connect in single video call
/*
// ignore_for_file: must_be_immutable

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';


class VideoCall extends StatefulWidget {
  String channelName = "";

  VideoCall({required this.channelName});

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
   late final AgoraClient _client;
  
    @override
  void initState() {
    super.initState();
    _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "8adade7c65554a28907be8616ffaba5e",
      tempToken: "007eJxTYFi46P0sDscTH8IM67KLHG880ueybdsfVRJXNGdqY5+/dKoCg0ViSmJKqnmymampqUmikYWlgXlSqoWZoVlaWmJSomlq3gemtIZARga1zJWsjAwQCOKzMJSkFpcwMAAAQCwfHQ==",
      channelName: widget.channelName,
    ),
    enabledPermission: [Permission.camera,Permission.microphone]
  );

    initAgora();
  }

  void initAgora() async {
    await _client.initialize();
  }

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client:_client,),
            AgoraVideoButtons(client:_client)
          ]
        ),
      ),
    );
  }
}
*/



//-------bing--(agora video call doc...)---- modify your existing code to fetch the token from your Firebase server:
/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoCall extends StatefulWidget {
  String channelName = "";

  VideoCall({required this.channelName});

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient _client;
  String firebaseUrl = ''; // Add the link to your Firebase Cloud Function here
  int uid = 0;
  String token = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> getToken() async {
    final response = await http.get(
      Uri.parse(firebaseUrl + '/generateToken?channelName=' + widget.channelName + '&uid=' + uid.toString()),
    );

    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
        token = jsonDecode(token)['rtcToken'];
      });
      initAgora();
    } else {
      print('Failed to fetch the token');
    }
  }

  void initAgora() async {
    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: "8adade7c65554a28907be8616ffaba5e",
        tempToken: token,
        channelName: widget.channelName,
      ),
      enabledPermission: [Permission.camera, Permission.microphone],
    );
    await _client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(client: _client),
            AgoraVideoButtons(client: _client),
          ],
        ),
      ),
    );
  }
}
*/
