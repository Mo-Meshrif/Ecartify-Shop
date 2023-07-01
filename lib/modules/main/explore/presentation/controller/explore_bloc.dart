import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/helper/enums.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_sub_categories_use_case.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetSubCategoriesUseCase getSubCategoriesUseCase;
  ExploreBloc({
    required this.getCategoriesUseCase,
    required this.getSubCategoriesUseCase,
  }) : super(const ExploreState()) {
    on<GetCategoriesEvent>(_getCategories);
    on<GetSubCategoriesEvent>(_getSubCategories);
  }

  FutureOr<void> _getCategories(
      GetCategoriesEvent event, Emitter<ExploreState> emit) async {
    emit(state.copyWith(catStatus: Status.loading));
    var result = await getCategoriesUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          catStatus: Status.error,
          cats: [],
        ),
      ),
      (cats) => emit(
        state.copyWith(
          catStatus: Status.loaded,
          cats: cats,
        ),
      ),
    );
  }

  FutureOr<void> _getSubCategories(
      GetSubCategoriesEvent event, Emitter<ExploreState> emit) async {
    emit(state.copyWith(subCatStatus: Status.loading));
    var result = await getSubCategoriesUseCase(event.catId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          subCatStatus: Status.error,
          subCats: [],
        ),
      ),
      (subCats) => emit(
        state.copyWith(
          subCatStatus: Status.loaded,
          subCats: subCats,
        ),
      ),
    );
  }
}
