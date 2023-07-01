part of 'explore_bloc.dart';

class ExploreState extends Equatable {
  final Status catStatus;
  final List<Category> cats;
  final Status subCatStatus;
  final List<Category> subCats;

  const ExploreState({
    this.catStatus = Status.sleep,
    this.cats = const [],
    this.subCatStatus = Status.sleep,
    this.subCats = const [],
  });

  ExploreState copyWith({
    Status? catStatus,
    List<Category>? cats,
    Status? subCatStatus,
    List<Category>? subCats,
  }) =>
      ExploreState(
        catStatus: catStatus ?? this.catStatus,
        cats: cats ?? this.cats,
        subCatStatus: subCatStatus ?? this.subCatStatus,
        subCats: subCats ?? this.subCats,
      );
      
  @override
  List<Object?> get props => [
        catStatus,
        cats,
        subCatStatus,
        subCats,
      ];
}
