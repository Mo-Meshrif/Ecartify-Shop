import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import '../models/order_model.dart';

abstract class BaseOrderRemoteDataSource {
  Future<OrderModel> addOrder(OrderModel orderModel);
  Future<List<OrderModel>> getOrders(OrderParmeters orderParmeters);
}

class OrderRemoteDataSource implements BaseOrderRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  OrderRemoteDataSource(this.firebaseFirestore);

  DocumentSnapshot? lastSnap;

  @override
  Future<OrderModel> addOrder(OrderModel orderModel) async {
    try {
      String? uid = _getUserId();
      if (uid != null) {
        CollectionReference<Map<String, dynamic>> collection =
            firebaseFirestore.collection('Orders');
        AggregateQuerySnapshot aggregateQuerySnapshot =
            await collection.count().get();
        int count = aggregateQuerySnapshot.count;
        Random random = Random();
        Timestamp dateAdded = Timestamp.now();
        Map<String, dynamic> json = orderModel.toJson()
          ..addAll(
            {
              'user-id':uid,
              'order_number': random.nextInt(500) + count,
              'date_added': dateAdded,
              'tracker': {
                AppStrings.pending: dateAdded,
                AppStrings.confirmed: '',
                AppStrings.underPrepare: '',
                AppStrings.readyToDelivered: '',
                AppStrings.inDelivered: '',
                AppStrings.delivered: '',
                AppStrings.canceled: '',
              },
            },
          );
        DocumentReference<Map<String, dynamic>> documentReference =
            await collection.add(
          json,
        );
        return OrderModel.fromJson(
          json
            ..addAll(
              {
                'id': documentReference.id,
              },
            ),
        );
      } else {
        throw ServerExecption(AppStrings.operationFailed.tr());
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getOrders(OrderParmeters orderParmeters) async {
    try {
      String? uid = _getUserId();
      if (uid != null) {
        Query<Map<String, dynamic>> query = firebaseFirestore
            .collection('Orders')
            .where('user-id', isEqualTo: uid);
        query = orderParmeters.orderType == OrderType.ongoing
            ? query.where('status', isNotEqualTo: 'delivered').orderBy('status')
            : query.where('status', isEqualTo: 'delivered');
        late QuerySnapshot<Map<String, dynamic>> querySnapshot;
        if (lastSnap == null || orderParmeters.start == 0) {
          querySnapshot = await query
              .orderBy(
                'date_added',
                descending: true,
              )
              .limit(5)
              .get();
        } else {
          querySnapshot = await query
              .orderBy('date_added', descending: true)
              .startAfterDocument(lastSnap!)
              .limit(5)
              .get();
        }
        lastSnap = querySnapshot.docs.last;
        return querySnapshot.docs.map((e) => OrderModel.fromSnap(e)).toList();
      } else {
        throw ServerExecption(AppStrings.operationFailed.tr());
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  String? _getUserId() => HelperFunctions.getSavedUser()?.id;
}
