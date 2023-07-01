import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/shared_helper.dart';
import '../../../../sub/product/domain/entities/product.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final AppShared appShared;
  final GetCustomProductsUseCase getCustomProductsUseCase;
  FavouriteBloc({
    required this.appShared,
    required this.getCustomProductsUseCase,
  }) : super(const FavouriteState()) {
    on<GetFavouritesEvent>(_getFavourites);
    on<SetFavourite>(
      _setFavourite,
      transformer: sequential(),
    );
    on<SetUnFavourite>(
      _setUnFavourite,
      transformer: sequential(),
    );
  }

  FutureOr<void> _getFavourites(
      GetFavouritesEvent event, Emitter<FavouriteState> emit) async {
    emit(state.copyWith(favListStatus: Status.loading));
    List sharedList = _getFavIds();
    if (sharedList.isEmpty) {
      emit(
        state.copyWith(
          favListStatus: Status.error,
          favProds: [],
        ),
      );
    } else {
      Either<Failure, List<Product>> result = await getCustomProductsUseCase(
        ProductsParmeters(
          ids: List<String>.from(sharedList),
        ),
      );
      result.fold(
        (_) => emit(
          state.copyWith(
            favListStatus: Status.error,
            favProds: [],
          ),
        ),
        (prods) => emit(
          state.copyWith(
            favListStatus: Status.loaded,
            favProds: prods,
          ),
        ),
      );
    }
  }

  FutureOr<void> _setFavourite(
      SetFavourite event, Emitter<FavouriteState> emit) {
    try {
      emit(
        state.copyWith(
          setFavStatus: Status.loading,
          setUnFavStatus: Status.sleep,
          favListStatus: Status.updated,
        ),
      );
      List sharedList = _getFavIds();
      appShared.setVal('Fav-key', sharedList..insert(0, event.prod.id));
      emit(
        state.copyWith(
          setFavStatus: Status.loaded,
          favProds: state.favProds..insert(0, event.prod),
        ),
      );
    } catch (e) {
      emit(state.copyWith(setFavStatus: Status.error));
    }
  }

  FutureOr<void> _setUnFavourite(
      SetUnFavourite event, Emitter<FavouriteState> emit) {
    try {
      emit(
        state.copyWith(
          setUnFavStatus: Status.loading,
          setFavStatus: Status.sleep,
          favListStatus: Status.updated,
        ),
      );
      List sharedList = _getFavIds();
      appShared.setVal('Fav-key', sharedList..remove(event.prod.id));
      emit(
        state.copyWith(
          setUnFavStatus: Status.loaded,
          favProds: state.favProds.isEmpty ? [] : state.favProds
            ..removeWhere(
              (element) => element.id == event.prod.id,
            ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(setUnFavStatus: Status.error));
    }
  }

  List _getFavIds() => appShared.getVal('Fav-key') ?? [];
}
