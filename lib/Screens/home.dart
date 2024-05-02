//for lower navigator tabs (Home, notificition, profil, etc)
//  --> selected tab content shown on whole screen (wiwth the bottom nav at bottom)
//uses List to switch tabs
//// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpt/screens/create_debate.dart';
import 'package:gpt/screens/feedmain.dart';
import 'package:gpt/screens/search_page.dart';
import 'package:gpt/variables.dart';
import 'package:gpt/screens/activity_bell.dart';
import 'package:gpt/screens/dashboard.dart';
import 'package:gpt/screens/appbuilder.dart';
import 'package:gpt/widgets/tab_item.dart';
import 'package:gpt/widgets/bottomnavigation.dart';
import 'package:gpt/zego_main.dart';

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
      // page: Zego_main(navigatorKey: GlobalKey<NavigatorState>(),),
      page: DebateSearchPage(),
    ),
    TabItem(
      tabName: "Create",
      icon: const Icon(
        Icons.add,
        size: 30,
      ),
      page: Create_Debate(),
      // page: MyApp(),
    ),  
    // TabItem(
    //   tabName: "Alerts",
    //   icon: const Icon(
    //     Icons.notifications,
    //     size: 30,
    //   ),
    //   page: Activity(),
    // ),
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
