part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final String msg;
  final Status notificationStatus;
  final List<Notification> notificationList;
  final Status unReadNumStatus;
  final String unReadNum;
  final Status deleteNotificationStatus;
  final String deleteNotificationId;
  final Status readNotificationStatus;
  final String readNotificationId;
  final Status notificationDetailsStatus;
  final Notification? notificationDetails;

  const NotificationState({
    this.msg = '',
    this.notificationStatus = Status.sleep,
    this.notificationList = const [],
    this.unReadNumStatus = Status.sleep,
    this.unReadNum = '0',
    this.deleteNotificationStatus = Status.sleep,
    this.deleteNotificationId = '',
    this.readNotificationStatus = Status.sleep,
    this.readNotificationId = '',
    this.notificationDetailsStatus = Status.sleep,
    this.notificationDetails,
  });
  NotificationState copyWith({
    String? msg,
    Status? notificationStatus,
    List<Notification>? notificationList,
    bool? isNotificationsMax,
    Status? unReadNumStatus,
    String? unReadNum,
    Status? deleteNotificationStatus,
    String? deleteNotificationId,
    Status? readNotificationStatus,
    String? readNotificationId,
    Status? notificationDetailsStatus,
    Notification? notificationDetails,
  }) =>
      NotificationState(
        msg: msg ?? this.msg,
        notificationStatus: notificationStatus ?? this.notificationStatus,
        notificationList: notificationList ?? this.notificationList,
        unReadNumStatus: unReadNumStatus ?? this.unReadNumStatus,
        unReadNum: unReadNum ?? this.unReadNum,
        deleteNotificationStatus:
            deleteNotificationStatus ?? this.deleteNotificationStatus,
        deleteNotificationId: deleteNotificationId ?? this.deleteNotificationId,
        readNotificationStatus:
            readNotificationStatus ?? this.readNotificationStatus,
        readNotificationId: readNotificationId ?? this.readNotificationId,
        notificationDetailsStatus:
            notificationDetailsStatus ?? this.notificationDetailsStatus,
        notificationDetails: notificationDetails ?? this.notificationDetails,
      );
  @override
  List<Object?> get props => [
        msg,
        notificationStatus,
        notificationList,
        unReadNumStatus,
        unReadNum,
        deleteNotificationStatus,
        deleteNotificationId,
        readNotificationStatus,
        readNotificationId,
        notificationDetailsStatus,
        notificationDetails,
      ];
}
