import 'package:explore_now/features/personalization/screens/profile/widgets/change_date_of_birth.dart';
import 'package:explore_now/features/personalization/screens/profile/widgets/change_gender.dart';
import 'package:explore_now/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:explore_now/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/effects/shimmer_effect.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../data/services/personalization/user_profile_service.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final UserProfileService _userService = UserProfileService();
  final userController = Get.put(UserController());
  Map<String, dynamic>? userProfile;
  ScaffoldMessengerState? _scaffoldMessengerState;
  final secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(UserController());
    controller.profileScreenState = this;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    var result = await _userService.getUserProfile();
    if (result['success']) {
      setState(() {
        userProfile = result['data'];
      });
    } else {
      _scaffoldMessengerState?.showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  Future<void> loadUserProfile() async {
    await _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    String dobString = userController.dob.text;
    String formattedDob = '';
    if (dobString.isNotEmpty) {
      DateTime dob = DateTime.parse(dobString);
      formattedDob = DateFormat('dd-MM-yyyy').format(dob);
    }
    final Map<String, String> genderDisplayMap = {
      'Male': 'Nam',
      'Female': 'Nữ',
      'Other': 'Khác',
    };
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Tài Khoản & Bảo Mật'),
        showBackArrow: true,
      ),
      body: Obx(
        () {
          if (userController.profileLoading.value || userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                child: Column(
                  children: [
                    ///Profile Picture
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Obx(() {
                            final profilePicture = userController.userUpdateProfile['result']?['avatarPath'];
                            final networkImage = (profilePicture == null || profilePicture == "null")
                                ? TImages.userImage2
                                : profilePicture;

                            // Show shimmer effect while the image is uploading
                            if (userController.imageUploading.value) {
                              return const TShimmerEffect(width: 100, height: 100);
                            } else {
                              return CircleAvatar(
                                backgroundImage: (networkImage.isNotEmpty)
                                    ? NetworkImage(networkImage)
                                    : const AssetImage(TImages.userImage2) as ImageProvider,
                                radius: 50, // Adjust radius if needed
                              );
                            }
                          }),
                          TextButton(
                              onPressed: () =>
                                  controller.handleImageProfileUpload(),
                              child: const Text('Thay ảnh đại diện'))
                        ],
                      ),
                    ),

                    ///Details
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const TSectionHeading(
                        title: 'Hồ sơ của tôi', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    TProfileMenu(
                      onPressed: () {},
                      title: 'Tên tài khoản',
                      value: controller.userName.text,
                      icon: Iconsax.copy,
                      onIconPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: controller.userName.text),
                        );
                      },
                    ),
                    TProfileMenu(
                        onPressed: () => Get.to(() => const ChangeUserName()),
                        title: 'Tên đầy đủ',
                        value:
                            '${userController.firstName.text} ${userController.lastName.text}'),

                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const TSectionHeading(
                        title: 'Thông tin cá nhân', showActionButton: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TProfileMenu(
                      onPressed: () {},
                      title: 'Email',
                      value: userController.email.text,
                      icon: Iconsax.copy,
                      onIconPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: userProfile?['data']['email']),
                        );
                      },
                    ),
                    TProfileMenu(
                        onPressed: () => Get.to(() => const ChangeUserGender()),
                        title: 'Giới tính',
                        value: genderDisplayMap[controller.gender.text]),
                    TProfileMenu(
                        onPressed: () => Get.to(() => const ChangeUserDob()),
                        title: 'Ngày sinh',
                        value: formattedDob),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Vô hiệu hóa tài khoản',
                            style: TextStyle(color: Colors.red)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
