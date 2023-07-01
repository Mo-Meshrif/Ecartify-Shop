part of 'favourite_bloc.dart';

abstract class FavouriteEvent extends Equatable {
  const FavouriteEvent();

  @override
  List<Object> get props => [];
}

class GetFavouritesEvent extends FavouriteEvent {}

class SetFavourite extends FavouriteEvent {
  final Product prod;
  const SetFavourite({required this.prod});
}

class SetUnFavourite extends FavouriteEvent {
  final Product prod;
  const SetUnFavourite({required this.prod});
}
