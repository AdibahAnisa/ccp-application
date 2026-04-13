import 'platform_service.dart';

class AndroidService implements PlatformService {
  @override
  String getPlatformName() {
    return "Android Device";
  }
}
