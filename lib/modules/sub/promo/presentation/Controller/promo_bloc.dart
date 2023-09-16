import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../domain/entities/promo.dart';
import '../../domain/usecases/check_promo_code_use_case.dart';

part 'promo_event.dart';
part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final CheckPromoCodeUseCase checkPromoCodeUseCase;
  PromoBloc({required this.checkPromoCodeUseCase}) : super(const PromoState()) {
    on<CheckPromoCodeEvent>(_checkPromoCode);
  }

  FutureOr<void> _checkPromoCode(
      CheckPromoCodeEvent event, Emitter<PromoState> emit) async {
    emit(
      state.copyWith(
        checkPromoCodeStatus: Status.loading,
      ),
    );
    Either<Failure, Promo> result = await checkPromoCodeUseCase(
      event.promoCode,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          checkPromoCodeStatus: Status.error,
          promoResult: null,
        ),
      ),
      (val) => emit(
        state.copyWith(
          checkPromoCodeStatus: Status.loaded,
          promoResult: val,
        ),
      ),
    );
  }
}
