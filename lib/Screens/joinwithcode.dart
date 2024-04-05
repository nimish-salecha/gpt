// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/zego/live_page.dart';
import 'package:gpt/video_call.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:gpt/screens/zego/constants.dart';


class JoinWithCode extends StatefulWidget {
  @override
  State<JoinWithCode> createState() => _JoinWithCodeState();
}

class _JoinWithCodeState extends State<JoinWithCode> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  child: Icon(Icons.arrow_back_ios_new_sharp, size: 35),
                  onTap: Get.back,
                ),
              ),
              SizedBox(height: dheight*0.03),
              Image.network(
                "https://user-images.githubusercontent.com/67534990/127776450-6c7a9470-d4e2-4780-ab10-143f5f86a26e.png",
                fit: BoxFit.cover,
                height: dheight*0.22,
              ),
              SizedBox(height: dheight*0.03),
              Text(
                "Enter debate code below",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Card(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Example : "),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Get.to(() => VideoCall(channelName: _controller.text.trim()));
                   if (ZegoUIKitPrebuiltLiveStreamingController()
                    .minimize
                    .isMinimizing) {
                  /// when the application is minimized (in a minimized state),
                  /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                  return;
                }

                jumpToLivePage(
                  context,
                  liveID: _controller.text.trim(),
                  isHost: false,
                );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(dwidth*0.4, dheight*0.08),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: Text("Join"),
              ),
            ],
          ),
        ),
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
}

