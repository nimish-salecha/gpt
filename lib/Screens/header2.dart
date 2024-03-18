//post login

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/dashboard.dart';

void main() {
  runApp(
    MaterialApp(
      home: Header2(),
    ),
  );
}

class Header2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    // print("the width of screen is $dwidth}");
    return Container(
      height: kToolbarHeight,
      width: dwidth,
      child: Container(
        height: kToolbarHeight * 0.9,//dheight * 0.1,
        color: const Color.fromARGB(255, 10, 75, 129),
        padding:  EdgeInsets.fromLTRB(dwidth*0.03, 3, dwidth*0.01, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side of the first header
            Image.asset(
              'assets/logo.png',
              height: dheight * 0.1,
              width: dwidth * 0.1,
            ),
            
            GestureDetector(
              onTap: () {
                Get.to(() => Dashboard(),);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()),);
              },
              child: Container(
                width: kToolbarHeight, // Adjust width as needed
                height: kToolbarHeight, // Adjust height as needed
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_0.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // CircleAvatar(
            //   radius: 50,
            //   backgroundImage: NetworkImage(
            //       'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_0.jpg'),
            // ),               
          ],
        ),
      ),
    );
  }
}
