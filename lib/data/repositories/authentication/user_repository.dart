import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Repository class for user-related operations.
class UserRepository extends GetxController {
  // static UserRepository get instance => Get.find();
  //
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  //
  // /// Function to save user data to Firestore.
  // Future<void> saveUserRecord(UserModel user) async {
  //   try {
  //     await _db.collection("Users").doc(user.id).set(user.toJson());
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }
  //
  // /// Function to fetch user data based on user id.
  // Future<UserModel?> getUserById(String uid) async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> snapshot =
  //     await _db.collection("Users").doc(uid).get();
  //     return UserModel.fromSnapshot(snapshot);
  //   } catch (e) {
  //     return null;
  //   }
  // }
}
