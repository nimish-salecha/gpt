// Dart imports:

import 'package:flutter/material.dart';
import 'screens/zego/homepage.dart';
// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final navigatorKey = GlobalKey<NavigatorState>();

  ZegoUIKit().initLog().then((value) {
    runApp(Zego_main(
      navigatorKey: navigatorKey,
    ));
  });
}

class Zego_main extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Zego_main({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<Zego_main> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
      navigatorKey: widget.navigatorKey,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,

            /// support minimizing
            ZegoUIKitPrebuiltLiveStreamingMiniOverlayPage(
              contextQuery: () {
                return widget.navigatorKey.currentState!.context;
              },
            ),
          ],
        );
      },
    );
  }
}