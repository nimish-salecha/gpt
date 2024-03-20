//for lower navigator tabs (Home, notificition, profil, etc)
//  --> selected tab content shown on whole screen (wiwth the bottom nav at bottom)
//uses List to switch tabs
//// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gpt/screens/create_debate.dart';
import 'package:gpt/screens/feedmain.dart';
import 'package:gpt/screens/search_page.dart';
import 'package:gpt/variables.dart';
import 'package:gpt/screens/about_us.dart';
import 'package:gpt/screens/activity_bell.dart';
import 'package:gpt/screens/dashboard.dart';
import 'package:gpt/screens/header.dart';
import 'package:gpt/screens/header2.dart';
// import 'package:gpt/screens/homepage.dart';
import 'package:gpt/screens/appbuilder.dart';
import 'package:gpt/widgets/tab_item.dart';
import 'package:gpt/widgets/bottomnavigation.dart';

class Home extends StatefulWidget {
  // final String useruid;
  // const Home({
  //   required this.useruid
  // });
  Home();
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "Feed",
      icon: const Icon(
        Icons.home,
        size: 30,
      ),
      page: FeedMain(),
    ),
    TabItem(
      tabName: "Search",
      icon: const Icon(
        CupertinoIcons.search,
        size: 30,
      ),
      page: Search(),
    ),
    TabItem(
      tabName: "Create",
      icon: const Icon(
        Icons.add,
        size: 30,
      ),
      page: Create_Debate(),
    ),
    TabItem(
      tabName: "Alerts",
      icon: const Icon(
        Icons.notifications,
        size: 30,
      ),
      page: Activity(),
    ),
    TabItem(
      tabName: "Profile",
      icon: const Icon(
        Icons.person,
        size: 30,
      ),
        page: Dashboard(),
      // page: ProfilePage(
      //   uid: FirebaseAuth.instance.currentUser!.uid,
      //   whetherShowArrow: false,
      // ),
    ),
  ];

  HomeState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  void _selectTab(int index) {
    selectedTabIndex = index;
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState!.popUntil((route) => route.isFirst);
    } else {
      FocusManager.instance.primaryFocus
          ?.unfocus(); //added on 10 April; to hide keyboard on tab switching
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(onWillPop: () async {
      final isFirstRouteInCurrentTab =
          !await tabs[currentTab].key.currentState!.maybePop();
      if (isFirstRouteInCurrentTab) {
        // if not on the 'main' tab
        if (currentTab != 0) {
          // select 'main' tab
          _selectTab(0);
          // back button handled by app
          return false;
        }
      }
      // let system handle back button if we're on the first route
      return isFirstRouteInCurrentTab;
    },
        // this is the base scaffold
        // don't put appbar in here otherwise you might end up
        // with multiple appbars on one screen
        // eventually breaking the app
        child: AppBuilder(builder: (context) {
      return Scaffold(
        // indexed stack shows only one child
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation
        bottomNavigationBar: BottomNavigation(
          onSelectTab: _selectTab,
          tabs: tabs,
          currentTab: currentTab,
        ),
      );
    }));
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     print("page resumed : ${widget.useruid}");
  //   } else {
  //     print("page closed : ${widget.useruid}");
  //   }
  // }
}


//-----------------------------------------
// void main() {
//   runApp(Home());
// }

// // ignore: use_key_in_widget_constructors
// class Home extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final dwidth = MediaQuery.of(context).size.width;
//     final dheight = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(
//               kToolbarHeight * 0.9 + 0.15), // Add extra height for the padding
//           child: Container(
//             child: Padding(
//               // This line was added
//               padding: const EdgeInsets.only(top: 0.15), // This line was added
//               child: Header(),
//             ),
//           ),
//         ),
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

//                         SizedBox(
//                           width: dwidth * 0.02,
//                         ),

//                         ///Searchbar
//                         Container(
//                             width: dwidth * 0.45,
//                             height: dheight * 0.043,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: GestureDetector(
//                               onTap: () {
//                                 /////searchbox code
//                               },
//                               child: Row(
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: TextField(
//                                       cursorColor: Colors.black,
//                                       maxLines: 1,
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                       ),
//                                       decoration: InputDecoration(
//                                         hintText: 'Search',
//                                         // fillColor: Colors.red,
//                                         // filled: true,
//                                         hintStyle:
//                                             TextStyle(color: Colors.black),
//                                         border: InputBorder.none,
//                                         contentPadding: EdgeInsets.only(
//                                           left: dwidth * 0.03,
//                                           top: -dwidth * 0.06,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Icon(Icons.search),
//                                   //space b/w search icon and searchbox end
//                                   SizedBox(
//                                     width: dwidth * 0.02,
//                                   )
//                                 ],
//                               ),
//                             ))

//                         // Container(   // new hiya search box but rounded border not comming
//                         //   width: dwidth * 0.45,
//                         //   height: dheight * 0.043,
//                         //   decoration: BoxDecoration(
//                         //     color: Colors.white,
//                         //     borderRadius: BorderRadius.circular(25),
//                         //   ),
//                         //   child: Material(
//                         //     // Wrap the TextField with Material widget
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
//                         //     ),
//                         //   ),
//                         // )
//                       ],
//                     ),
//                     // Right side of the second header
//                     GestureDetector(
//                       onTap: () {
//                           Get.to(() => Activity(),);
//                       },
//                       child: Material(    //to use transparent property
//                         color: Colors.transparent,
//                         child: CircleAvatar(
//                           radius: 18,
//                           backgroundColor: Colors.transparent, // Set background color to transparent
//                           child: Icon(
//                             Icons.notifications, // Use the bell icon
//                             size: 32,
//                             color: Colors.black, // Set the icon color
//                           ),
//                         ),
//                       ),
//                     ),
//                     // const CircleAvatar(
//                     //   radius: 18, //notification / activity
//                     //   backgroundImage: AssetImage('assets/bell.png'),
//                     // ),
//                   ],
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
