part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesEvent extends ExploreEvent {}

class GetSubCategoriesEvent extends ExploreEvent {
  final String catId;
  const GetSubCategoriesEvent({required this.catId});
}
