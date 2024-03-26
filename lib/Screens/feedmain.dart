// Main Home Page --  1st feed page

// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt/Services/AuthenticationService.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/header.dart';
import 'package:gpt/screens/header2.dart';
import 'package:gpt/screens/setting_page.dart';

void main() {
  runApp(FeedMain());
}

// ignore: use_key_in_widget_constructors
class FeedMain extends StatelessWidget {

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 75, 129),
        automaticallyImplyLeading: false, // Remove default leading icon
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side of the header
            //menu drawer
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer(); 
              },
            ),
                //right side
            Image.asset(
              'assets/logo.png',
              height: dheight * 0.1,
              width: dwidth * 0.1,
            ),                    
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 10, 75, 129),
              ),
              child: Text(
                'Hii, User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('About Us'),
              onTap: () {
                Get.to(() => AboutUs(),);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Get.to(() => Settings_tab());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp),
              title: Text('Log Out'),
              onTap: () {
                 signOut();
              },
            ),
          ],
        ),
      ),
        //       // appbar logic to user header2 file
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(
        //       kToolbarHeight * 0.9 + 0.15), // Add extra height for the padding
        //   child: Container(
        //     child: Padding(
        //       // This line was added
        //       padding: const EdgeInsets.only(top: 0.15), // This line was added
        //       child: Header2(),
        //     ),
        //   ),
        // ),
        body: Column(
          children: [
            Text("Post login main first feed page")
          ]
        ),

//             //old header 2 now layiut changed and merged with in header2(post login) file
//         body: Column(
//           children: [
//             //header 2 or navigations
//             Container(
//                 color: const Color.fromRGBO(76, 175, 80, 1),
//                 padding: EdgeInsets.symmetric(vertical: dheight * 0.003, horizontal: dwidth * 0.03),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Left side of the second header
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             // Handle "Tour" hyperlink text press
//                           },
//                           child: const Text(
//                             'Tour',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize:
//                                   16, // Adjust font size for Android headers
//                               fontWeight: FontWeight.bold, // Make the text bold
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: dwidth * 0.025,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => AboutUs());
//                           },
//                           child: const Text(
//                             'About Us',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize:
//                                   16, // Adjust font size for Android headers
//                               fontWeight: FontWeight.bold, // Make the text bold
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: dwidth * 0.025,
//                         ),
//                         // GestureDetector(
//                         //   onTap: () {
//                         //     // Handle "Help" hyperlink text press
//                         //   },
//                         //   child: const Text(
//                         //     'Help',
//                         //     style: TextStyle(
//                         //       color: Colors.white,
//                         //       fontSize:
//                         //           16, // Adjust font size for Android headers
//                         //       fontWeight: FontWeight.bold, // Make the text bold
//                         //     ),
//                         //   ),
//                         // ),
// //search box layout main logic
//                         // SizedBox(
//                         //   width: dwidth * 0.02,
//                         // ),
//                         // ///Searchbar
//                         // Container(
//                         //     width: dwidth * 0.45,
//                         //     height: dheight * 0.043,
//                         //     decoration: BoxDecoration(
//                         //       color: Colors.white,
//                         //       borderRadius: BorderRadius.circular(20),
//                         //     ),
//                         //     child: GestureDetector(
//                         //       onTap: () {
//                         //         /////searchbox code
//                         //       },
//                         //       child: Row(
//                         //         children: <Widget>[
//                         //           Expanded(
//                         //             child: TextField(
//                         //               cursorColor: Colors.black,
//                         //               maxLines: 1,
//                         //               style: TextStyle(
//                         //                 color: Colors.black,
//                         //               ),
//                         //               decoration: InputDecoration(
//                         //                 hintText: 'Search',
//                         //                 // fillColor: Colors.red,
//                         //                 // filled: true,
//                         //                 hintStyle:
//                         //                     TextStyle(color: Colors.black),
//                         //                 border: InputBorder.none,
//                         //                 contentPadding: EdgeInsets.only(
//                         //                   left: dwidth * 0.03,
//                         //                   top: -dwidth * 0.06,
//                         //                 ),
//                         //               ),
//                         //             ),
//                         //           ),
//                         //           Icon(Icons.search),
//                         //           //space b/w search icon and searchbox end
//                         //           SizedBox(
//                         //             width: dwidth * 0.02,
//                         //           )
//                         //         ],
//                         //       ),
//                         //     )
//                              )                    
//                       ],
//                     ),
//                         //used for activity--notification
//                     // Right side of the second header
//                     // GestureDetector(
//                     //   onTap: () {
//                     //       // Get.to(() => Activity(),);
//                     //   },
//                     //   child: Material(    //to use transparent property
//                     //     color: Colors.transparent,
//                     //     child: CircleAvatar(
//                     //       radius: 18,
//                     //       backgroundColor: Colors.transparent, // Set background color to transparent
//                     //       child: Icon(
//                     //         Icons.notifications, // Use the bell icon
//                     //         size: 32,
//                     //         color: Colors.black, // Set the icon color
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 )),
//           ],
//         ),
      ),
    );
  }
}
