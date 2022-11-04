import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_zoom/flutter_zoom_service.dart';


class ZoomServiceIOS extends ZoomService {
  // See ios/Runner/SwiftZoomClientWrapperPlugin.swift and minimal code in AppDelegate.swift
  static const MethodChannel _channel = MethodChannel('flutter-zoom');

  @override
  void initPlugin() {
    _channel.setMethodCallHandler((c) async {
      final args = c.arguments as List? ?? [];
      switch (c.method) {
        case 'onAuthExpired':
          onAuthExpired?.call();
          break;
        case 'onAuthReturn':
          if (args.isNotEmpty)
            onAuthReturn?.call(args[0] as int);
          break;
        case 'onLoginResult':
          if (args.isNotEmpty)
            onLoginResult?.call(args[0] as int);
          break;
        case 'onLogoutReturn':
          if (args.isNotEmpty)
            onLogoutReturn?.call(args[0] as int);
          break;
        case 'onMeetingStateChange':
          if (args.isNotEmpty)
            onMeetingStateChange?.call(args[0] as int);
          break;
        case 'onInitMeetingView':
          onInitMeetingView?.call();
          break;
        case 'onDestroyMeetingView':
          onDestroyMeetingView?.call();
          break;
        case 'onSinkMeetingUserJoin':
          if (args.isNotEmpty)
            onSinkMeetingUserJoin?.call(args[0] as int);
          break;
        case 'onSinkMeetingUserLeft':
          if (args.isNotEmpty)
            onSinkMeetingUserLeft?.call(args[0] as int);
          break;
        case 'onInMeetingUserUpdated':
          onInMeetingUserUpdated?.call();
          break;
        case 'onSinkMeetingVideoStatusChange':
          if (args.isNotEmpty)
            onSinkMeetingVideoStatusChange?.call(args[0] as int);
          break;
        case 'onSinkMeetingActiveShare':
          if (args.isNotEmpty)
            onSinkMeetingActiveShare?.call(args[0] as int);
          break;
      }

      return 0;
    });
  }

  @override
  Future<String?> fullName() async {
    return await _channel.invokeMethod('fullName', []);
  }

  @override
  Future<bool> initSDK({ required String domain, String appGroupId = '' }) async {
    final bool? success = await _channel.invokeMethod('initSDK', [domain, appGroupId]);
    return success ?? false;
  }

  @override
  Future<bool> initAuthWithSDKTokens({ required String clientSecret, required String clientKey }) async {
    final bool? success = await _channel.invokeMethod('initAuthSDKParams', [clientSecret, clientKey]);
    return success ?? false;
  }

  @override
  Future<bool> initAuthWithJWT({ required String jwt }) async {
    final bool? success = await _channel.invokeMethod('initAuthJWTParams', [jwt]);
    return success ?? false;
  }

  @override
  Future<bool> logout() async {
    final bool? success = await _channel.invokeMethod('logout');
    return success ?? false;
  }

  @override
  Future<int> getUserType() async {
    final int? userType = await _channel.invokeMethod('getUserType');
    return userType ?? -1;
  }

  @override
  Future<bool> isLoggedIn() async {
    final bool? loggedIn = await _channel.invokeMethod('isLoggedIn');
    return loggedIn ?? false;
  }

  @override
  Future<bool> initMeetingService(bool useCustomUI) async {
    final bool? success = await _channel.invokeMethod('initMeetingService', [useCustomUI]);
    return success ?? false;
  }

  @override
  Future<int> startMeeting({
        required String meetingNumber,
      }) async {
    final int? error = await _channel.invokeMethod('startMeeting', [meetingNumber]);
    return error ?? -1;
  }

  @override
  Future<int> startMeetingApiUser({
        required String userName,
        required String userId,
        required String zak,
        required String meetingNumber,
      }) async {
    final int? error = await _channel.invokeMethod('startMeetingApiUser', [userName, userId, zak, meetingNumber]);
    return error ?? -1;
  }

  @override
  Future<int> joinMeeting({
        required String userName,
        required String meetingNumber,
      }) async {
    final int? error = await _channel.invokeMethod('joinMeeting', [userName, meetingNumber]);
    return error ?? -1;
  }

  @override
  Future<int> joinMeetingWithPassword({
        required String userName,
        required String password,
        required String meetingNumber,
      }) async {
    final int? error = await _channel.invokeMethod('joinMeetingWithPassword', [userName, password, meetingNumber]);
    return error ?? -1;
  }

  @override
  Future<int> handleZoomWebURL({ required String url, }) async {
    final int? error = await _channel.invokeMethod('handleZoomWebURL', [url]);
    return error ?? -1;
  }

  @override
  Future<void> stopMeeting() async {
    await _channel.invokeMethod('stopMeeting');
  }

  @override
  Future<void> leaveMeeting() async {
    await _channel.invokeMethod('leaveMeeting');
  }

  @override
  Future<int> getMeetingState() async {
    final int? state = await _channel.invokeMethod('getMeetingState');
    return state ?? -1;
  }

  @override
  Future<Map<String, bool>> getMeetingSettings() async {
    return Map<String, bool>.from(await _channel.invokeMethod('getMeetingSettings') as Map);
  }

  @override
  Future<void> setMeetingSettings({ required Map<String, bool> settings }) async {
    await _channel.invokeMethod('setMeetingSettings', settings);
  }

  @override
  Future<bool> changeName({ required String name, required int userId }) async {
    final bool? result = await _channel.invokeMethod('changeName', [name, userId]);
    return result ?? false;
  }

  @override
  Future<bool> connectAudio(bool connect) async {
    final bool? result = await _channel.invokeMethod('connectAudio', [connect]);
    return result ?? false;
  }

  @override
  Future<int> muteAudio(bool mute) async {
    final int? result = await _channel.invokeMethod('muteAudio', [mute]);
    return result ?? -1;
  }

  @override
  Future<bool> isAudioMuted() async {
    final bool? result = await _channel.invokeMethod('isAudioMuted');
    return result ?? true;
  }

  @override
  Future<bool> isVoIPSupported() async {
    final bool? result = await _channel.invokeMethod('isVoIPSupported');
    return result ?? false;
  }

  @override
  Future<int> muteVideo(bool mute) async {
    final int? result = await _channel.invokeMethod('muteVideo', [mute]);
    return result ?? -1;
  }

  @override
  Future<bool> isVideoMuted() async {
    final bool? result = await _channel.invokeMethod('isVideoMuted');
    return result ?? true;
  }

  @override
  Future<bool> rotateMyVideo(int orientation) async {
    final bool? result = await _channel.invokeMethod('rotateMyVideo', [orientation]);
    return result ?? false;
  }

  @override
  Future<Size> getUserVideoSize(int userId) async {
    final List<double>? result = List<double>.from(await _channel.invokeMethod('rotateMyVideo', [userId]) as List);
    if (result == null)
      return Size.zero;
    if (result.length != 2)
      return Size.zero;
    return Size(result[0], result[1]);
  }


  @override
  Future<bool> switchCamera() async {
    final bool? result = await _channel.invokeMethod('switchCamera');
    return result ?? false;
  }

  @override
  Future<String> getMeetingURL() async {
    final String? result = await _channel.invokeMethod('getMeetingURL');
    return result ?? '';
  }

  @override
  Future<String> getMeetingPassword() async {
    final String? result = await _channel.invokeMethod('getMeetingPassword');
    return result ?? '';
  }

  @override
  Future<int> getMyUserId() async {
    final int? result = await _channel.invokeMethod('getMyUserId');
    return result ?? 0;
  }

  @override
  Future<int> getActiveUserId() async {
    final int? result = await _channel.invokeMethod('getActiveUserId');
    return result ?? 0;
  }

  @override
  Future<List<int>> getAllUserIds() async {
    final List<int>? result = List<int>.from(await _channel.invokeMethod('getAllUserIds') as List);
    return result ?? <int>[];
  }

  @override
  Future<ZoomUserInfo> getUserInfo(int userId) async {
    final dict = Map<String, dynamic>.from(await _channel.invokeMethod('getUserInfo', [userId]) as Map);
    return ZoomUserInfo.fromJson(dict);
  }

  @override
  Future<bool> startAppShare() async {
    final bool? result = await _channel.invokeMethod('startAppShare');
    return result ?? false;
  }

  @override
  Future<bool> stopAppShare() async {
    final bool? result = await _channel.invokeMethod('stopAppShare');
    return result ?? false;
  }

  @override
  Future<bool> lockShare(bool lock) async {
    final bool? result = await _channel.invokeMethod('lockShare', [lock]);
    return result ?? false;
  }

  @override
  Future<bool> isShareLocked() async {
    final bool? result = await _channel.invokeMethod('isShareLocked');
    return result ?? true;
  }


  @override
  Future<bool> startAnnotation() async {
    final bool? result = await _channel.invokeMethod('handleStartAnnotation');
    return result ?? false;
  }

  @override
  Future<bool> clearAnnotation() async {
    final bool? result = await _channel.invokeMethod('handleClearAnnotation');
    return result ?? false;
  }

  @override
  Future<bool> stopAnnotation() async {
    final bool? result = await _channel.invokeMethod('handleStopAnnotation');
    return result ?? false;
  }

  @override
  Future<bool> isAnnotating() async {
    final bool? result = await _channel.invokeMethod('handleIsAnnotating');
    return result ?? false;
  }

  @override
  Future<bool> startDialOut(String phone, String name) async {
    final bool? result = await _channel.invokeMethod('handleDialOut', [phone, name]);
    return result ?? false;
  }

  @override
  Future<bool> endDialOut(int userid) async {
    final bool? result = await _channel.invokeMethod('handleEndDialOut', [userid]);
    return result ?? false;
  }
}

class ZoomIOSMeetingView extends StatelessWidget {
  final int userId;

  const ZoomIOSMeetingView({ required this.userId, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String viewType = 'zoom-meeting-view';

    final Map<String, int> creationParams = <String, int>{
      'userId' : userId,
    };

    return UiKitView (
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

class ZoomIOSScreenShareView extends StatelessWidget {
  final int userId;

  const ZoomIOSScreenShareView({ required this.userId, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String viewType = 'zoom-screen-share-view';

    final Map<String, int> creationParams = <String, int>{
      'userId' : userId,
    };

    return UiKitView (
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

