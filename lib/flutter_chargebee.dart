
import 'flutter_chargebee_platform_interface.dart';

class FlutterChargebee {
  Future<String?> getPlatformVersion() {
    return FlutterChargebeePlatform.instance.getPlatformVersion();
  }
}
