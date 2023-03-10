import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';

class FlutterZendeskPlugin {
  static const MethodChannel _channel = const MethodChannel('flutter_zendes_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    debugPrint('version = "$version"');
    return version;
  }

  Future<bool?> init(String accountKey,
      {required String applicationId,
      required String jwtToken,
      required String clientId,
      required String domainUrl}) async {
    if (applicationId.isEmpty) {
      PackageInfo pi = await PackageInfo.fromPlatform();
      applicationId = '${pi.appName}, v${pi.version}(${pi.buildNumber})';
    }
    debugPrint('Init with applicationId="$applicationId"');
    final bool? result = await _channel.invokeMethod('init', <String, dynamic>{
      'accountKey': accountKey,
      'applicationId': applicationId,
      'clientId': clientId,
      'domainUrl': domainUrl,
      'jwtToken': jwtToken
    });
    debugPrint('Init result ="$result"');
    return result;
  }

  Future<bool> startChatV2({
    String? phone,
    String? name,
    String? email,
    String? botLabel,
    String? toolbarTitle,
    bool? endChatSwitch,
    String? departmentName,
    String? iosToolbarHashColor,
  }) async {
    return await _channel.invokeMethod('startChatV2', <String, dynamic>{
      'phone': phone,
      'email': email,
      'name': name,
      'botLabel': botLabel,
      'toolbarTitle': toolbarTitle,
      'departmentName': departmentName,
      'endChatSwitch': endChatSwitch,
      'iosToolbarHashColor': iosToolbarHashColor,
    });
  }

  Future<bool> resetIdentity() async {
    return await _channel.invokeMethod('resetIdentity', <String, dynamic>{});
  }

  Future<dynamic> startChatV1() async {
    return await _channel.invokeMethod('startChatV1');
  }

  Future<dynamic> helpCenter() async {
    return await _channel.invokeMethod('helpCenter');
  }

  Future<dynamic> requestViewAction() async {
    return await _channel.invokeMethod('requestView');
  }

  Future<dynamic> requestListViewAction() async {
    return await _channel.invokeMethod('requestListView');
  }

  Future<dynamic> changeNavStatusAction(bool isShow) async {
    return await _channel.invokeMethod('changeNavStatus', <String, dynamic>{'isShow': isShow});
  }
}
