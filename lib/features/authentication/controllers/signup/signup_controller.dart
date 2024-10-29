import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../data/services/authentication/authentication_service.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///Variables
  final hidePassword = true.obs;
  final policy = true.obs;
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Đang xử lí chờ xíu...', TImages.screenLoadingSparkle2);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //policy check
      if (!policy.value) {
        TFullScreenLoader.stopLoading();
        TLoaders.warningSnackBar(
            title: 'Vui lòng chấp nhận điều khoản',
            message:
                'Những điều khoản về chính sách và bảo mật là cần thiết để sử dụng dịch vụ của chúng tôi');
        return;
      }

      var result = await AuthenticationService().handleSignUp(
        email: email.text,
        firstName: firstName.text,
        lastName: lastName.text,
        userName: userName.text,
        password: password.text,
      );

      TFullScreenLoader.stopLoading();
      if (result['success']) {
        TLoaders.successSnackBar(
            title: 'Thành công',
            message:
            'Tài khoản đã được tạo thành công vui lòng kiểm tra email để xác thực tài khoản.');
        Get.to(() => VerifyEmailScreen(email: email.text.trim()));
      }
      else {
        TLoaders.warningSnackBar(
            title: 'Ối đã xảy ra sự cố', message: result['message']);
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Xảy ra lỗi rồi!',
          message: 'Đã xảy ra sự cố không xác định, vui lòng thử lại sau');
    }
  }
}
