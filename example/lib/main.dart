import 'package:flutter/material.dart';

import 'package:um_share_plugin/um_share_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    UMSharePlugin.init('UM appKey');
    UMSharePlugin.setPlatform(platform:UMSocialPlatformType_QQ, appKey: 'QQ AppKey');
  }
  String textStr = 'Tap to login';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(onTap:()async{
            UMShareUserInfo info = await UMSharePlugin.getUserInfoForPlatform(UMSocialPlatformType_QQ);
            setState(() {
              if(info.error == null){
                textStr = 'hello ${info.name}';
              }else{
                textStr = info.error??'';
              }
            });
          },child: Text(textStr)),
        ),
      ),
    );
  }
}

