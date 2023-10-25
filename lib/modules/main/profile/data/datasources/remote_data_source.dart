import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../auth/data/models/user_model.dart';

abstract class BaseProfileRemoteDataSource {
  Future<UserModel?> getUserData();
}

class ProfileRemoteDataSource implements BaseProfileRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  ProfileRemoteDataSource(this.firebaseFirestore);

  @override
  Future<UserModel?> getUserData() async {
    try {
      String? uid = HelperFunctions.getSavedUser()?.id;
      if (uid != null) {
        DocumentSnapshot<Map<String, dynamic>> querySnapshot =
            await firebaseFirestore
                .collection(AppConstants.usersCollection)
                .doc(uid)
                .get();
        return UserModel.fromSnapshot(querySnapshot);
      } else {
        return null;
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
