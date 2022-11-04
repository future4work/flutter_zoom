import Flutter
import UIKit
import MobileRTC
import MobileCoreServices

var _debugLogging: Bool = false

func _log(message: NSString) {
  if (_debugLogging) {
    var m: String = message as String
    NSLog("flutter_zoom: " + m + "\n")
  }
}

class ZoomCustomMeetingViewController : UIViewController {

  lazy var videoView = MobileRTCVideoView(frame: view.bounds)
  var _userId: UInt = 0

  override func viewDidAppear(_ animated: Bool) {
    _log(message: "enter ZoomCustomMeetingViewController.viewDidAppear")
    super.viewDidAppear(animated)

    videoView.setVideoAspect(MobileRTCVideoAspect_PanAndScan)
    videoView.showAttendeeVideo(withUserID: _userId)

    view.addSubview(videoView)
  }

  func setFrame(frame: CGRect) {
    _log(message: "enter ZoomCustomMeetingViewController.setFrame")
    _log(message: NSString(format: "Set frame %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height))
  }

  func setPreview(_ preview : Bool) {
    _log(message: "enter ZoomCustomMeetingViewController.setPreview")
    _log(message: NSString(format: "Set preview %i", preview))
  }

  func showUser(userId: UInt) {
    _log(message: "enter ZoomCustomMeetingViewController.showUser")
    _log(message: NSString(format: "Show user %u", userId))
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
    _log(message: "enter ZoomMeetingView.view")
    return _viewController.view
  }

  func setupViewController(userId: UInt) {
    _log(message: "enter ZoomMeetingView.setupViewController")
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
    _log(message: "enter ZoomMeetingViewFactory.create")
    NSLog("Create frame %f %f %f %f\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
    return ZoomMeetingView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: _messenger)
  }

  @objc public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    _log(message: "enter ZoomMeetingViewFactory.createArgsCodec")
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class ZoomScreenShareViewController : UIViewController {

  lazy var videoView = MobileRTCActiveShareView(frame: view.bounds)
  var _userId: UInt = 0

  override func viewDidAppear(_ animated: Bool) {
    _log(message: "enter ZoomScreenShareViewController.viewDidAppear")
    super.viewDidAppear(animated)

    videoView.setVideoAspect(MobileRTCVideoAspect_PanAndScan)
    videoView.showActiveShare(withUserID: _userId)

    view.addSubview(videoView)
  }

  func setFrame(frame: CGRect) {
    _log(message: "enter ZoomScreenShareViewController.setFrame")
    NSLog("Set frame %f %f %f %f\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
  }

  func setPreview(_ preview : Bool) {
    _log(message: "enter ZoomScreenShareViewController.setPreview")
    NSLog("Set preview %i\n", preview)
  }

  func showUser(userId: UInt) {
    _log(message: "enter ZoomScreenShareViewController.showUser")
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
    _log(message: "enter ZoomScreenShareView.view")
    return _viewController.view
  }

  func setupViewController(userId: UInt) {
    _log(message: "enter ZoomScreenShareView.setupViewController")
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
    _log(message: "enter ZoomScreenShareViewFactory.create")
    return ZoomScreenShareView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: _messenger)
  }

  @objc public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    _log(message: "enter ZoomScreenShareViewFactory.createArgsCodec")
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
    _log(message: "enter ZoomClientWrapperCustomMeetingUIDelegate.onInitMeetingView")
    _methodChannel.invokeMethod("onInitMeetingView", arguments: nil)
  }

  func onDestroyMeetingView() {
    _log(message: "enter ZoomClientWrapperCustomMeetingUIDelegate.onDestroyMeetingView")
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
    _log(message: "enter ZoomClientWrapperAuthDelegate.onMobileRTCAuthExpired")
    _methodChannel.invokeMethod("onAuthExpired", arguments: nil)
  }

  func onMobileRTCAuthReturn(_ returnValue : MobileRTCAuthError) {
    _log(message: "enter ZoomClientWrapperAuthDelegate.onMobileRTCAuthReturn")
    _methodChannel.invokeMethod("onAuthReturn", arguments: [NSNumber(value: returnValue.rawValue)])
  }

  func onMobileRTCLogoutReturn(_ returnValue : NSInteger) {
    _log(message: "enter ZoomClientWrapperAuthDelegate.onMobileRTCLogoutReturn")
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
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onJBHWaiting")
    switch (cmd) {
    case .show:
      NSLog("Joined before host")
    case .hide:
      NSLog("Hide joined before host")
    }
  }

  func onRecordingStatus(_ status: MobileRTCRecordingStatus) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onRecordingStatus")
    NSLog("Recording status %i", status.rawValue)
  }

  func onLocalRecordingStatus(_ userId: Int, status: MobileRTCRecordingStatus) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onLocalRecordingStatus")
    NSLog("Local recording status %i", status.rawValue)
  }

  func onCheckCMRPrivilege(_ result: MobileRTCCMRError) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onCheckCMRPrivilege")
    NSLog("Checked CMR privilege %i", result.rawValue)
  }

  func onMeetingParameterNotification(_ meetingParam: MobileRTCMeetingParameter?) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMeetingParameterNotification")
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
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMeetingStateChange")
    _methodChannel.invokeMethod("onMeetingStateChange", arguments: [NSNumber(value: state.rawValue)])
  }

  func onWaitingRoomStatusChange(_ needWaiting : Bool) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onWaitingRoomStatusChange")
    _methodChannel.invokeMethod("onWaitingRoomStatusChange", arguments: [NSNumber(value: needWaiting)])
  }

  func onMeetingEndedReason(_ reason: MobileRTCMeetingEndReason) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMeetingEndedReason")
    NSLog("Meeting ended because %i", reason.rawValue)
  }

  func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMeetingError")
    NSLog("Meeting error %i", error.rawValue)
  }

// USER CALLBACKS

  func onMyHandStateChange() {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMyHandStateChange")
  }

  func onInMeetingUserUpdated() {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onInMeetingUserUpdated")
    _methodChannel.invokeMethod("onInMeetingUserUpdated", arguments: nil)
  }

  func onSinkMeetingUserJoin(_ userId: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingUserJoin")
    _methodChannel.invokeMethod("onSinkMeetingUserJoin", arguments: [NSNumber(value: userId)])
  }

  func onSinkMeetingUserLeft(_ userId: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingUserLeft")
    _methodChannel.invokeMethod("onSinkMeetingUserLeft", arguments: [NSNumber(value: userId)])
  }

  func onSinkMeetingUserRaiseHand(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingUserRaiseHand")
  }

  func onSinkMeetingUserLowerHand(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingUserLowerHand")
  }

  func onSinkLowerAllHands() {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkLowerAllHands")
  }

  func onSinkUserNameChanged(_ userId: UInt, userName: String) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkUserNameChanged")
  }

  func onSinkUserNameChanged(_ userNameChangedArr: [NSNumber]?) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkUserNameChanged")
  }

  func onMeetingHostChange(_ userId: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMeetingHostChange")
    _methodChannel.invokeMethod("onMeetingHostChange", arguments: [NSNumber(value: userId)])
  }

  func onMeetingCoHostChange(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMeetingCoHostChange")
  }

  func onMeetingCoHostChange(_ userID: UInt, isCoHost: Bool) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMeetingCoHostChange")
  }

  func onClaimHostResult(_ error: MobileRTCClaimHostError) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onClaimHostResult")
  }

// VIDEO CALLBACKS

  func onSinkMeetingActiveVideo(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingActiveVideo")
  }

  func onSinkMeetingVideoStatusChange(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingVideoStatusChange")
    _methodChannel.invokeMethod("onSinkMeetingVideoStatusChange", arguments: [NSNumber(value: userID)])
  }

  func onMyVideoStateChange() {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onMyVideoStateChange")
  }

  func onSinkMeetingVideoStatusChange(_ userID: UInt, videoStatus: MobileRTC_VideoStatus) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingVideoStatusChange")
  }

  func onSpotlightVideoChange(_ on: Bool) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSpotlightVideoChange")
  }

  func onSpotlightVideoUserChange(_ spotlightedUserList: [NSNumber]) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSpotlightVideoUserChange")
  }

  func onSinkMeetingPreviewStopped() {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingPreviewStopped")
  }

  func onSinkMeetingActiveVideo(forDeck userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingActiveVideo")
  }

  func onSinkMeetingVideoQualityChanged(_ qality: MobileRTCVideoQuality, userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingVideoQualityChanged")
  }

  func onSinkMeetingVideoRequestUnmute(byHost completion: @escaping (Bool) -> Void) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingVideoRequestUnmute")
  }

  func onSinkMeetingShowMinimizeMeetingOrBackZoomUI(_ state: MobileRTCMinimizeMeetingState) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingShowMinimizeMeetingOrBackZoomUI")
  }

  func onHostVideoOrderUpdated(_ orderArr: [NSNumber]?) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onHostVideoOrderUpdated")
  }

  func onLocalVideoOrderUpdated(_ localOrderArr: [NSNumber]?) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onLocalVideoOrderUpdated")
  }

  func onFollowHostVideoOrderChanged(_ follow: Bool) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onFollowHostVideoOrderChanged")
  }

// SCREEN SHARING CALLBACKS

  func onAppShareSplash() {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onAppShareSplash")
  }

  func onSinkMeetingActiveShare(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingActiveShare")
    _methodChannel.invokeMethod("onSinkMeetingActiveShare", arguments: [NSNumber(value: userID)])
  }

  func onSinkMeetingShareReceiving(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkMeetingShareReceiving")
  }

  func onSinkShareSettingTypeChanged(_ shareSettingType: MobileRTCShareSettingType) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkShareSettingTypeChanged")
  }

  func onSinkShareSizeChange(_ userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkShareSizeChange")
  }

  func onSinkSharingStatus(_ status: MobileRTCSharingStatus, userID: UInt) {
    _log(message: "enter ZoomClientWrapperMeetingDelegate.onSinkSharingStatus")
  }

}

class ZoomClientWrapperWaitingRoomDelegate : NSObject, MobileRTCWaitingRoomServiceDelegate {
  var _methodChannel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    _methodChannel = channel
    super.init()
  }

  func onWaitingRoomUserJoin(_ userId: UInt) {
    _log(message: "enter ZoomClientWrapperWaitingRoomDelegate.onWaitingRoomUserJoin")
    _log(message: NSString(format: "User joined waiting room %u\n", userId))
  }

  func onWaitingRoomUserLeft(_ userId: UInt) {
    _log(message: "enter ZoomClientWrapperWaitingRoomDelegate.onWaitingRoomUserLeft")
    _log(message: NSString(format: "User left waiting room %u\n", userId))
  }

}

public class SwiftFlutterZoomPlugin: NSObject, FlutterPlugin {

  var _authDelegate: ZoomClientWrapperAuthDelegate
  var _meetingDelegate: ZoomClientWrapperMeetingDelegate
  var _customMeetingUIDelegate: ZoomClientWrapperCustomMeetingUIDelegate
  var _waitingRoomDelegate: ZoomClientWrapperWaitingRoomDelegate

  public static func register(with registrar: FlutterPluginRegistrar) {
    _log(message: "enter SwiftFlutterZoomPlugin.register")
    _log(message: "Registering SwiftFlutterZoomPlugin\n")
    let channel = FlutterMethodChannel(name: "flutter-zoom", binaryMessenger: registrar.messenger())
    let meetingViewFactory = ZoomMeetingViewFactory(messenger: registrar.messenger())
    let screenShareViewFactory = ZoomScreenShareViewFactory(messenger: registrar.messenger())
    let instance = SwiftFlutterZoomPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(meetingViewFactory, withId: "zoom-meeting-view")
    registrar.register(screenShareViewFactory, withId: "zoom-screen-share-view")
  }

  public init(channel: FlutterMethodChannel) {
    _log(message: "Initializing SwiftFlutterZoomPlugin\n")
    _authDelegate = ZoomClientWrapperAuthDelegate(channel: channel)
    _meetingDelegate = ZoomClientWrapperMeetingDelegate(channel: channel)
    _customMeetingUIDelegate = ZoomClientWrapperCustomMeetingUIDelegate(channel: channel)
    _waitingRoomDelegate = ZoomClientWrapperWaitingRoomDelegate(channel: channel)
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    _log(message: "enter SwiftFlutterZoomPlugin.handle")
    _log(message: NSString(format: "SwiftFlutterZoomPlugin.handle on %@\n", call.method))
    switch call.method {
    case "getPlatformVersion":
      result("0.0.1")
    case "enableLogging":
      _debugLogging = true
    case "disableLogging":
      _debugLogging = false
    case "fullName":
      result(NSFullUserName())
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleInitClientSDK")
    if let args = call.arguments as? Array<String> {
      _log(message: NSString(format: "handleInitClientSDK: nitializing client SDK with %@, %@", args[0], args[1]))
      let initContext = MobileRTCSDKInitContext()
      initContext.domain = args[0]
      initContext.appGroupId = args[1]
      initContext.enableLog = true
      initContext.locale = .default

      let bundle = Bundle(identifier: "org.cocoapods.flutter-zoom")
      initContext.bundleResPath = bundle!.bundlePath

      return NSNumber(value: MobileRTC.shared().initialize(initContext))
    }
    _log(message: "Failed to initialize client SDK due to missing args")
    return NSNumber(value: false)
  }

  func handleInitClientAuthSDKParams(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleInitClientAuthSDKParams")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleInitClientAuthJWTParams")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleLogout")
    if let auth = MobileRTC.shared().getAuthService() {
      return NSNumber(value: auth.logoutRTC())
    }
    return NSNumber(value: false)
  }

  func handleGetUserType(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetUserType")
    if let auth = MobileRTC.shared().getAuthService() {
      return NSNumber(value: auth.getUserType().rawValue)
    }
    return NSNumber(value: -1)
  }

  func handleIsLoggedIn(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleIsLoggedIn")
    if let auth = MobileRTC.shared().getAuthService() {
      return NSNumber(value: auth.isLoggedIn())
    }
    return NSNumber(value: false)
  }

  func handleInitMeetingService(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleInitMeetingService")
    let settings = MobileRTC.shared().getMeetingSettings()
    let ms = MobileRTC.shared().getMeetingService()
    let wrs = MobileRTC.shared().getWaitingRoomService()
    if settings == nil || ms == nil || wrs == nil {
      return NSNumber(value: false)
    }

    _log(message: "Init meeting service")

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
    _log(message: "enter SwiftFlutterZoomPlugin.handleStartMeeting")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleStartMeetingApiUser")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleJoinMeeting")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleJoinMeetingWithPassword")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleHandleZoomWebURL")
    if let args = call.arguments as? Array<String> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.handZoomWebUrl(args[0]).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleStopMeeting(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleStopMeeting")
    if let ms = MobileRTC.shared().getMeetingService() {
        ms.leaveMeeting(with: LeaveMeetingCmd.end)
    }
    return NSNumber(value: 0)
  }

  func handleLeaveMeeting(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleLeaveMeeting")
    if let ms = MobileRTC.shared().getMeetingService() {
        ms.leaveMeeting(with: LeaveMeetingCmd.leave)
    }
    return NSNumber(value: 0)
  }

  func handleGetMeetingState(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetMeetingState")
    if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.getMeetingState().rawValue)
    }
    return NSNumber(value: -1)
  }

  func handleGetMeetingSettings(_ call: FlutterMethodCall) -> Dictionary<String, NSNumber> {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetMeetingSettings")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleSetMeetingSettings")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetMeetingURL")
    let ih = MobileRTCInviteHelper.sharedInstance()
    return ih.joinMeetingURL
  }

  func handleGetMeetingPassword(_ call: FlutterMethodCall) -> String {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetMeetingPassword")
    let ih = MobileRTCInviteHelper.sharedInstance()
    return ih.meetingPassword
  }

  func handleGetMyUserId(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetMyUserId")
    if let ms = MobileRTC.shared().getMeetingService() {
      let userId = ms.myselfUserID()
      return NSNumber(value: userId)
    }
    return NSNumber(value: 0)
  }

  func handleGetActiveUserId(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetActiveUserId")
    if let ms = MobileRTC.shared().getMeetingService() {
      let userId = ms.activeUserID()
      return NSNumber(value: userId)
    }
    return NSNumber(value: 0)
  }

  func handleGetAllUserIds(_ call: FlutterMethodCall) -> [Any] {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetAllUserIds")
    if let ms = MobileRTC.shared().getMeetingService() {
      if let userIds = ms.getInMeetingUserList() {
        return userIds
      }
    }
    return []
  }

  func handleGetUserInfo(_ call: FlutterMethodCall) -> Dictionary<String, Any?> {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetUserInfo")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleChangeName")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleConnectAudio")
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.connectMyAudio(args[0].boolValue))
      }
    }
    return NSNumber(value: false)
  }

  func handleMuteAudio(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleMuteAudio")
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.muteMyAudio(args[0].boolValue).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleIsAudioMuted(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleIsAudioMuted")
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: ms.isMyAudioMuted())
    }
    return NSNumber(value: true)
  }

  func handleIsVoIPSupported(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleIsVoIPSupported")
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: ms.isSupportedVOIP())
    }
    return NSNumber(value: false)
  }

  func handleMuteVideo(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleMuteVideo")
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.muteMyVideo(args[0].boolValue).rawValue)
      }
    }
    return NSNumber(value: -1)
  }

  func handleIsVideoMuted(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleIsVideoMuted")
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: !ms.isSendingMyVideo())
    }
    return NSNumber(value: true)
  }

  func handleRotateMyVideo(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleRotateMyVideo")
//   TODO AW
//     if let args = call.arguments as? Array<NSNumber> {
//       if let ms = MobileRTC.shared().getMeetingService() {
//         return NSNumber(value: ms.rotateMyVideo(UIDeviceOrientation(rawValue: args[0].intValue)!))
//       }
//     }
    return NSNumber(value: false)
  }

  func handleGetUserVideoSize(_ call: FlutterMethodCall) -> [NSNumber] {
    _log(message: "enter SwiftFlutterZoomPlugin.handleGetUserVideoSize")
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        let videoSize = ms.getUserVideoSize(args[0].uintValue)
        return [NSNumber(value: Double(videoSize.width)), NSNumber(value: Double(videoSize.height))]
      }
    }
    return []
  }

  func handleSwitchCamera(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleSwitchCamera")
    if let ms = MobileRTC.shared().getMeetingService() {
      ms.switchMyCamera()
      return NSNumber(value: true)
    }
    return NSNumber(value: false)
  }

  func handleStartAppShare(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleStartAppShare")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleStopAppShare")
    if let ms = MobileRTC.shared().getMeetingService() {
      ms.stopAppShare()
      return NSNumber(value: true)
    }
    return NSNumber(value: false)
  }

  func handleLockShare(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleLockShare")
    if let args = call.arguments as? Array<NSNumber> {
      if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: ms.lockShare(args[0].boolValue))
      }
    }
    return NSNumber(value: false)
  }

  func handleIsShareLocked(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleIsShareLocked")
    if let ms = MobileRTC.shared().getMeetingService() {
      return NSNumber(value: ms.isMeetingLocked())
    }
    return NSNumber(value: true)
  }

  func handleDialOut(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleDialOut")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleEndDialOut")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleStartAnnotation")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleIsAnnotating")
    if let ms = MobileRTC.shared().getMeetingService() {
        return NSNumber(value: !ms.isAnnotationOff())
    }
    return NSNumber(value: false)
  }

  func handleClearAnnotation(_ call: FlutterMethodCall) -> NSNumber {
    _log(message: "enter SwiftFlutterZoomPlugin.handleClearAnnotation")
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
    _log(message: "enter SwiftFlutterZoomPlugin.handleStopAnnotation")
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
