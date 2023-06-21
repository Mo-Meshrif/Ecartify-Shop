part of 'product_bloc.dart';

class ProductState extends Equatable {
  final Status productDetailsStatus;
  final Product? productDetails;
  final Status customProdStatus;
  final List<Product> customProds;
  final bool isCustomProdMax;
  final Status updateProductStatus;

  const ProductState({
    this.productDetailsStatus = Status.sleep,
    this.productDetails,
    this.customProdStatus = Status.sleep,
    this.customProds = const [],
    this.isCustomProdMax = false,
    this.updateProductStatus=Status.sleep,
  });
  ProductState copyWith({
    Status? productDetailsStatus,
    Product? productDetails,
    Status? customProdStatus,
    List<Product>? customProds,
    bool? isCustomProdMax,
    Status? updateProductStatus,
  }) =>
      ProductState(
        productDetailsStatus: productDetailsStatus ?? this.productDetailsStatus,
        productDetails: productDetailsStatus == Status.error
            ? null
            : productDetails ?? this.productDetails,
        customProdStatus: customProdStatus ?? this.customProdStatus,
        customProds: customProds ?? this.customProds,
        isCustomProdMax: isCustomProdMax ?? this.isCustomProdMax,
        updateProductStatus: updateProductStatus??this.updateProductStatus,
      );

  @override
  List<Object?> get props => [
        productDetailsStatus,
        productDetails,
        customProdStatus,
        customProds,
        isCustomProdMax,
        updateProductStatus,
      ];
}
