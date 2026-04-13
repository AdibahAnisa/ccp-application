import 'platform_service.dart';

class IOSService implements PlatformService {
  @override
  String getPlatformName() {
    return "iOS Device";
  }
}
