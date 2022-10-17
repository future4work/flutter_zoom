import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:flutter_zoom/flutter_zoom_service.dart';
import 'package:flutter_zoom/flutter_zoom_service_ios.dart';
import 'package:flutter_zoom/flutter_zoom_service_not_implemented.dart';

class FlutterZoom {
    static ZoomService? _instance;

    static ZoomService get instance {
      _instance ??= _createInstance();
      return _instance!;
    }

    static ZoomService _createInstance() {
      if (UniversalPlatform.isIOS) {
        return ZoomServiceIOS();
      } else { /// todo: add android here
        return ZoomServiceNotImplemented();
      }
    }

    static const MethodChannel _channel = MethodChannel('flutter_zoom');

    static Future<String?> get platformVersion async {
      final String? version = await _channel.invokeMethod('getPlatformVersion');
      return version;
    }
}

class ZoomMeetingView extends StatelessWidget {
  final int userId;
  final bool videoMuted;

  const ZoomMeetingView({ required this.userId, required this.videoMuted, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      if (UniversalPlatform.isIOS) {
        return ZoomIOSMeetingView(userId: userId, videoMuted: videoMuted);
      } else {
        return const ZoomNotImplementedMeetingView();
      }
  }
}

class ZoomScreenShareView extends StatelessWidget {
  final int userId;
  final bool videoMuted;

  const ZoomScreenShareView({ required this.userId, required this.videoMuted, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isIOS) {
      return ZoomIOSScreenShareView(userId: userId, videoMuted: videoMuted);
    } else {
      return const ZoomNotImplementedMeetingView();
    }
  }
}

class ZoomNotImplementedMeetingView extends StatelessWidget {
  const ZoomNotImplementedMeetingView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Meeting view not implemented on current platform'));
  }
}

