import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chargebee/flutter_chargebee_platform_interface.dart';
import 'package:flutter_chargebee/platforms/android.dart';
import 'package:flutter_chargebee/platforms/ios.dart';

/// An implementation of [FlutterChargebeePlatform] that uses method channels.
class MethodChannelFlutterChargebee extends FlutterChargebeePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_chargebee');

  @override
  Future<String?> configure({
    required String site,
    required String apiKey,
    required String androidSdkKey,
    required String iosSdkKey,
    required String? packageName,
  }) async {
    final version = await methodChannel.invokeMethod<String>('configure', {
      'site': site,
      'apiKey': apiKey,
      'androidSdkKey': androidSdkKey,
      'iosSdkKey': iosSdkKey,
      'packageName': packageName,
    });
    return version;
  }

  @override
  Future<List<String>> retrieveProductIDs({
    int limit = 100,
  }) async {
    final result = await methodChannel.invokeListMethod<String>(
      'retrieveProductIDs',
      {
        'limit': limit,
      },
    );
    return result ?? [];
  }

  @override
  Future<List<CBProduct>> retrieveProductsPlaystore({
    required List<String> productIds,
  }) async {
    if (!Platform.isAndroid) {
      throw Exception(
        'retrieveProductsPlaystore() is only supported on Android.',
      );
    }

    final result = await methodChannel.invokeListMethod<Map>(
      'retrieveProducts',
      {
        'productIds': productIds,
      },
    );

    final ret = result?.map((m) {
      final map = Map<String, dynamic>.from(m);
      return CBProduct.fromMap(map);
    }).toList();

    return ret ?? [];
  }

  @override
  Future<List<AppStoreProduct>> retrieveProductsAppstore({
    required List<String> productIds,
  }) async {
    if (!Platform.isIOS) {
      throw Exception('retrieveProductsAppstore() is only supported on iOS.');
    }

    final result = await methodChannel.invokeListMethod<Map>(
      'retrieveProducts',
      {
        'productIds': productIds,
      },
    );

    final ret = result?.map((m) {
      final map = Map<String, dynamic>.from(m);
      return AppStoreProduct.fromMap(map);
    }).toList();

    return ret ?? [];
  }

  @override
  Future<dynamic> purchaseProduct({
    required String customerId,
    required String productId,
  }) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'purchaseProduct',
      {
        'customerID': customerId,
        'productId': productId,
      },
    );
    return result;
  }
}
