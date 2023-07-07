import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../product/domain/usecases/get_product_details_use_case.dart';
import '../../../product/presentation/controller/product_bloc.dart';
import '../../domain/entities/notification.dart';
import '../../domain/usecases/delete_notification_use_case.dart';
import '../../domain/usecases/get_notification_details_use_case.dart';
import '../../domain/usecases/get_notifications_use_case.dart';
import '../../domain/usecases/get_un_read_notification_num_use_case.dart';
import '../../domain/usecases/read_notification_use_case.dart';
import '../widgets/notification_details_widget.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final GetUnReadNotificationUseCase getUnReadNotificationUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final ReadNotificationUseCase readNotificationUseCase;
  final GetNotificationDetailsUseCase getNotificationDetailsUseCase;
  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.getUnReadNotificationUseCase,
    required this.deleteNotificationUseCase,
    required this.readNotificationUseCase,
    required this.getNotificationDetailsUseCase,
  }) : super(const NotificationState()) {
    on<GetNotificationsEvent>(_getNotifications);
    on<GetUnReadNotificationEvent>(_getUnReadNotification);
    on<DeleteNotificationEvent>(_deleteNotification);
    on<HandleNotificationClick>(_handleNotificationClick);
    on<ReadNotificationEvent>(_readNotification);
    on<GetNotificationDetailsEvent>(_getNotificationDetails);
  }

  FutureOr<void> _getNotifications(
      GetNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(
      notificationStatus: Status.loading,
      unReadNumStatus: Status.sleep,
    ));
    Either<Failure, List<Notification>> result =
        await getNotificationsUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          notificationStatus: Status.error,
          notificationList: [],
        ),
      ),
      (notificationList) => emit(
        state.copyWith(
          notificationStatus: Status.loaded,
          notificationList: notificationList,
        ),
      ),
    );
  }

  FutureOr<void> _getUnReadNotification(
      GetUnReadNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(
      unReadNumStatus: Status.loading,
      readNotificationStatus: Status.sleep,
    ));
    Either<Failure, int> result =
        await getUnReadNotificationUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          unReadNumStatus: Status.error,
          unReadNum: '0',
        ),
      ),
      (val) => emit(
        state.copyWith(
          unReadNumStatus: Status.loaded,
          unReadNum: val.toString(),
        ),
      ),
    );
  }

  FutureOr<void> _deleteNotification(
      DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(
      deleteNotificationStatus: Status.loading,
      unReadNumStatus: Status.sleep,
    ));
    Either<Failure, void> result = await deleteNotificationUseCase(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteNotificationStatus: Status.error,
          msg: failure.msg,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteNotificationStatus: Status.loaded,
          deleteNotificationId: event.id,
        ),
      ),
    );
  }

  FutureOr<void> _handleNotificationClick(
      HandleNotificationClick event, Emitter<NotificationState> emit) {
    if (event.notification.pageType == 'product') {
      event.context.read<ProductBloc>().add(
            GetProductDetailsEvent(
              productDetailsParmeters: ProductDetailsParmeters(
                productId: event.notification.url,
              ),
            ),
          );
      NavigationHelper.pushNamed(
        event.context,
        Routes.productDetailsRoute,
      );
    } else {
      material.showModalBottomSheet(
        context: event.context,
        shape: material.RoundedRectangleBorder(
          borderRadius: material.BorderRadius.only(
            topLeft: material.Radius.circular(AppSize.s15.r),
            topRight: material.Radius.circular(AppSize.s15.r),
          ),
        ),
        constraints: material.BoxConstraints(
          minHeight: 1.sh * 0.3,
          maxHeight: 1.sh * 0.85,
        ),
        builder: (context) => NotificationDetailsWidget(
          notification: event.notification,
        ),
      );
    }
    if (event.notification.status == '1') {
      add(
        ReadNotificationEvent(
          updateNotification: UpdateNotification(
            notification: event.notification,
          ),
        ),
      );
    }
  }

  FutureOr<void> _readNotification(
      ReadNotificationEvent event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(
      readNotificationStatus: Status.loading,
      unReadNumStatus: Status.sleep,
    ));
    Either<Failure, void> result = await readNotificationUseCase(
      event.updateNotification,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          readNotificationStatus: Status.error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          readNotificationStatus: Status.loaded,
          readNotificationId: event.updateNotification.notification.id,
        ),
      ),
    );
  }

  FutureOr<void> _getNotificationDetails(GetNotificationDetailsEvent event,
      Emitter<NotificationState> emit) async {
    emit(state.copyWith(
      notificationDetailsStatus: Status.loading,
      unReadNumStatus: Status.sleep,
    ));
    Either<Failure, Notification> result =
        await getNotificationDetailsUseCase(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          notificationDetailsStatus: Status.error,
          deleteNotificationStatus: null,
        ),
      ),
      (notification) => emit(
        state.copyWith(
          notificationDetailsStatus: Status.loaded,
          notificationDetails: notification,
        ),
      ),
    );
  }
}
