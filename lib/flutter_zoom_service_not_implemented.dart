import 'dart:async';
import 'dart:ui';

import 'package:flutter_zoom/flutter_zoom_service.dart';

class ZoomServiceNotImplemented extends ZoomService {

  @override
  void initPlugin() {
  }

  @override
  Future<bool> initSDK({ required String domain, String appGroupId = '' }) async {
    return false;
  }

  @override
  Future<bool> initAuthWithSDKTokens({ required String clientSecret, required String clientKey }) async {
    return false;
  }

  @override
  Future<bool> initAuthWithJWT({ required String jwt }) async {
    return false;
  }

  @override
  Future<bool> logout() async {
    return false;
  }

  @override
  Future<int> getUserType() async {
    return -1;
  }

  @override
  Future<bool> isLoggedIn() async {
    return false;
  }

  @override
  Future<bool> initMeetingService(bool useCustomUI) async {
    return false;
  }

  @override
  Future<int> startMeeting({
        required String meetingNumber,
      }) async {
    return -1;
  }

  @override
  Future<int> startMeetingApiUser({
        required String userName,
        required String userId,
        required String zak,
        required String meetingNumber,
      }) async {
    return -1;
  }

  @override
  Future<int> joinMeeting({
        required String userName,
        required String meetingNumber,
      }) async {
    return -1;
  }

  @override
  Future<int> joinMeetingWithPassword({
        required String userName,
        required String password,
        required String meetingNumber,
      }) async {
    return -1;
  }

  @override
  Future<int> handleZoomWebURL({ required String url, }) async {
    return -1;
  }

  @override
  Future<void> stopMeeting() async {
  }

  @override
  Future<void> leaveMeeting() async {
  }

  @override
  Future<int> getMeetingState() async {
    return -1;
  }

  @override
  Future<Map<String, bool>> getMeetingSettings() async {
    return <String, bool>{};
  }

  @override
  Future<void> setMeetingSettings({ required Map<String, bool> settings }) async {
  }

  @override
  Future<bool> changeName({ required String name, required int userId }) async {
    return false;
  }

  @override
  Future<bool> connectAudio(bool connect) async {
    return false;
  }

  @override
  Future<int> muteAudio(bool mute) async {
    return -1;
  }

  @override
  Future<bool> isAudioMuted() async {
    return true;
  }

  @override
  Future<int> muteVideo(bool mute) async {
    return -1;
  }

  @override
  Future<bool> isVoIPSupported() async {
    return false;
  }

  @override
  Future<bool> isVideoMuted() async {
    return true;
  }

  @override
  Future<bool> rotateMyVideo(int orientation) async {
    return false;
  }

  @override
  Future<Size> getUserVideoSize(int userId) async {
    return Size.zero;
  }

  @override
  Future<bool> switchCamera() async {
    return false;
  }

  @override
  Future<String> getMeetingURL() async {
    return '';
  }

  @override
  Future<String> getMeetingPassword() async {
    return '';
  }

  @override
  Future<int> getMyUserId() async {
    return 0;
  }

  @override
  Future<int> getActiveUserId() async {
    return 0;
  }

  @override
  Future<List<int>> getAllUserIds() async {
    return <int>[];
  }

  @override
  Future<ZoomUserInfo> getUserInfo(int userId) async {
    return const ZoomUserInfo();
  }

  @override
  Future<bool> startAppShare() async {
    return false;
  }

  @override
  Future<bool> stopAppShare() async {
    return false;
  }

  @override
  Future<bool> lockShare(bool lock) async {
    return false;
  }

  @override
  Future<bool> isShareLocked() async {
    return true;
  }

  @override
  Future<bool> startAnnotation() async {
    return false;
  }

  @override
  Future<bool> clearAnnotation() async {
    return false;
  }

  @override
  Future<bool> stopAnnotation() async {
    return false;
  }

  @override
  Future<bool> startDialOut(String phone, String name) async {
    return false;
  }

  @override
  Future<bool> endDialOut(int userid) async {
    return false;
  }

  @override
  Future<bool> isAnnotating() async {
    return false;
  }

}

