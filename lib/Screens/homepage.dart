import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/header.dart';
import 'package:gpt/screens/joinwithcode.dart';
import 'package:gpt/screens/new_meeting.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Conference"),
        centerTitle: true,
      ),
      
      body: Column(children: [
        // Header(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(NewMeeting());
            },
            icon: Icon(Icons.add),
            label: Text("Host Debate"),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(dwidth*0.6, dheight*0.1),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          height: dheight*0.04,
          indent: 40,
          endIndent: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: OutlinedButton.icon(
            onPressed: () {
              Get.to(JoinWithCode());
            },
            icon: Icon(Icons.margin),
            label: Text("Join with a code"),
            style: OutlinedButton.styleFrom(
              primary: Colors.indigo,
              side: BorderSide(color: Colors.indigo),
              fixedSize: Size(dwidth*0.6, dheight*0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        SizedBox(height: dheight*0.15),
        Image.network(
            "https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png")
      ]),
    );
  }
}
