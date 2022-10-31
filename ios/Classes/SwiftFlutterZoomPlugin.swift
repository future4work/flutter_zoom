import Flutter
import UIKit
import MobileRTC
import MobileCoreServices

class ZoomCustomMeetingViewController : UIViewController {

  lazy var videoView = MobileRTCVideoView(frame: view.bounds)
  var _userId: UInt = 0

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    videoView.setVideoAspect(MobileRTCVideoAspect_PanAndScan)
    videoView.showAttendeeVideo(withUserID: _userId)

    view.addSubview(videoView)
  }

  func setFrame(frame: CGRect) {
    NSLog("Set frame %f %f %f %f\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
  }

  func setPreview(_ preview : Bool) {
    NSLog("Set preview %i\n", preview)
  }

  func showUser(userId: UInt) {
    NSLog("Show user %u\n", userId)
    _userId = userId
  }

}

class ZoomMeetingView: NSObject, FlutterPlatformView {

  var _viewController: ZoomCustomMeetingViewController

  init(
      frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?,
      binaryMessenger messenger: FlutterBinaryMessenger?) {

    _viewController = ZoomCustomMeetingViewController()

    super.init()

    if let settings = args as? Dictionary<String, NSNumber> {
      let userId = settings["userId"]?.uintValue ?? 0
      setupViewController(userId: userId)
    }

  }

  func view() -> UIView {
    return _viewController.view
  }

  func setupViewController(userId: UInt) {
    _viewController.showUser(userId: userId)
  }

}

class ZoomMeetingViewFactory: NSObject, FlutterPlatformViewFactory {

  var _messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    _messenger = messenger
    super.init()
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    NSLog("Create frame %f %f %f %f\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
    return ZoomMeetingView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: _messenger)
  }

  @objc public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class ZoomScreenShareViewController : UIViewController {

  lazy var videoView = MobileRTCActiveShareView(frame: view.bounds)
  var _userId: UInt = 0

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    videoView.setVideoAspect(MobileRTCVideoAspect_PanAndScan)
    videoView.showActiveShare(withUserID: _userId)

    view.addSubview(videoView)
  }

  func setFrame(frame: CGRect) {
    NSLog("Set frame %f %f %f %f\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
  }

  func setPreview(_ preview : Bool) {
    NSLog("Set preview %i\n", preview)
  }

  func showUser(userId: UInt) {
    NSLog("Show user %u\n", userId)
    _userId = userId
  }

}

class ZoomScreenShareView: NSObject, FlutterPlatformView {

  var _viewController: ZoomScreenShareViewController

  init(
      frame: CGRect,
      viewIdentifier viewId: Int64,
      arguments args: Any?,
      binaryMessenger messenger: FlutterBinaryMessenger?) {

    _viewController = ZoomScreenShareViewController()

    super.init()

    if let settings = args as? Dictionary<String, NSNumber> {
      let userId = settings["userId"]?.uintValue ?? 0
      setupViewController(userId: userId)
    }

  }

  func view() -> UIView {
    return _viewController.view
  }

  func setupViewController(userId: UInt) {
    _viewController.showUser(userId: userId)
  }

}

class ZoomScreenShareViewFactory: NSObject, FlutterPlatformViewFactory {

  var _messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    _messenger = messenger
    super.init()
  }

  func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
    return ZoomScreenShareView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: _messenger)
  }

  @objc public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class ZoomClientWrapperCustomMeetingUIDelegate : NSObject, MobileRTCCustomizedUIMeetingDelegate {

  var _methodChannel: FlutterMethodChannel

  public init(channel: FlutterMethodChannel) {
    _methodChannel = channel
    super.init()
  }

  func onInitMeetingView() {
    _methodChannel.invokeMethod("onInitMeetingView", arguments: nil)
  }

  func onDestroyMeetingView() {
    _methodChannel.invokeMethod("onDestroyMeetingView", arguments: nil)
  }

}

class ZoomClientWrapperAuthDelegate : NSObject, MobileRTCAuthDelegate {

  var _methodChannel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    _methodChannel = channel
    super.init()
  }

  func onMobileRTCAuthExpired() {
    _methodChannel.invokeMethod("onAuthExpired", arguments: nil)
  }

  func onMobileRTCAuthReturn(_ returnValue : MobileRTCAuthError) {
    _methodChannel.invokeMethod("onAuthReturn", arguments: [NSNumber(value: returnValue.rawValue)])
  }

  func onMobileRTCLogoutReturn(_ returnValue : NSInteger) {
    _methodChannel.invokeMethod("onLogoutReturn", arguments: [NSNumber(value: returnValue)])
  }

}

class ZoomClientWrapperMeetingDelegate
    : NSObject,
    MobileRTCMeetingServiceDelegate,
    MobileRTCUserServiceDelegate,
    MobileRTCVideoServiceDelegate,
    MobileRTCShareServiceDelegate {

  var _methodChannel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    _methodChannel = channel
    super.init()
  }

// MEETING CALLBACKS

  func onJBHWaiting(with cmd: JBHCmd) {
    switch (cmd) {
    case .show:
      NSLog("Joined before host")
    case .hide:
      NSLog("Hide joined before host")
    }
  }

  func onRecordingStatus(_ status: MobileRTCRecordingStatus) {
    NSLog("Recording status %i", status.rawValue)
  }

  func onLocalRecordingStatus(_ userId: Int, status: MobileRTCRecordingStatus) {
    NSLog("Local recording status %i", status.rawValue)
  }

  func onCheckCMRPrivilege(_ result: MobileRTCCMRError) {
    NSLog("Checked CMR privilege %i", result.rawValue)
  }

  func onMeetingParameterNotification(_ meetingParam: MobileRTCMeetingParameter?) {
    if let mp = meetingParam {
      NSLog("Meeting parameter %i", mp.meetingType.rawValue)
      if mp.isAutoRecordingCloud {
        NSLog("Cloud recording")
      }
      if mp.isAutoRecordingLocal {
        NSLog("Local recording")
      }
    } else {
      NSLog("Null meeting parameter")
    }
  }

  func onMeetingStateChange(_ state : MobileRTCMeetingState) {
    _methodChannel.invokeMethod("onMeetingStateChange", arguments: [NSNumber(value: state.rawValue)])
  }

  func onWaitingRoomStatusChange(_ needWaiting : Bool) {
    _methodChannel.invokeMethod("onWaitingRoomStatusChange", arguments: [NSNumber(value: needWaiting)])
  }

  func onMeetingEndedReason(_ reason: MobileRTCMeetingEndReason) {
    NSLog("Meeting ended because %i", reason.rawValue)
  }

  func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
    NSLog("Meeting error %i", error.rawValue)
  }

// USER CALLBACKS

  func onMyHandStateChange() {
  }

  func onInMeetingUserUpdated() {
    _methodChannel.invokeMethod("onInMeetingUserUpdated", arguments: nil)
  }

  func onSinkMeetingUserJoin(_ userId: UInt) {
    _methodChannel.invokeMethod("onSinkMeetingUserJoin", arguments: [NSNumber(value: userId)])
  }

  func onSinkMeetingUserLeft(_ userId: UInt) {
    _methodChannel.invokeMethod("onSinkMeetingUserLeft", arguments: [NSNumber(value: userId)])
  }

  func onSinkMeetingUserRaiseHand(_ userID: UInt) {
  }

  func onSinkMeetingUserLowerHand(_ userID: UInt) {
  }

  func onSinkLowerAllHands() {
  }

  func onSinkUserNameChanged(_ userId: UInt, userName: String) {
  }

  func onSinkUserNameChanged(_ userNameChangedArr: [NSNumber]?) {
  }

  func onMeetingHostChange(_ userId: UInt) {
    _methodChannel.invokeMethod("onMeetingHostChange", arguments: [NSNumber(value: userId)])
  }

  func onMeetingCoHostChange(_ userID: UInt) {
  }

  func onMeetingCoHostChange(_ userID: UInt, isCoHost: Bool) {
  }

  func onClaimHostResult(_ error: MobileRTCClaimHostError) {
  }

// VIDEO CALLBACKS

  func onSinkMeetingActiveVideo(_ userID: UInt) {
  }

  func onSinkMeetingVideoStatusChange(_ userID: UInt) {
    _methodChannel.invokeMethod("onSinkMeetingVideoStatusChange", arguments: [NSNumber(value: userID)])
  }

  func onMyVideoStateChange() {
  }

  func onSinkMeetingVideoStatusChange(_ userID: UInt, videoStatus: MobileRTC_VideoStatus) {
  }

  func onSpotlightVideoChange(_ on: Bool) {
  }

  func onSpotlightVideoUserChange(_ spotlightedUserList: [NSNumber]) {
  }

  func onSinkMeetingPreviewStopped() {
  }

  func onSinkMeetingActiveVideo(forDeck userID: UInt) {
  }

  func onSinkMeetingVideoQualityChanged(_ qality: MobileRTCVideoQuality, userID: UInt) {
  }

  func onSinkMeetingVideoRequestUnmute(byHost completion: @escaping (Bool) -> Void) {
  }

  func onSinkMeetingShowMinimizeMeetingOrBackZoomUI(_ state: MobileRTCMinimizeMeetingState) {
  }

  func onHostVideoOrderUpdated(_ orderArr: [NSNumber]?) {
  }

  func onLocalVideoOrderUpdated(_ localOrderArr: [NSNumber]?) {
  }

  func onFollowHostVideoOrderChanged(_ follow: Bool) {
  }

// SCREEN SHARING CALLBACKS

  func onAppShareSplash() {
  }

  func onSinkMeetingActiveShare(_ userID: UInt) {
    _methodChannel.invokeMethod("onSinkMeetingActiveShare", arguments: [NSNumber(value: userID)])
  }

  func onSinkMeetingShareReceiving(_ userID: UInt) {
  }

  func onSinkShareSettingTypeChanged(_ shareSettingType: MobileRTCShareSettingType) {
  }

  func onSinkShareSizeChange(_ userID: UInt) {
  }

  func onSinkSharingStatus(_ status: MobileRTCSharingStatus, userID: UInt) {
  }

}

class ZoomClientWrapperWaitingRoomDelegate : NSObject, MobileRTCWaitingRoomServiceDelegate {

  var _methodChannel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    _methodChannel = channel
    super.init()
  }

  func onWaitingRoomUserJoin(_ userId: UInt) {
    NSLog("User joined waiting room %u\n", userId)
  }

  func onWaitingRoomUserLeft(_ userId: UInt) {
    NSLog("User left waiting room %u\n", userId)
  }

}

public class SwiftFlutterZoomPlugin: NSObject, FlutterPlugin {
  var _authDelegate: ZoomClientWrapperAuthDelegate
  var _meetingDelegate: ZoomClientWrapperMeetingDelegate
  var _customMeetingUIDelegate: ZoomClientWrapperCustomMeetingUIDelegate
  var _waitingRoomDelegate: ZoomClientWrapperWaitingRoomDelegate

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter-zoom", binaryMessenger: registrar.messenger())
    let meetingViewFactory = ZoomMeetingViewFactory(messenger: registrar.messenger())
    let screenShareViewFactory = ZoomScreenShareViewFactory(messenger: registrar.messenger())
    let instance = SwiftFlutterZoomPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(meetingViewFactory, withId: "zoom-meeting-view")
    registrar.register(screenShareViewFactory, withId: "zoom-screen-share-view")
  }

  public init(channel: FlutterMethodChannel) {
    _authDelegate = ZoomClientWrapperAuthDelegate(channel: channel)
    _meetingDelegate = ZoomClientWrapperMeetingDelegate(channel: channel)
    _customMeetingUIDelegate = ZoomClientWrapperCustomMeetingUIDelegate(channel: channel)
    _waitingRoomDelegate = ZoomClientWrapperWaitingRoomDelegate(channel: channel)
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("0.0.1")
    case "initSDK":
      result(handleInitClientSDK(call))
    case "initAuthSDKParams":
      result(handleInitClientAuthSDKParams(call))
    case "initAuthJWTParams":
      result(handleInitClientAuthJWTParams(call))
    case "logout":
      result(handleLogout(call))
    case "getUserType":
      result(handleGetUserType(call))
    case "isLoggedIn":
      result(handleIsLoggedIn(call))
    case "initMeetingService":
      result(handleInitMeetingService(call))
    case "startMeeting":
      result(handleStartMeeting(call))
    case "startMeetingApiUser":
      result(handleStartMeetingApiUser(call))
    case "joinMeeting":
      result(handleJoinMeeting(call))
    case "joinMeetingWithPassword":
      result(handleJoinMeetingWithPassword(call))
    case "handleZoomWebURL":
      result(handleHandleZoomWebURL(call))
    case "stopMeeting":
      result(handleStopMeeting(call))
    case "leaveMeeting":
      result(handleLeaveMeeting(call))
    case "getMeetingState":
      result(handleGetMeetingState(call))
    case "getMeetingSettings":
      result(handleGetMeetingSettings(call))
    case "setMeetingSettings":
      result(handleSetMeetingSettings(call))
    case "connectAudio":
      result(handleConnectAudio(call))
    case "muteAudio":
      result(handleMuteAudio(call))
    case "isAudioMuted":
      result(handleIsAudioMuted(call))
    case "isVoIPSupported":
      result(handleIsVoIPSupported(call))
    case "muteVideo":
      result(handleMuteVideo(call))
    case "isVideoMuted":
      result(handleIsVideoMuted(call))
    case "rotateMyVideo":
      result(handleRotateMyVideo(call))
    case "getUserVideoSize":
      result(handleGetUserVideoSize(call))
    case "switchCamera":
      result(handleSwitchCamera(call))
    case "getMeetingURL":
      result(handleGetMeetingURL(call))
    case "getMeetingPassword":
      result(handleGetMeetingPassword(call))
    case "getMyUserId":
      result(handleGetMyUserId(call))
    case "getActiveUserId":
      result(handleGetActiveUserId(call))
    case "getAllUserIds":
      result(handleGetAllUserIds(call))
    case "getUserInfo":
      result(handleGetUserInfo(call))
    case "changeName":
      result(handleChangeName(call))
    case "startAppShare":
      result(handleStartAppShare(call))
    case "stopAppShare":
      result(handleStopAppShare(call))
    case "lockShare":
      result(handleLockShare(call))
    case "isShareLocked":
      result(handleIsShareLocked(call))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func handleInitClientSDK(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {

      let initContext = MobileRTCSDKInitContext()
      initContext.domain = args[0]
      initContext.appGroupId = args[1]
      initContext.enableLog = true
      initContext.locale = .default

      let bundle = Bundle(identifier: "org.cocoapods.flutter-zoom")
      initContext.bundleResPath = bundle!.bundlePath

      return NSNumber(value: MobileRTC.shared().initialize(initContext))
    }

    return NSNumber(value: false)
  }

  func handleInitClientAuthSDKParams(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      if let auth = MobileRTC.shared().getAuthService() {
        auth.clientSecret = args[0]
        auth.clientKey = args[1]
        auth.delegate = _authDelegate

        auth.sdkAuth()
        return NSNumber(value: true)
      }
    }
    return NSNumber(value: false)
  }

  func handleInitClientAuthJWTParams(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      if let auth = MobileRTC.shared().getAuthService() {
        auth.jwtToken = args[0]
        auth.delegate = _authDelegate

        auth.sdkAuth()

        return NSNumber(value: true)
      }
    }
    return NSNumber(value: false)
  }

  func handleLogout(_ call: FlutterMethodCall) -> NSNumber {
    if let auth = MobileRTC.shared().getAuthService() {
      return NSNumber(value: auth.logoutRTC())
    }
    return NSNumber(value: false)
  }

  func handleGetUserType(_ call: FlutterMethodCall) -> NSNumber {
    if let auth = MobileRTC.shared().getAuthService() {
      return NSNumber(value: auth.getUserType().rawValue)
    }
    return NSNumber(value: -1)
  }

  func handleIsLoggedIn(_ call: FlutterMethodCall) -> NSNumber {
    if let auth = MobileRTC.shared().getAuthService() {
      return NSNumber(value: auth.isLoggedIn())
    }
    return NSNumber(value: false)
  }

  func handleInitMeetingService(_ call: FlutterMethodCall) -> NSNumber {
    let settings = MobileRTC.shared().getMeetingSettings()
    let ms = MobileRTC.shared().getMeetingService()
    let wrs = MobileRTC.shared().getWaitingRoomService()
    if settings == nil || ms == nil || wrs == nil {
      return NSNumber(value: false)
    }

    NSLog("Init meeting service")

    ms?.delegate = _meetingDelegate

    if let args = call.arguments as? Array<NSNumber> {
      if args[0].boolValue {
        settings?.enableCustomMeeting = true
        ms?.customizedUImeetingDelegate = _customMeetingUIDelegate
        wrs?.delegate = _waitingRoomDelegate
      }
    }

    return NSNumber(value: true)
  }

  func handleStartMeeting(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      if let ms = MobileRTC.shared().getMeetingService() {
        let startParam = MobileRTCMeetingStartParam4LoginlUser()
        startParam.meetingNumber = args[0]
        startParam.isAppShare = false
        startParam.noVideo = false
        startParam.noAudio = false

        return NSNumber(value: ms.startMeeting(with: startParam).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleStartMeetingApiUser(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      if let ms = MobileRTC.shared().getMeetingService() {

        let startParam = MobileRTCMeetingStartParam4WithoutLoginUser()
        startParam.userType = MobileRTCUserType.apiUser
        startParam.userName = args[0]
        startParam.userID = args[1]
        startParam.zak = args[2]
        startParam.meetingNumber = args[3]
        startParam.isAppShare = false
        startParam.noVideo = false
        startParam.noAudio = false

        return NSNumber(value: ms.startMeeting(with: startParam).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleJoinMeeting(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      if let ms = MobileRTC.shared().getMeetingService() {
        let joinParam = MobileRTCMeetingJoinParam()
        joinParam.userName = args[0]
        joinParam.password = nil
        joinParam.meetingNumber = args[1]
        joinParam.noAudio = false
        joinParam.noVideo = false

        return NSNumber(value: ms.joinMeeting(with: joinParam).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleJoinMeetingWithPassword(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      if let ms = MobileRTC.shared().getMeetingService() {
        let joinParam = MobileRTCMeetingJoinParam()
        joinParam.userName = args[0]
        joinParam.password = args[1]
        joinParam.meetingNumber = args[2]
        joinParam.noAudio = false
        joinParam.noVideo = false

        return NSNumber(value: ms.joinMeeting(with: joinParam).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleHandleZoomWebURL(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.handZoomWebUrl(args[0]).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleStopMeeting(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
        ms.leaveMeeting(with: LeaveMeetingCmd.end)
    }
    return NSNumber(value: 0)
  }

  func handleLeaveMeeting(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
        ms.leaveMeeting(with: LeaveMeetingCmd.leave)
    }
    return NSNumber(value: 0)
  }

  func handleGetMeetingState(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.getMeetingState().rawValue)
    }
    return NSNumber(value: -1)
  }

  func handleGetMeetingSettings(_ call: FlutterMethodCall) -> Dictionary<String, NSNumber> {
    var dict = Dictionary<String, NSNumber>()
    if let settings = MobileRTC.shared().getMeetingSettings() {
      // autoConnectInternetAudio (bool)
      // muteAudioWhenJoinMeeting (bool)
      // muteVideoWhenJoinMeeting (bool)
      // faceBeautyEnabled (bool)
      // freeMeetingUpgradeTipsDisabled (bool)
      // micOriginalInputEnabled (bool)
      // virtualBackgroundDisabled (bool)
      dict["autoConnectInternetAudio"] = NSNumber(value: settings.autoConnectInternetAudio())
      dict["muteAudioWhenJoinMeeting"] = NSNumber(value: settings.muteAudioWhenJoinMeeting())
      dict["muteVideoWhenJoinMeeting"] = NSNumber(value: settings.muteVideoWhenJoinMeeting())
      dict["faceBeautyEnabled"] = NSNumber(value: settings.faceBeautyEnabled())
      dict["freeMeetingUpgradeTipsDisabled"] = NSNumber(value: settings.freeMeetingUpgradeTipsDisabled())
      dict["micOriginalInputEnabled"] = NSNumber(value: settings.micOriginalInputEnabled())
      dict["virtualBackgroundDisabled"] = NSNumber(value: settings.virtualBackgroundDisabled())
    }
    return dict
  }

  func handleSetMeetingSettings(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Dictionary<String, NSNumber> {
      if let settings = MobileRTC.shared().getMeetingSettings() {
        // setAutoConnectInternetAudio (bool)
        // setMuteAudioWhenJoinMeeting (bool)
        // setMuteVideoWhenJoinMeeting (bool)
        // setFaceBeautyEnabled (bool)
        // disableFreeMeetingUpgradeTips (bool)
        // enableMicOriginalInput (bool)
        // disableVirtualBackground (bool)

        if let v = args["autoConnectInternetAudio"] {
          settings.setAutoConnectInternetAudio(v.boolValue)
        }
        if let v = args["muteAudioWhenJoinMeeting"] {
          settings.setMuteAudioWhenJoinMeeting(v.boolValue)
        }
        if let v = args["muteVideoWhenJoinMeeting"] {
          settings.setMuteVideoWhenJoinMeeting(v.boolValue)
        }
        if let v = args["faceBeautyEnabled"] {
          settings.setFaceBeautyEnabled(v.boolValue)
        }
        if let v = args["freeMeetingUpgradeTipsDisabled"] {
          settings.disableFreeMeetingUpgradeTips(v.boolValue)
        }
        if let v = args["micOriginalInputEnabled"] {
          settings.enableMicOriginalInput(v.boolValue)
        }
        if let v = args["virtualBackgroundDisabled"] {
          settings.disableVirtualBackground(v.boolValue)
        }

      }
    }
    return NSNumber(value: 0)
  }

  func handleGetMeetingURL(_ call: FlutterMethodCall) -> String {
    let ih = MobileRTCInviteHelper.sharedInstance()
    return ih.joinMeetingURL
  }

  func handleGetMeetingPassword(_ call: FlutterMethodCall) -> String {
    let ih = MobileRTCInviteHelper.sharedInstance()
    return ih.meetingPassword
  }

  func handleGetMyUserId(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      let userId = ms.myselfUserID()
      return NSNumber(value: userId)
    }
    return NSNumber(value: 0)
  }

  func handleGetActiveUserId(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      let userId = ms.activeUserID()
      return NSNumber(value: userId)
    }
    return NSNumber(value: 0)
  }

  func handleGetAllUserIds(_ call: FlutterMethodCall) -> [Any] {
    if let ms = MobileRTC.shared().getMeetingService() {
      if let userIds = ms.getInMeetingUserList() {
        return userIds
      }
    }
    return []
  }

  func handleGetUserInfo(_ call: FlutterMethodCall) -> Dictionary<String, Any?> {
    var dict = Dictionary<String, Any?>()
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        if let userInfo = ms.userInfo(byID: args[0].uintValue) {
          dict["isMySelf"] = NSNumber(value: userInfo.isMySelf)
          //dict["customerKey"] = userInfo.customerKey
          dict["userName"] = userInfo.userName
          dict["avatarPath"] = userInfo.avatarPath
          dict["unread"] = NSNumber(value: userInfo.unread)

          dict["isVideoReceiving"] = NSNumber(value: userInfo.videoStatus.isReceiving)
          dict["isVideoSending"] = NSNumber(value: userInfo.videoStatus.isSending)
          dict["isVideoSource"] = NSNumber(value: userInfo.videoStatus.isSource)

          dict["isAudioMuted"] = NSNumber(value: userInfo.audioStatus.isMuted)
          dict["isAudioTalking"] = NSNumber(value: userInfo.audioStatus.isTalking)
          dict["audioType"] = NSNumber(value: userInfo.audioStatus.audioType.rawValue)

          dict["handRaised"] = NSNumber(value: userInfo.handRaised)
          //dict["inWaitingRoom"] = NSNumber(value: userInfo.inWaitingRoom)
          dict["isCohost"] = NSNumber(value: userInfo.isCohost)
          dict["isHost"] = NSNumber(value: userInfo.isHost)
          dict["isH323User"] = NSNumber(value: userInfo.isH323User)
          dict["isPureCallInUser"] = NSNumber(value: userInfo.isPureCallInUser)
          dict["isSharingPureComputerAudio"] = NSNumber(value: userInfo.isSharingPureComputerAudio)
          dict["feedbackType"] = NSNumber(value: userInfo.feedbackType.rawValue)
          dict["userRole"] = NSNumber(value: userInfo.userRole.rawValue)
          dict["isInterpreter"] = NSNumber(value: userInfo.isInterpreter)
          dict["interpreterActiveLanguage"] = userInfo.interpreterActiveLanguage
        }
      }
    }
    return dict
  }

  func handleChangeName(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<Any?> {
      if let ms = MobileRTC.shared().getMeetingService() {
        let nameArg = (args[0] as? String) ?? ""
        let userIdArg = (args[1] as? NSNumber) ?? 0
        let result = ms.changeName(nameArg, withUserID: userIdArg.uintValue)
        return NSNumber(value: result)
      }
    }
    return NSNumber(value: false)
  }

  func handleConnectAudio(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.connectMyAudio(args[0].boolValue))
      }
    }
    return NSNumber(value: false)
  }

  func handleMuteAudio(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.muteMyAudio(args[0].boolValue).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleIsAudioMuted(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: ms.isMyAudioMuted())
    }
    return NSNumber(value: true)
  }

  func handleIsVoIPSupported(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: ms.isSupportedVOIP())
    }
    return NSNumber(value: false)
  }

  func handleMuteVideo(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.muteMyVideo(args[0].boolValue).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleIsVideoMuted(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: !ms.isSendingMyVideo())
    }
    return NSNumber(value: true)
  }

  func handleRotateMyVideo(_ call: FlutterMethodCall) -> NSNumber {
//   TODO AW
//     if let args = call.arguments as? Array<NSNumber> {
//       if let ms = MobileRTC.shared().getMeetingService() {
//         return NSNumber(value: ms.rotateMyVideo(UIDeviceOrientation(rawValue: args[0].intValue)!))
//       }
//     }
    return NSNumber(value: false)
  }

  func handleGetUserVideoSize(_ call: FlutterMethodCall) -> [NSNumber] {
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        let videoSize = ms.getUserVideoSize(args[0].uintValue)
        return [NSNumber(value: Double(videoSize.width)), NSNumber(value: Double(videoSize.height))]
      }
    }
    return []
  }

  func handleSwitchCamera(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      ms.switchMyCamera()
      return NSNumber(value: true)
    }
    return NSNumber(value: false)
  }

  func handleStartAppShare(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      if ms.startAppShare() {
        let vc = UIApplication.shared.windows.first?.rootViewController as! FlutterViewController
        if let view = vc.view {
          ms.appShare(withView: view)
          return NSNumber(value: true)
        }
      }
    }
    return NSNumber(value: false)
  }

  func handleStopAppShare(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      ms.stopAppShare()
      return NSNumber(value: true)
    }
    return NSNumber(value: false)
  }

  func handleLockShare(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.lockShare(args[0].boolValue))
      }
    }
    return NSNumber(value: false)
  }

  func handleIsShareLocked(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: ms.isMeetingLocked())
    }
    return NSNumber(value: true)
  }

  func handleDialOut(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<String> {
      let number = args[0]
      let name = args[1]
      if let ms = MobileRTC.shared().getMeetingService() {
        ms.dialOut(number, isCallMe: false, withName: name)
        return NSNumber(value: true)
      }
    }
    return NSNumber(value: false)
  }

  func handleEndDialOut(_ call: FlutterMethodCall) -> NSNumber {
    if let args = call.arguments as? Array<NSNumber> {
      let userid = UInt(args[0].intValue)
      if let ms = MobileRTC.shared().getMeetingService() {
        ms.removeUser(userid)
        return NSNumber(value: true)
      }
    }
    return NSNumber(value: false)
  }

  func handleStartAnnotation(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getAnnotationService(){
      if ms.canDoAnnotation() {
        ms.startAnnotation(withSharedView: nil) // needs a view?
        // TODO set up the annotation
        return NSNumber(value: true)
      }
    }
    return NSNumber(value: false)
  }

  func handleIsAnnotating(_ call: FlutterMethodCall) -> NSNumber {
    if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: !ms.isAnnotationOff())
    }
    return NSNumber(value: false)
  }

  func handleClearAnnotation(_ call: FlutterMethodCall) -> NSNumber {
    if let ans = MobileRTC.shared().getAnnotationService() {
      if let ms = MobileRTC.shared().getMeetingService() {
        if !ms.isAnnotationOff() {
          ans.clear()
          return NSNumber(value: true)
        }
      }
    }
    return NSNumber(value: false)
  }

  func handleStopAnnotation(_ call: FlutterMethodCall) -> NSNumber {
    if let ans = MobileRTC.shared().getAnnotationService() {
      if let ms = MobileRTC.shared().getMeetingService() {
        if !ms.isAnnotationOff() {
          ans.stopAnnotation()
          return NSNumber(value: true)
        }
      }
    }
    return NSNumber(value: false)
  }
}
