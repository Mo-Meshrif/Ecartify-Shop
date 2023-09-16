part of 'promo_bloc.dart';

class PromoState extends Equatable {
  final Status checkPromoCodeStatus;
  final Promo? promoResult;

  const PromoState({
    this.checkPromoCodeStatus = Status.sleep,
    this.promoResult,
  });

  PromoState copyWith({
    Status? checkPromoCodeStatus,
    Promo? promoResult,
  }) =>
      PromoState(
        checkPromoCodeStatus: checkPromoCodeStatus ?? this.checkPromoCodeStatus,
        promoResult: checkPromoCodeStatus == Status.loaded ||
                checkPromoCodeStatus == Status.error
            ? promoResult
            : this.promoResult,
      );

  @override
  List<Object?> get props => [
        checkPromoCodeStatus,
        promoResult,
      ];
}
