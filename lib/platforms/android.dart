import 'package:deep_pick/deep_pick.dart';

class CBProduct {
  final bool subStatus;
  final String productId;
  final String productPrice;
  final String productTitle;
  final String skuDetailsJson;

  CBProduct({
    required this.productId,
    required this.productPrice,
    required this.productTitle,
    required this.skuDetailsJson,
    required this.subStatus,
  });

  factory CBProduct.fromMap(Map<String, dynamic> map) {
    return CBProduct(
      productId: pick(map, "productId").asStringOrThrow(),
      productPrice: pick(map, "productPrice").asStringOrThrow(),
      productTitle: pick(map, "productTitle").asStringOrThrow(),
      skuDetailsJson: pick(map, "skuDetails").asStringOrThrow(),
      subStatus: pick(map, "subStatus").asBoolOrThrow(),
    );
  }
}
