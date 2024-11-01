import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/services/authentication/authentication_service.dart';
import '../../../../navigation_dart.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/user_controller.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final userName = TextEditingController();
  final password = TextEditingController();
  final secureStorage = const FlutterSecureStorage();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final userController = Get.put(UserController());

  @override
  void onInit() {
    userName.text = localStorage.read("REMEMBER_ME_EMAIL") ?? '';
    password.text = localStorage.read("REMEMBER_ME_PASSWORD") ?? '';
    super.onInit();
  }

  Future<void> userNameAndPasswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Đang xử lí chờ xíu...', TImages.screenLoadingSparkle2);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
            title: 'No Internet', message: 'Please check your connection.');
        return;
      }

      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write("REMEMBER_ME_EMAIL", userName.text.trim());
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      }

      final result = await AuthenticationService().handleSignIn(
        userName: userName.text,
        password: password.text,
      );

      TFullScreenLoader.stopLoading();

      if (result['success'] == true) {
        final accessToken = result['data']['token'];
        final userId = result['data']['userId'];
        await secureStorage.write(key: 'user_id', value: userId);
        await secureStorage.write(key: 'user_name', value: userName.text.trim());
        try {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
          String? userRole = decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

          // Navigate based on user role
          if (userRole == 'CUSTOMER') {
            TLoaders.successSnackBar(
                title: 'Chào mừng quay trở lại!',
                message: 'Rất nhiều ưu đãi đang chờ đón bạn');
            Get.off(() => const NavigationMenu());
          } else if (userRole == 'SHIPPER') {
            TLoaders.successSnackBar(
                title: 'Chào mừng quay trở lại!',
                message: 'Rất nhiều ưu đãi đang chờ đón bạn');
            // Get.off(() => const ShipperNavigationMenu());
          } else {
            TLoaders.errorSnackBar(
                title: 'Lỗi phân quyền',
                message: 'Không thể xác định vai trò người dùng');
          }
        } catch (e) {
          TLoaders.errorSnackBar(
              title: 'JWT Parsing Error',
              message: 'Failed to parse JWT token: $e');
        }
      } else if (result['success'] == false) {
        TLoaders.warningSnackBar(
          title: 'Xác thực không thành công',
          message: result['message'] ?? 'Email/Mật khẩu không chính xác',
        );
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Lỗi', message: 'Đã xảy ra lỗi: $e');
    }
  }

  Future<void> googleSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Đang xử lí chờ xíu...', TImages.screenLoadingSparkle2);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // final userCredentials =
      //     await AuthenticationRepository.instance.signInWithGoogle();

      // await userController.saveUserRecord(userCredentials);

      TFullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      TLoaders.errorSnackBar(
          title: 'Xảy ra lỗi rồi!',
          message: 'Đã xảy ra sự cố không xác định, vui lòng thử lại sau');
    }
  }
}