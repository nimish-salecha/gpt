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
      tempToken: "007eJxTYFg1wbSsdg1r0MyJ2ivbf6TnB9VGcvznnuTAHeI48ad1Va0Cg0ViSmJKqnmymampqUmikYWlgXlSqoWZoVlaWmJSommq6p6vqQ2BjAwWaWtZGBkgEMRnYShJLS5hYAAA9fkesg==",
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