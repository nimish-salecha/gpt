// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/activity_bell.dart';
import 'package:gpt/screens/header.dart';
import 'package:gpt/screens/header2.dart';

void main() {
  runApp(Home());
}

// ignore: use_key_in_widget_constructors
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
              kToolbarHeight * 0.9 + 0.15), // Add extra height for the padding
          child: Container(
            child: Padding(
              // This line was added
              padding: const EdgeInsets.only(top: 0.15), // This line was added
              child: Header2(),
            ),
          ),
        ),
        body: Column(
          children: [
            //header 2 or navigations
            Container(
                color: const Color.fromRGBO(76, 175, 80, 1),
                padding: EdgeInsets.symmetric(vertical: dheight * 0.003, horizontal: dwidth * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side of the second header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle "Tour" hyperlink text press
                          },
                          child: const Text(
                            'Tour',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  16, // Adjust font size for Android headers
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                          ),
                        ),
                        SizedBox(
                          width: dwidth * 0.025,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle "About Us" hyperlink text press
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
                        SizedBox(
                          width: dwidth * 0.025,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     // Handle "Help" hyperlink text press
                        //   },
                        //   child: const Text(
                        //     'Help',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize:
                        //           16, // Adjust font size for Android headers
                        //       fontWeight: FontWeight.bold, // Make the text bold
                        //     ),
                        //   ),
                        // ),

                        SizedBox(
                          width: dwidth * 0.02,
                        ),

                        ///Searchbar
                        Container(
                            width: dwidth * 0.45,
                            height: dheight * 0.043,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                /////searchbox code
                              },
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      cursorColor: Colors.black,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        // fillColor: Colors.red,
                                        // filled: true,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                          left: dwidth * 0.03,
                                          top: -dwidth * 0.06,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.search),
                                  //space b/w search icon and searchbox end
                                  SizedBox(
                                    width: dwidth * 0.02,
                                  )
                                ],
                              ),
                            ))

                        // Container(   // new hiya search box but rounded border not comming
                        //   width: dwidth * 0.45,
                        //   height: dheight * 0.043,
                        //   decoration: BoxDecoration(
                        //     color: Colors.white,
                        //     borderRadius: BorderRadius.circular(25),
                        //   ),
                        //   child: Material(
                        //     // Wrap the TextField with Material widget
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         /////searchbox code
                        //       },
                        //       child: Row(
                        //         children: <Widget>[
                        //           Expanded(
                        //             child: TextField(
                        //               cursorColor: Colors.black,
                        //               maxLines: 1,
                        //               style: TextStyle(
                        //                 color: Colors.black,
                        //               ),
                        //               decoration: InputDecoration(
                        //                 hintText: 'Search',
                        //                 hintStyle:
                        //                     TextStyle(color: Colors.black),
                        //                 border: InputBorder.none,
                        //                 contentPadding: EdgeInsets.only(
                        //                   left: dwidth * 0.03,
                        //                   top: -dwidth * 0.06,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           Icon(Icons.search),
                        //           //space b/w search icon and searchbox end
                        //           SizedBox(
                        //             width: dwidth * 0.02,
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                    // Right side of the second header
                    GestureDetector(
                      onTap: () {
                          Get.to(() => Activity(),);
                      },
                      child: Material(    //to use transparent property
                        color: Colors.transparent,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.transparent, // Set background color to transparent
                          child: Icon(
                            Icons.notifications, // Use the bell icon
                            size: 32,
                            color: Colors.black, // Set the icon color
                          ),
                        ),
                      ),
                    ),
                    // const CircleAvatar(
                    //   radius: 18, //notification / activity
                    //   backgroundImage: AssetImage('assets/bell.png'),
                    // ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
