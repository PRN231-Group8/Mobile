import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../screens/login/login.dart';

class LogoutController extends GetxController {
  final storage = const FlutterSecureStorage();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> logout() async {
    try {
      //start loading
      TFullScreenLoader.openLoadingDialog(
          'Đang xử lí chờ xíu...', TImages.screenLoadingSparkle3);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      TFullScreenLoader.stopLoading();
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'user_id');
      await storage.delete(key: 'token_expiration');

      await googleSignIn.signOut();
      TLoaders.successSnackBar(
          title: 'Đăng xuất thành công',
          message: 'Bạn đã đăng xuất thành công');
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Đăng xuất thất bại',
          message: 'Đã xảy ra sự cố không xác định, vui lòng thử lại sau');
    }
  }
}
