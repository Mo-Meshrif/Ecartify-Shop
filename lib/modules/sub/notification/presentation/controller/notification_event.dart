part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {}

class GetUnReadNotificationEvent extends NotificationEvent {}

class DeleteNotificationEvent extends NotificationEvent {
  final String id;
  const DeleteNotificationEvent({required this.id});
}

class ReadNotificationEvent extends NotificationEvent {
  final UpdateNotification updateNotification;
  const ReadNotificationEvent({required this.updateNotification});
}

class GetNotificationDetailsEvent extends NotificationEvent {
  final String id;
  const GetNotificationDetailsEvent({required this.id});
}
