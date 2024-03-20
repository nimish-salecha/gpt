//header 2 

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/about_us.dart';
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
            // Left side of the  header
            Image.asset(
              'assets/logo.png',
              height: dheight * 0.1,
              width: dwidth * 0.1,
            ),

            // Right side of the  header
            Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle "Tour" hyperlink text press
                    },
                    child: const Text(
                      'Help',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            16, // Adjust font size for Android headers
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                  ),
                  SizedBox(width: dwidth * 0.025,),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AboutUs());
                    },
                    child: const Text(
                      'About Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            16, // Adjust font size for Android headers
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                  ),
                  SizedBox(width: dwidth * 0.025,),
                ],
              ),
            ),
                                    
            //     // Search icon for search page
            // GestureDetector(
            //           onTap: () {
            //               // Get.to(() => Activity(),);
            //           },
            //           child: Material(    //to use transparent property
            //             color: Colors.transparent,
            //             child: CircleAvatar(
            //               radius: 18,
            //               backgroundColor: Colors.transparent, // Set background color to transparent
            //               child: Icon(
            //                 Icons.search, // Use the bell icon
            //                 size: 32,
            //                 color: Colors.black, // Set the icon color
            //               ),
            //             ),
            //           ),
            //         ),

            //    method 1 for user dashboard redirect
            // GestureDetector(
            //   onTap: () {
            //     Get.to(() => Dashboard(),);
            //     // Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()),);
            //   },
            //   child: Container(
            //     width: kToolbarHeight, // Adjust width as needed
            //     height: kToolbarHeight, // Adjust height as needed
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       image: DecorationImage(
            //         image: NetworkImage(
            //           'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_0.jpg',
            //         ),
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
                //---method 2
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
