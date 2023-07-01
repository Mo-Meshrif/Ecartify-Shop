part of 'favourite_bloc.dart';

class FavouriteState extends Equatable {
  final Status favListStatus, setFavStatus, setUnFavStatus;
  final List<Product> favProds;

  const FavouriteState({
    this.favListStatus = Status.sleep,
    this.setFavStatus = Status.sleep,
    this.setUnFavStatus = Status.sleep,
    this.favProds = const [],
  });

  FavouriteState copyWith({
    Status? favListStatus,
    Status? setFavStatus,
    Status? setUnFavStatus,
    List<Product>? favProds,
  }) =>
      FavouriteState(
        favListStatus: favListStatus ?? this.favListStatus,
        setFavStatus: setFavStatus ?? this.setFavStatus,
        setUnFavStatus: setUnFavStatus ?? this.setUnFavStatus,
        favProds: favProds ?? this.favProds,
      );
      
  @override
  List<Object?> get props => [
        favListStatus,
        setFavStatus,
        setUnFavStatus,
        favProds,
      ];
}
