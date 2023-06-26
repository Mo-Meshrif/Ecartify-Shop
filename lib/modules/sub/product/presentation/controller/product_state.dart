part of 'product_bloc.dart';

class ProductState extends Equatable {
  final Status productDetailsStatus;
  final Product? productDetails;
  final Status customProdStatus;
  final List<Product> customProds;
  final bool isCustomProdMax;
  final Status searchedProdStatus;
  final List<Product> searchedProds;
  final bool isSearchedProdMax;
  final Status updateProductStatus;

  const ProductState({
    this.productDetailsStatus = Status.sleep,
    this.productDetails,
    this.customProdStatus = Status.sleep,
    this.customProds = const [],
    this.isCustomProdMax = false,
    this.searchedProdStatus = Status.sleep,
    this.searchedProds = const [],
    this.isSearchedProdMax = false,
    this.updateProductStatus = Status.sleep,
  });
  ProductState copyWith({
    Status? productDetailsStatus,
    Product? productDetails,
    Status? customProdStatus,
    List<Product>? customProds,
    bool? isCustomProdMax,
    Status? searchedProdStatus,
    List<Product>? searchedProds,
    bool? isSearchedProdMax,
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
        searchedProdStatus: searchedProdStatus ?? this.searchedProdStatus,
        searchedProds: searchedProds ?? this.searchedProds,
        isSearchedProdMax: isSearchedProdMax ?? this.isSearchedProdMax,
        updateProductStatus: updateProductStatus ?? this.updateProductStatus,
      );

  @override
  List<Object?> get props => [
        productDetailsStatus,
        productDetails,
        customProdStatus,
        customProds,
        isCustomProdMax,
        searchedProdStatus,
        searchedProds,
        isSearchedProdMax,
        updateProductStatus,
      ];
}
