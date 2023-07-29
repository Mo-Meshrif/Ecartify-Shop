part of 'favourite_bloc.dart';

class FavouriteState extends Equatable {
  final Status favListStatus, setFavStatus, setUnFavStatus;
  final List<Product> favProds;
  final int favProdsNumber;

  const FavouriteState({
    this.favListStatus = Status.sleep,
    this.setFavStatus = Status.sleep,
    this.setUnFavStatus = Status.sleep,
    this.favProds = const [],
    this.favProdsNumber = 0,
  });

  FavouriteState copyWith({
    Status? favListStatus,
    Status? setFavStatus,
    Status? setUnFavStatus,
    List<Product>? favProds,
    int? favProdsNumber,
  }) =>
      FavouriteState(
        favListStatus: favListStatus ?? this.favListStatus,
        setFavStatus: setFavStatus ?? this.setFavStatus,
        setUnFavStatus: setUnFavStatus ?? this.setUnFavStatus,
        favProds: favProds ?? this.favProds,
        favProdsNumber: favProdsNumber ?? this.favProdsNumber,
      );

  @override
  List<Object?> get props => [
        favListStatus,
        setFavStatus,
        setUnFavStatus,
        favProds,
        favProdsNumber,
      ];
}
