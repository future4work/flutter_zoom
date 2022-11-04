import 'dart:async';
import 'dart:ui';

class ZoomUserInfo {

  final bool isMySelf;
  final String customerKey;
  final String userName;
  final String avatarPath;
  final int unread;
  final bool isVideoReceiving;
  final bool isVideoSending;
  final bool isVideoSource;
  final bool isAudioMuted;
  final bool isAudioTalking;
  final int audioType;

  final bool handRaised;
  final bool inWaitingRoom;
  final bool isCohost;
  final bool isHost;
  final bool isH323User;
  final bool isPureCallInUser;
  final bool isSharingPureComputerAudio;
  final int feedbackType;
  final int userRole;
  final bool isInterpreter;
  final String interpreterActiveLanguage;

  const ZoomUserInfo({
    this.isMySelf = false,
    this.customerKey = '',
    this.userName = '',
    this.avatarPath = '',
    this.unread = 0,
    this.isVideoReceiving = false,
    this.isVideoSending = false,
    this.isVideoSource = false,
    this.isAudioMuted = false,
    this.isAudioTalking = false,
    this.audioType = -1,

    this.handRaised = false,
    this.inWaitingRoom = false,
    this.isCohost = false,
    this.isHost = false,
    this.isH323User = false,
    this.isPureCallInUser = false,
    this.isSharingPureComputerAudio = false,
    this.feedbackType = -1,
    this.userRole = -1,
    this.isInterpreter = false,
    this.interpreterActiveLanguage = '',
  });

  static ZoomUserInfo fromJson(Map<String, dynamic> json) {
    return ZoomUserInfo(
      isMySelf: (json['isMySelf'] as bool?) ?? false,
      customerKey: (json['customerKey'] as String?) ?? '',
      userName: (json['userName'] as String?) ?? '',
      avatarPath: (json['avatarPath'] as String?) ?? '',
      unread: (json['unread'] as int?) ?? 0,
      isVideoReceiving: (json['isVideoReceiving'] as bool?) ?? false,
      isVideoSending: (json['isVideoSending'] as bool?) ?? false,
      isVideoSource: (json['isVideoSource'] as bool?) ?? false,
      isAudioMuted: (json['isAudioMuted'] as bool?) ?? false,
      isAudioTalking: (json['isAudioTalking'] as bool?) ?? false,
      audioType: (json['audioType'] as int?) ?? -1,
      handRaised: (json['handRaised'] as bool?) ?? false,
      inWaitingRoom: (json['inWaitingRoom'] as bool?) ?? false,
      isCohost: (json['isCohost'] as bool?) ?? false,
      isHost: (json['isHost'] as bool?) ?? false,
      isH323User: (json['isH323User'] as bool?) ?? false,
      isPureCallInUser: (json['isPureCallInUser'] as bool?) ?? false,
      isSharingPureComputerAudio: (json['isSharingPureComputerAudio'] as bool?) ?? false,
      feedbackType: (json['feedbackType'] as int?) ?? -1,
      userRole: (json['userRole'] as int?) ?? -1,
      isInterpreter: (json['isInterpreter'] as bool?) ?? false,
      interpreterActiveLanguage: (json['interpreterActiveLanguage'] as String?) ?? '',
    );
  }

}

abstract class ZoomService {
  void Function()? onAuthExpired;
  void Function(int error)? onAuthReturn;
  void Function(int error)? onLoginResult;
  void Function(int error)? onLogoutReturn;
  void Function(int state)? onMeetingStateChange;
  void Function()? onInitMeetingView;
  void Function()? onDestroyMeetingView;
  void Function(int userId)? onSinkMeetingUserJoin;
  void Function(int userId)? onSinkMeetingUserLeft;
  void Function()? onInMeetingUserUpdated;
  void Function(int userId)? onSinkMeetingVideoStatusChange;
  void Function(int userId)? onSinkMeetingActiveShare;

  void initPlugin();

  Future<bool> initSDK({ required String domain, String appGroupId });

  Future<bool> initAuthWithSDKTokens({ required String clientSecret, required String clientKey });

  Future<bool> initAuthWithJWT({ required String jwt });

  Future<bool> logout();

  Future<String?> fullName();

  Future<int> getUserType();

  Future<bool> isLoggedIn();

  Future<bool> initMeetingService(bool useCustomUI);

  Future<int> startMeeting({ required String meetingNumber });

  Future<int> startMeetingApiUser({
        required String userName,
        required String userId,
        required String zak,
        required String meetingNumber,
      });

  Future<int> joinMeeting({
        required String userName,
        required String meetingNumber,
      });

  Future<int> joinMeetingWithPassword({
        required String userName,
        required String password,
        required String meetingNumber,
      });

  Future<int> handleZoomWebURL({ required String url });

  Future<void> stopMeeting();

  Future<void> leaveMeeting();

  Future<int> getMeetingState();

  Future<Map<String, bool>> getMeetingSettings();

  Future<void> setMeetingSettings({ required Map<String, bool> settings });

  Future<bool> changeName({ required String name, required int userId });

  Future<bool> connectAudio(bool connect);

  Future<int> muteAudio(bool mute);
  Future<bool> isAudioMuted();
  Future<bool> isVoIPSupported();

  Future<int> muteVideo(bool mute);
  Future<bool> isVideoMuted();
  Future<bool> rotateMyVideo(int orientation);
  Future<Size> getUserVideoSize(int userId);

  Future<bool> switchCamera();

  Future<String> getMeetingURL();

  Future<String> getMeetingPassword();

  Future<int> getMyUserId();

  Future<int> getActiveUserId();

  Future<List<int>> getAllUserIds();

  Future<ZoomUserInfo> getUserInfo(int userId);

  Future<bool> startAppShare();

  Future<bool> stopAppShare();

  Future<bool> lockShare(bool lock);

  Future<bool> isShareLocked();

  Future<bool> isAnnotating();

  Future<bool> startAnnotation();

  Future<bool> clearAnnotation();

  Future<bool> stopAnnotation();

  Future<bool> startDialOut(String phone, String name);

  Future<bool> endDialOut(int userid);
}
