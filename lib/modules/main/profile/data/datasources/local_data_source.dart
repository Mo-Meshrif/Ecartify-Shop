import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/shared_helper.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../auth/data/models/user_model.dart';

abstract class BaseProfileLocalDataSource {
  Future<UserModel> getUserData();
  Future<void> saveUserData(UserModel user);
}

class ProfileLocalDataSource implements BaseProfileLocalDataSource {
  final AppShared appShared;
  ProfileLocalDataSource(this.appShared);

  @override
  Future<UserModel> getUserData() async {
    try {
      var savedData = appShared.getVal(AppConstants.userKey);
      return UserModel.fromJson(savedData);
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }

  @override
  Future<void> saveUserData(UserModel user) async {
    try {
      return appShared.setVal(AppConstants.userKey, user.toJson());
    } catch (e) {
      throw LocalExecption(e.toString());
    }
  }
}
