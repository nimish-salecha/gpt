// ignore_for_file: must_be_immutable

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';


class VideoCall extends StatefulWidget {
  String channelName = "test";

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
      tempToken: "007eJxTYBBhm7bW9ZH64iPrVr2Ycu3P4tx37ed/Gc1ifvhsT5fR+VknFRgsElMSU1LNk81MTU1NEo0sLA3Mk1ItzAzN0tISkxJNU1n2/E5tCGRkSHXRZ2ZkgEAQn4WhJLW4hIEBAHoRI0k=",
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


//git code video 6--------------
// class VideoCall extends StatefulWidget {
//   String channelName = "test";

//   VideoCall({required this.channelName});
//   @override
//   _VideoCallState createState() => _VideoCallState();
// }

// class _VideoCallState extends State<VideoCall> {
//   late final AgoraClient _client;
//   bool _loading = true;
//   String tempToken = "";

//   @override
//   void initState() {
//     getToken();
//     super.initState();
//   }

//   Future<void> getToken() async {
//     String link =
//         "https://agora-node-tokenserver-1.davidcaleb.repl.co/access_token?channelName=${widget.channelName}";

//     Response _response = await get(Uri.parse(link));
//     Map data = jsonDecode(_response.body);
//     setState(() {
//       tempToken = data["007eJxTYPj09PaC62dazfMPnXjQkmElJnK/9YxMxLQTq6QFznKJW1xVYLBITElMSTVPNjM1NTVJNLKwNDBPSrUwMzRLS0tMSjRN7ff/mNoQyMigHWnNxMgAgSA+C0NJanEJAwMA3dsgqQ=="];
//     });
//     _client = AgoraClient(
//         agoraConnectionData: AgoraConnectionData(
//           appId: "8adade7c65554a28907be8616ffaba5e",
//           tempToken: tempToken,
//           channelName: widget.channelName,
//         ),
//         enabledPermission: [Permission.camera, Permission.microphone]);
//     Future.delayed(Duration(seconds: 1)).then(
//       (value) => setState(() => _loading = false),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: _loading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Stack(
//                 children: [
//                   AgoraVideoViewer(
//                     client: _client,
//                   ),
//                   AgoraVideoButtons(client: _client)
//                 ],
//               ),
//       ),
//     );
//    ;
//  }
// }