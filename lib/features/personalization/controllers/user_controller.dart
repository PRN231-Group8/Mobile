import 'package:explore_now/features/personalization/screens/settings/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/services/personalization/user_profile_service.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../screens/profile/profile.dart';

class UserController extends GetxController {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final dob = TextEditingController();
  final gender = TextEditingController();
  final email = TextEditingController();
  final userName = TextEditingController();
  final secureStorage = const FlutterSecureStorage();
  var userUpdateProfile = {}.obs;
  final profileLoading = false.obs;
  final imageUploading = false.obs;
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  ProfileScreenState? profileScreenState;

  var day = 1.obs;
  var month = 'Một'.obs;
  var year = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      profileLoading.value = true;

      var result = await UserProfileService().getUserProfile();

      if (result['success'] == true) {
        userUpdateProfile.value = result['data'];
        firstName.text = userUpdateProfile['result']['firstName'];
        lastName.text = userUpdateProfile['result']['lastName'];
        dob.text = userUpdateProfile['result']['dob']?.toString() ?? '';
        gender.text = userUpdateProfile['result']['gender']?.toString() ?? '';
        email.text = (await secureStorage.read(key: 'user_email'))!;
        userName.text = (await secureStorage.read(key: 'user_name'))!;
        profileLoading.value = false;
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> updateUserProfile() async {
    if (profileFormKey.currentState?.validate() ?? false) {
      var updatedFields = {
        "firstName": firstName.text,
        "lastName": lastName.text,
        "dob": dob.text,
        "gender": gender.text,
        "avatarPath": userUpdateProfile['result']?['avatarPath'],
      };

      final result =
          await UserProfileService().updateUserProfile(updatedFields);
      if (result['success'] == true) {
        await loadUserProfile();
        Get.off(() => const ProfileScreen());
        TLoaders.successSnackBar(
            title: 'Thành công', message: 'Cập nhật thành công');
      } else {
        TLoaders.errorSnackBar(
            title: 'Xảy ra lỗi rồi!', message: result['message']);
      }
    }
  }

  Future<void> handleImageProfileUpload() async {
    try {
      imageUploading.value = true;
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxHeight: 1200,
          maxWidth: 1200);

      ///can do a image crop right here
      if (image != null) {
        TFullScreenLoader.openLoadingDialog(
            'Đang xử lí chờ xíu...', TImages.screenLoadingSparkle4);

        final result =
            await UserProfileService().updateUserProfilePicture(image);
        imageUploading.value = false;
        TFullScreenLoader.stopLoading();

        if (result['success'] == true) {
          TLoaders.successSnackBar(
              title: 'Thành công', message: 'Cập nhật ảnh đại diện thành công');
          await loadUserProfile();
        } else {
          TLoaders.errorSnackBar(
              title: 'Xảy ra lỗi rồi!', message: result['message']);
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(
          title: 'Xảy ra lỗi rồi!',
          message: 'Đã xảy ra sự cố không xác định, vui lòng thử lại sau');
    } finally {
      imageUploading.value = false;
    }
  }
}
