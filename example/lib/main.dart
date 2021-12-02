import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_zendes_plugin/flutter_zendes_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // String _platformVersion = 'Unknown';
  // String _accountKey = '41a747b5-7d23-4876-85bb-89ff555ec0bf';
  // String _applicationId = 'be5a52ed9dbb9f19e38dd4a191b5fa79018c4710dbc5487d';
  // String _clientId = 'mobile_sdk_client_2bb73df48f963be15710';
  // String _domainUrl = 'https://hellojasper.zendesk.com';
  String _platformVersion = 'Unknown';
  String _accountKey = '60fe70d1-f341-4b3e-898d-0a87d9043d3d';
  String _applicationId = 'dcc73c89a0d6c3c05de0729f05d9c78bc867ca164e743ee6';
  String _clientId = 'mobile_sdk_client_7211ae5f16806b37b91f';
  String _domainUrl = 'https://testdomainmydomaintestetstghhelp.zendesk.com';
  FlutterZendeskPlugin _flutterPlugin = FlutterZendeskPlugin();

  @override
  void initState() {
    super.initState();
      initPlatformState();
  

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _flutterPlugin.changeNavStatusAction(false);
    } else {
      _flutterPlugin.changeNavStatusAction(true);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterZendeskPlugin.platformVersion;
      _flutterPlugin.init(
        _accountKey,
        applicationId: _applicationId,
        clientId: _clientId,
        domainUrl: _domainUrl,
        nameIdentifier: "jjqqqq dd",
        emailIdentifier: "testtest@test.com",
        phone: "123121515",
        name: "HGY iOSsdsd",
        email: "testtest@test.com",
        departmentName: null,
      );
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            Text('Chat status: '),
            RaisedButton(
              onPressed: () async {
                await _flutterPlugin.startChatV1();
              },
              child: Text("Start Chat V1"),
            ),
            RaisedButton(
              onPressed: () async {
                await _flutterPlugin.startChatV2(
                    phone: "17386757655179",
                    name: "HGY New",
                    email: "testtest@test.com",
                    botLabel: "Jasper",
                    departmentName: null, //"Support",
                    endChatSwitch: true,
                    toolbarTitle: "Hey user \$usernme Jasper helloyyyyyy");
              },
              child: Text("Zendesk Messaging"),
            ),
            RaisedButton(
              onPressed: () async {
                await _flutterPlugin.helpCenter().then((value) {});
              },
              child: Text("Help Center"),
            ),
            RaisedButton(
              onPressed: () async {
                await _flutterPlugin.requestListViewAction().then((value) {});
              },
              child: Text("Request List"),
            ),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _flutterPlugin.requestViewAction();
          },
          child: Icon(Icons.chat),
        ),
      ),
    );
  }
}
