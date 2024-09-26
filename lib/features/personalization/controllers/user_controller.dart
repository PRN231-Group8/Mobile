import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();



  /// Save user Record from any Registration provider
  // Future<void> saveUserRecord(UserCredential? userCredentials) async {
  //   try {
  //     if (userCredentials != null) {
  //       // Convert Name to First and Last Name
  //       final nameParts =
  //           UserModel.nameParts(userCredentials.user!.displayName ?? '');
  //       final username =
  //           UserModel.generateUsername(userCredentials.user!.displayName ?? '');
  //
  //       List<String> roles = ["user"];
  //
  //       final user = UserModel(
  //         id: userCredentials.user!.uid,
  //         firstName: nameParts[0],
  //         lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
  //         email: userCredentials.user!.email ?? '',
  //         phoneNumber: userCredentials.user!.phoneNumber ?? '',
  //         profilePicture: userCredentials.user!.photoURL ?? '',
  //         roles: roles,
  //       );
  //
  //       await userRepository.saveUserRecord(user);
  //     }
  //   } catch (e) {
  //     TLoaders.warningSnackBar(
  //       title: 'Dữ liệu chưa được lưu',
  //       message:
  //           'Đã xảy ra lỗi khi lưu thông tin của bạn. Bạn có thể lưu lại dữ liệu trong hồ sơ của mình.',
  //     );
  //   }
  // }
}
