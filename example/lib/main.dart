import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chargebee/flutter_chargebee.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _chargebeePlugin = FlutterChargebee.instance;

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    await _chargebeePlugin.configure(
      site: 'TODO: Enter site name',
      apiKey: 'TODO: Enter publishable api key',
      androidSdkKey: 'TODO: Enter android sdk key, e.g. cb-4jte...',
      iosSdkKey: 'TODO: Enter the ios sdk key, e.g. cb-ehcj...',
    );

    setState(() {
      isInitialized = true;
    });
  }

  Future<void> retrieveProductIDs() async {
    final productIds = await _chargebeePlugin.retrieveProductIDs(limit: 100);
    debugPrint('retrieveProductIDs() done. $productIds');
  }

  Future<void> retrieveProducts() async {
    if (Platform.isAndroid) {
      final products = await _chargebeePlugin.retrieveProductsPlaystore(
        productIds: ["TODO: Enter product id"],
      );
      for (final product in products) {
        debugPrint('Found product: ${product.productTitle}');
      }
    } else if (Platform.isIOS) {
      final products = await _chargebeePlugin.retrieveProductsAppstore(
        productIds: ["TODO: Enter product id"],
      );
      for (final product in products) {
        debugPrint('Found product: ${product.localizedTitle}');
      }
    } else {
      throw UnsupportedError(
        "Unsupported platform: ${Platform.operatingSystem}",
      );
    }
    debugPrint('retrieveProducts() done.');
  }

  Future<void> purchaseProduct() async {
    final productIds = await _chargebeePlugin.retrieveProductIDs();

    final result = await _chargebeePlugin.purchaseProduct(
      customerID: 'TODO: Enter your customer ID',
      productId: productIds.first,
    );
    debugPrint(
      'purchaseProduct() done. subscription id: ${result.subscriptionId}, status: ${result.status}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chargebee plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show initialization status
            isInitialized
                ? const Text('configure() done.')
                : const Text('not initialized.'),

            ElevatedButton(
              child: const Text('configure()'),
              onPressed: () {
                init();
              },
            ),

            ElevatedButton(
              child: const Text('retrieveProductIDs()'),
              onPressed: () {
                retrieveProductIDs();
              },
            ),

            ElevatedButton(
              child: const Text('retrieveProducts()'),
              onPressed: () {
                retrieveProducts();
              },
            ),

            ElevatedButton(
              child: const Text('purchaseProduct'),
              onPressed: () {
                purchaseProduct();
              },
            ),
          ],
        )),
      ),
    );
  }
}
