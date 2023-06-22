import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/slider_banner.dart';

class SliderBannerModel extends SliderBanner {
  const SliderBannerModel({
    required String id,
    required String title,
    required String image,
    required String type,
    required String urlType,
    required String url,
  }) : super(
          id: id,
          title: title,
          image: image,
          type: type,
          urlType: urlType,
          url: url,
        );
  factory SliderBannerModel.fromSnapshot(DocumentSnapshot snapshot) =>
      SliderBannerModel(
        id: snapshot.id,
        title: snapshot.get('title'),
        image: snapshot.get('image'),
        type: snapshot.get('type'),
        urlType: snapshot.get('url_type'),
        url: snapshot.get('url'),
      );
}
