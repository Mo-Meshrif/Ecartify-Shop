import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../models/user_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<UserModel> signIn(LoginInputs userInputs);
  Future<UserModel> signUp(SignUpInputs userInputs);
  Future<bool> forgetPassord(String email);
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource {
  final FirebaseMessaging firebaseMessaging;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource(
    this.firebaseMessaging,
    this.firebaseFirestore,
    this.firebaseAuth,
  );

  @override
  Future<UserModel> signIn(LoginInputs userInputs) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: userInputs.email,
        password: userInputs.password,
      );
      final UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        email: userInputs.email,
        password: HelperFunctions.encrptPassword(userInputs.password),
        deviceToken: await _getDeviceToken(),
      );
      return _uploadDataToFireStore(userModel);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<UserModel> signUp(SignUpInputs userInputs) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: userInputs.email,
        password: userInputs.password,
      );
      final UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: userInputs.name,
        email: userInputs.email,
        password: HelperFunctions.encrptPassword(userInputs.password),
        deviceToken: await _getDeviceToken(),
      );
      return _uploadDataToFireStore(userModel);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<bool> forgetPassord(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<String> _getDeviceToken() async {
    String? value = await firebaseMessaging.getToken();
    return value ?? AppConstants.emptyVal;
  }

  Future<UserModel> _uploadDataToFireStore(UserModel userModel) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _getUserDataFromFireStore(userModel.id);
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      var tempUser = userModel.copyWith(
        name: userModel.name.isEmpty ? doc.data()['name'] : userModel.name,
        pic: doc.data()['pic'],
      );
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .doc(doc.id)
          .update(tempUser.toJson());
      return tempUser;
    } else {
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .add(userModel.toJson());
      return userModel;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getUserDataFromFireStore(
          String uid) =>
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .where(AppConstants.userIdFeild, isEqualTo: uid)
          .get();
}
