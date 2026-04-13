import 'dart:io';
import 'platform_service.dart';
import 'android_service.dart';
import 'ios_service.dart';

class PlatformSelector {
  static PlatformService getService() {
    if (Platform.isIOS) {
      return IOSService();
    } else {
      return AndroidService();
    }
  }
}
