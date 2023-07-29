import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/usecases/delete_use_case.dart';
import '../../../auth/domain/usecases/logout_use_case.dart';
import '../../domain/usecases/get_user_data_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserDataUseCase getUserDataUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteUseCase deleteUseCase;
  ProfileBloc({
    required this.getUserDataUseCase,
    required this.logoutUseCase,
    required this.deleteUseCase,
  }) : super(const ProfileState()) {
    on<GetUserData>(_getUserData);
    on<LogoutEvent>(_logout);
    on<DeleteEvent>(_delete);
  }

  FutureOr<void> _getUserData(
      GetUserData event, Emitter<ProfileState> emit) async {
    emit(
      state.copyWith(
        userStatus: Status.loading,
      ),
    );
    Either<Failure, AuthUser> result =
        await getUserDataUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          userStatus: Status.error,
        ),
      ),
      (user) => emit(
        state.copyWith(userStatus: Status.loaded, user: user),
      ),
    );
  }

  FutureOr<void> _logout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(
      state.copyWith(
        userStatus: Status.sleep,
        deleteUserStatus: Status.sleep,
        logoutStatus: Status.loading,
      ),
    );
    final Either<Failure, void> result = await logoutUseCase(state.user!.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          logoutStatus: Status.error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          logoutStatus: Status.loaded,
        ),
      ),
    );
  }

  FutureOr<void> _delete(DeleteEvent event, Emitter<ProfileState> emit) async {
    emit(
      state.copyWith(
        userStatus: Status.sleep,
        logoutStatus: Status.sleep,
        deleteUserStatus: Status.loading,
      ),
    );
    final Either<Failure, void> result = await deleteUseCase(state.user!);
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteUserStatus: Status.error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteUserStatus: Status.loaded,
        ),
      ),
    );
  }
}
