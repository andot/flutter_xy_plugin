import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_xy_plugin/flutter_xy_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  String _value = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    XyController(
      "5C3DD65A809B08A2D6CF3DEFBC7E09C7",
      type: Type.Splash,
      onCreated: (controller) {
        controller.load();
      },
      onLoaded: (controller) {
        controller.show();
      },
    );
//    String value;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      value = (await FlutterXyPlugin.landingPageDisplayActionBarEnabled).toString();
//    } on PlatformException {
//      value = 'ooxx.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _value = value;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('新义互联广告 SDK Flutter 插件演示'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    height: 80,
                    child: XyView(
//                      id : "209A03F87BA3B4EB82BEC9E5F8B41383",
                      onCreated: (view) {
                        view.load("209A03F87BA3B4EB82BEC9E5F8B41383");
                      },
                      onLoaded: (view) {
                        view.show();
                      },
                      onImpressionFinished: (view) {
                        print(
                            "onImpressionFinished: 209A03F87BA3B4EB82BEC9E5F8B41383");
                      },
                    )),
                Container(
                    height: 80,
                    child: XyView(
                      id : "96753DCF925E8DC7C105B3D3ED1138EA",
//                      onCreated: (view) {
//                        view.load("96753DCF925E8DC7C105B3D3ED1138EA");
//                      },
//                      onLoaded: (view) {
//                        view.show();
//                      },
                      onImpressionFinished: (view) {
                        print(
                            "onImpressionFinished: 96753DCF925E8DC7C105B3D3ED1138EA");
                      },
                    )),
                RaisedButton(
                    child: const Text('Show Interstitial Ad'),
                    onPressed: () {
                      XyController(
                        "2EF810225D10260506CBB704C96C5325",
                        type: Type.Interstitial,
                        onCreated: (controller) {
                          controller.load();
                        },
                        onLoaded: (controller) {
                          controller.show();
                        },
                      );
                    }),
                RaisedButton(
                    child: const Text('Show RewardedVideo Ad'),
                    onPressed: () {
                      XyController(
                        "527E187C5DEA600C35309759469ADAA8",
                        type: Type.RewardedVideo,
                        onCreated: (controller) {
                          controller.load();
                        },
                        onLoaded: (controller) {
                          controller.show();
                        },
                      );
                    }),
              ].map((Widget button) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: button,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
