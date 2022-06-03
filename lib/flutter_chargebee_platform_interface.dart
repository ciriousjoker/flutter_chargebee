import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_chargebee_method_channel.dart';

abstract class FlutterChargebeePlatform extends PlatformInterface {
  /// Constructs a FlutterChargebeePlatform.
  FlutterChargebeePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterChargebeePlatform _instance = MethodChannelFlutterChargebee();

  /// The default instance of [FlutterChargebeePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterChargebee].
  static FlutterChargebeePlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterChargebeePlatform] when
  /// they register themselves.
  static set instance(FlutterChargebeePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
