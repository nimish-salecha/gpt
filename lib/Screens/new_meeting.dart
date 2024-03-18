// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/video_call.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';


class NewMeeting extends StatefulWidget {
  NewMeeting({Key? key}) : super(key: key);

  // var uuid = Uuid();

  @override
  _NewMeetingState createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> {
  String _meetingCode = "abcdfgqw";

  @override
  void initState() {
    var uuid = Uuid();
    _meetingCode = uuid.v1().substring(0, 8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Icon(Icons.arrow_back_ios_new_sharp, size: dheight*0.05),
                onTap: Get.back,
              ),
            ),
            SizedBox(height: dheight*0.1),
            Image.network(
              "https://user-images.githubusercontent.com/67534990/127776392-8ef4de2d-2fd8-4b5a-b98b-ea343b19c03e.png",
              fit: BoxFit.cover,
              height: dheight*0.15,
            ),
            SizedBox(height: dheight*0.02),
            Text(
              "New meeting code below",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(dwidth*0.04, dheight*0.01, dwidth*0.04, 0),
              child: Card(
                  color: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.link),
                    title: SelectableText(
                      _meetingCode,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    trailing: Icon(Icons.copy),
                  )),
            ),
            Divider(thickness: 1, height: 40, indent: 20, endIndent: 20),
            ElevatedButton.icon(
              onPressed: () {
                Share.share("Meeting Code : $_meetingCode");
              },
              icon: Icon(Icons.arrow_drop_down),
              label: Text("Share invite"),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(dwidth*0.9, dheight*0.06),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
            SizedBox(height: dheight*0.03),
            OutlinedButton.icon(
              onPressed: () {
                Get.to(VideoCall(channelName: _meetingCode.trim()));
              },
              icon: Icon(Icons.video_call),
              label: Text("Start Debate"),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 31, 39, 85),
                side: BorderSide(color: Colors.indigo),
                fixedSize: Size(dwidth*0.9, dheight*0.06),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
