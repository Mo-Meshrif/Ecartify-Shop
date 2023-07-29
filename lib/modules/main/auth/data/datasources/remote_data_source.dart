import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

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
  Future<UserModel> facebook();
  Future<UserModel> google();
  Future<UserModel> apple();
  Future<void> logout(String uid);
  Future<void> delete(UserModel userModel);
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource {
  final FirebaseMessaging firebaseMessaging;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSource(
    this.firebaseMessaging,
    this.firebaseFirestore,
    this.firebaseAuth,
    this.facebookAuth,
    this.googleSignIn,
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

  @override
  Future<UserModel> facebook() async {
    try {
      final LoginResult loginResult = await facebookAuth.login();
      final String accessToken = loginResult.accessToken!.token;
      final OAuthCredential faceCredential =
          FacebookAuthProvider.credential(accessToken);
      return _signInWithCredential(faceCredential);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<UserModel> google() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        return _signInWithCredential(googleCredential);
      } else {
        throw ServerExecption(AppConstants.nullError);
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<UserModel> apple() async {
    try {
      final String rawNonce = generateNonce();
      final String nonce = _sha256ofString(rawNonce);
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: AppConstants.appName,
          redirectUri: Uri.parse(AppConstants.redirectAndroidUri),
        ),
      );
      final OAuthCredential oauthCredential =
          OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      return _signInWithCredential(oauthCredential);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> logout(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _getUserDataFromFireStore(uid);
      if (querySnapshot.exists) {
        Map<String, dynamic> map = querySnapshot.data()!;
        map['deviceToken'] = '';
        firebaseFirestore
            .collection(AppConstants.usersCollection)
            .doc(querySnapshot.id)
            .update(map);
      }
      return await firebaseAuth.signOut();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> delete(UserModel userModel) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _getUserDataFromFireStore(userModel.id);
      if (querySnapshot.exists) {
        firebaseFirestore
            .collection(AppConstants.usersCollection)
            .doc(querySnapshot.id)
            .delete();
      }
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password!,
      );
      return await userCredential.user!.delete();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<String> _getDeviceToken() async {
    String? value = await firebaseMessaging.getToken();
    return value ?? AppConstants.emptyVal;
  }

  Future<UserModel> _uploadDataToFireStore(UserModel userModel) async {
    final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _getUserDataFromFireStore(userModel.id);
    if (querySnapshot.exists) {
      Map<String, dynamic>? doc = querySnapshot.data();
      if (doc != null) {
        var tempUser = userModel.copyWith(
          name: userModel.name.isEmpty ? doc['name'] : userModel.name,
          pic: doc['pic'],
          password: doc['pic'],
        );
        firebaseFirestore
            .collection(AppConstants.usersCollection)
            .doc(querySnapshot.id)
            .update(tempUser.toJson());
        return tempUser;
      } else {
        firebaseFirestore
            .collection(AppConstants.usersCollection)
            .doc(userModel.id)
            .set(userModel.toJson());
        return userModel;
      }
    } else {
      firebaseFirestore
          .collection(AppConstants.usersCollection)
          .doc(userModel.id)
          .set(userModel.toJson());
      return userModel;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getUserDataFromFireStore(
          String uid) =>
      firebaseFirestore.collection(AppConstants.usersCollection).doc(uid).get();

  Future<UserModel> _signInWithCredential(AuthCredential authCredential) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);
      final User? user = userCredential.user;
      final UserModel userModel = UserModel(
        id: user == null ? AppConstants.emptyVal : user.uid,
        name: user == null
            ? AppConstants.emptyVal
            : user.displayName ?? AppConstants.emptyVal,
        email: user == null
            ? AppConstants.emptyVal
            : user.email ?? AppConstants.emptyVal,
        pic: user == null
            ? AppConstants.emptyVal
            : user.photoURL ?? AppConstants.emptyVal,
        deviceToken: await _getDeviceToken(),
      );
      return _uploadDataToFireStore(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == AppConstants.differentCredential) {
        return _link(e.credential!);
      } else {
        throw ServerExecption(e.message.toString());
      }
    }
  }

  Future<UserModel> _link(AuthCredential authCredential) async {
    final UserCredential? userCredential =
        await firebaseAuth.currentUser?.linkWithCredential(authCredential);
    if (userCredential != null) {
      final User? user = userCredential.user;
      final UserModel userModel = UserModel(
        id: user == null ? AppConstants.emptyVal : user.uid,
        name: user == null
            ? AppConstants.emptyVal
            : user.displayName ?? AppConstants.emptyVal,
        email: user == null
            ? AppConstants.emptyVal
            : user.email ?? AppConstants.emptyVal,
        pic: user == null
            ? AppConstants.emptyVal
            : user.photoURL ?? AppConstants.emptyVal,
        deviceToken: await _getDeviceToken(),
      );
      _uploadDataToFireStore(userModel);
      return userModel;
    } else {
      throw ServerExecption(AppConstants.tryAgain);
    }
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
