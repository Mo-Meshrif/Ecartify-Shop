import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required String id,
    required String pageType,
    required String url,
    required String status,
    required String dateAdded,
    required String title,
    required String content,
  }) : super(
          id: id,
          pageType: pageType,
          url: url,
          status: status,
          dateAdded: dateAdded,
          title: title,
          content: content,
        );
  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationModel(
        id: snapshot.id,
        pageType: snapshot.get('page-type'),
        url: snapshot.get('url'),
        status: snapshot.get('status'),
        dateAdded:
            (snapshot.get('date-added') as Timestamp).toDate().toString(),
        title: snapshot.get('title'),
        content: snapshot.get('content'),
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        pageType: json['page-type'],
        url: json['url'],
        status: json['status'],
        dateAdded: json['date-added'],
        title: json['title'],
        content: json['content'],
      );
}
