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
      productId: map['productId'],
      productPrice: map['productPrice'],
      productTitle: map['productTitle'],
      skuDetailsJson: map['skuDetails'],
      subStatus: map['subStatus'],
    );
  }
}
