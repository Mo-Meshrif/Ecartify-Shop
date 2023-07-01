import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required String id,
    required String name,
    required String image,
    bool hasSub = false,
  }) : super(
          id: id,
          name: name,
          image: image,
          hasSub: hasSub,
        );
  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) =>
      CategoryModel(
        id: snapshot.id,
        name: snapshot.get('name'),
        image: snapshot.get('image'),
        hasSub: (snapshot.data() as Map).containsKey('has-sub')
            ? snapshot.get('has-sub')
            : false,
      );
}
