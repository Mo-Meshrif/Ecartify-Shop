import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../models/slider_banner_model.dart';

abstract class BaseShopRemoteDataSource {
  Future<List<SliderBannerModel>> getSliderBanners();
}

class ShopRemoteDataSource implements BaseShopRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  ShopRemoteDataSource(this.firebaseFirestore);
  
  @override
  Future<List<SliderBannerModel>> getSliderBanners() async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Banners');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.orderBy('date_added', descending: true).get();
      return querySnapshot.docs
          .map((e) => SliderBannerModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
