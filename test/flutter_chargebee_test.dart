import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chargebee/flutter_chargebee.dart';
import 'package:flutter_chargebee/flutter_chargebee_platform_interface.dart';
import 'package:flutter_chargebee/flutter_chargebee_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterChargebeePlatform 
    with MockPlatformInterfaceMixin
    implements FlutterChargebeePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterChargebeePlatform initialPlatform = FlutterChargebeePlatform.instance;

  test('$MethodChannelFlutterChargebee is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterChargebee>());
  });

  test('getPlatformVersion', () async {
    FlutterChargebee flutterChargebeePlugin = FlutterChargebee();
    MockFlutterChargebeePlatform fakePlatform = MockFlutterChargebeePlatform();
    FlutterChargebeePlatform.instance = fakePlatform;
  
    expect(await flutterChargebeePlugin.getPlatformVersion(), '42');
  });
}
