part of 'shop_bloc.dart';

class ShopState extends Equatable {
  final Status bestSellerProdStatus;
  final List<Product> bestSellerProds;
  final Status sliderBanneStatus;
  final List<SliderBanner> sliderBanners;
  final Status offerProdStatus;
  final List<Product> offerProds;

  const ShopState({
    this.bestSellerProdStatus = Status.sleep,
    this.bestSellerProds = const [],
    this.sliderBanneStatus = Status.sleep,
    this.sliderBanners = const [],
    this.offerProdStatus = Status.sleep,
    this.offerProds = const [],
  });
  ShopState copyWith({
    Status? bestSellerProdStatus,
    List<Product>? bestSellerProds,
    Status? sliderBanneStatus,
    List<SliderBanner>? sliderBanners,
    Status? offerProdStatus,
    List<Product>? offerProds,
  }) =>
      ShopState(
        bestSellerProdStatus: bestSellerProdStatus ?? this.bestSellerProdStatus,
        bestSellerProds: bestSellerProds ?? this.bestSellerProds,
        sliderBanneStatus: sliderBanneStatus ?? this.sliderBanneStatus,
        sliderBanners: sliderBanners ?? this.sliderBanners,
        offerProdStatus: offerProdStatus ?? this.offerProdStatus,
        offerProds: offerProds ?? this.offerProds,
      );

  @override
  List<Object?> get props => [
        bestSellerProdStatus,
        bestSellerProds,
        sliderBanneStatus,
        sliderBanners,
        offerProdStatus,
        offerProds,
      ];
}
