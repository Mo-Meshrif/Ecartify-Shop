import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../domain/usecases/read_notification_use_case.dart';
import '../models/notification_model.dart';

abstract class BaseNotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotificationsList();
  Future<int> getUnReadNotificationNum();
  Future<void> deleteNotification(String id);
  Future<void> readNotification(UpdateNotification updateNotification);
  Future<NotificationModel> getNotificationDetails(String id);
}

class NotificationRemoteDataSource implements BaseNotificationRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  NotificationRemoteDataSource(this.firebaseFirestore);

  @override
  Future<int> getUnReadNotificationNum() async {
    try {
      String? uid = _getUserId();
      if (uid != null) {
        CollectionReference<Map<String, dynamic>> collection =
            firebaseFirestore.collection('Notifications');
        AggregateQuerySnapshot aggregateQuerySnapshot = await collection
            .where('to', isEqualTo: uid)
            .where('status', isEqualTo: '1')
            .count()
            .get();
        return aggregateQuerySnapshot.count;
      } else {
        return 0;
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<List<NotificationModel>> getNotificationsList() async {
    try {
      String? uid = _getUserId();
      if (uid != null) {
        CollectionReference<Map<String, dynamic>> collection =
            firebaseFirestore.collection('Notifications');
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
            .where('to', isEqualTo: _getUserId())
            .orderBy('date-added', descending: true)
            .get();
        return querySnapshot.docs
            .map((e) => NotificationModel.fromSnapshot(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<NotificationModel> getNotificationDetails(String id) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Notifications');
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await collection.doc(id).get();
      return NotificationModel.fromSnapshot(documentSnapshot);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> readNotification(UpdateNotification updateNotification) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Notifications');
      return await collection
          .doc(updateNotification.notification.id)
          .update(updateNotification.toJson());
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Notifications');
      return await collection.doc(id).delete();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  String? _getUserId() => HelperFunctions.getSavedUser()?.id;
}
