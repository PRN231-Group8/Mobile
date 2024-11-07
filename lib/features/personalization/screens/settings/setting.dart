import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/effects/shimmer_effect.dart';
import '../../../../common/widgets/list_titles/settings_menu_title.dart';
import '../../../../common/widgets/list_titles/t_user_profile_title.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/controllers/logout/logout_controller.dart';
import '../../controllers/user_controller.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _locationSharingEnabled = false;
  bool _notificationEnabled = false;
  bool _isNotificationLocked = false;
  bool _isLocationLocked = false;
  Map<String, dynamic>? userProfile;
  final logoutController = Get.put(LogoutController());
  final userController = Get.put(UserController());
  final secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _checkNotificationPermission();
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      setState(() {
        _locationSharingEnabled = true;
        _isLocationLocked = true;
      });
    } else if (status.isDenied || status.isRestricted) {
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    setState(() {
      _locationSharingEnabled = status.isGranted;
      _isLocationLocked = status.isGranted; // Lock if granted
    });
  }

  Future<void> _checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    setState(() {
      _notificationEnabled = status.isGranted;
      _isNotificationLocked = status.isGranted; // Lock if granted
    });
  }

  Future<void> _requestNotificationPermission() async {
    if (_notificationEnabled || _isNotificationLocked) return;

    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      setState(() {
        _notificationEnabled = true;
        _isNotificationLocked =
            true; // Lock the notification switch after enabling
      });
    } else if (status.isDenied || status.isRestricted) {
      _showNotificationPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // Show permission dialog for notifications
  void _showNotificationPermissionDialog() {
    Get.snackbar(
      'Thông báo bị tắt',
      'Bạn có thể mở lại thông báo từ cài đặt ứng dụng.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showPermissionDialog() {
    Get.defaultDialog(
      title: 'Vị trí hiện tại bị tắt',
      middleText:
          'Vị trí đã bị vô hiệu hóa vui lòng vào cài đặt để mở lại hoặc thử lại dưới đây',
      confirm: ElevatedButton(
        onPressed: () async {
          Navigator.of(Get.overlayContext!).pop();
          await _requestLocationPermission();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.primary,
          side: const BorderSide(color: Colors.blue),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: TSizes.lg),
          child: Text('Thử lại'),
        ),
      ),
      cancel: OutlinedButton(
        child: const Text('Hủy'),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ),
    );
  }

  Future<String?> getUserEmail() async {
    return await secureStorage.read(key: 'user_email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                      title: Text('Thiết lập tài khoản',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: TColors.white)),
                      showBackArrow: false),

                  ///User Profile Card
                  Obx(() {
                    final profilePicture = userController
                        .userUpdateProfile['result']?['avatarPath'];
                    final networkImage =
                        (profilePicture == null || profilePicture == "null")
                            ? TImages.userImage2
                            : profilePicture;

                    if (userController.profileLoading.value) {
                      return const TShimmerEffect(width: 300, height: 50);
                    } else {
                      return TUserProfileTitle(
                        onPressed: () => Get.to(() => const ProfileScreen()),
                        fullName:
                            '${userController.firstName.text} ${userController.lastName.text}',
                        // Ensure these are used correctly
                        email: userController.email.text,
                        profilePicture: networkImage,
                        isNetworkImage: !(profilePicture == null ||
                            profilePicture == "null"),
                      );
                    }
                  }),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            ///Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  ///Account Settings
                  const TSectionHeading(
                      title: 'Tài khoản', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TSettingsMenuTile(
                    icon: Iconsax.user_octagon,
                    title: 'Tài Khoản & Bảo Mật',
                    subtitle: 'Thiết lập tài khoản',
                    onTap: () => Get.to(() => const ProfileScreen()),
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'Địa Chỉ',
                    subtitle: 'Thiết lập địa chỉ giao hàng',
                    onTap: () {},
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'Giỏ Hàng',
                    subtitle: 'Chỉnh sửa giỏ hàng',
                    onTap: () {},
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.card,
                    title: 'Thẻ Ngân Hàng',
                    subtitle: 'Thiết lập phương thức thanh toán',
                    onTap: () {},
                  ),
                  TSettingsMenuTile(
                    icon: Iconsax.ticket_discount,
                    title: 'Mã Giảm Giá',
                    subtitle: 'Các mã giảm giá sẵn có',
                    onTap: () {},
                  ),
                  const TSectionHeading(
                      title: 'Cài đặt', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// Location Sharing Tile
                  TSettingsMenuTile(
                    icon: Iconsax.location_add,
                    title: 'Chia sẻ vị trí',
                    subtitle: 'Cài đặt vị trí hiện tại',
                    trailing: Switch(
                      value: _locationSharingEnabled,
                      onChanged: _isLocationLocked
                          ? null
                          : (value) async {
                              if (value) {
                                await _requestLocationPermission();
                              } else {
                                setState(() {
                                  _locationSharingEnabled = false;
                                });
                              }
                            },
                      activeColor:
                          _isLocationLocked ? Colors.grey : TColors.primary,
                      inactiveThumbColor: Colors.grey,
                    ),
                  ),

                  /// Notification Permission Tile
                  TSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: 'Thông Báo',
                    subtitle: 'Cho phép thông báo',
                    trailing: Switch(
                      value: _notificationEnabled,
                      onChanged: _isNotificationLocked
                          ? null
                          : (value) async {
                              if (value) {
                                await _requestNotificationPermission();
                              } else {
                                setState(() {
                                  _notificationEnabled = false;
                                });
                              }
                            },
                      activeColor:
                          _isNotificationLocked ? Colors.grey : TColors.primary,
                      inactiveThumbColor: Colors.grey,
                    ),
                  ),

                  TSettingsMenuTile(
                    icon: Iconsax.message_question,
                    title: 'Trung Tâm Trợ Giúp',
                    subtitle: 'Hỗ trợ đến từ nhân viên tư vấn',
                    onTap: () {},
                  ),

                  ///Logout
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => logoutAccountWarningPopup(),
                      child: const Text('Đăng xuất'),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void logoutAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Đăng xuất',
      middleText: 'Điều này sẽ đưa bạn trở về trang đăng nhập',
      confirm: ElevatedButton(
        onPressed: () async => logoutController.logout(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: TSizes.lg),
            child: Text('Đồng ý')),
      ),
      // ElevatedButton
      cancel: OutlinedButton(
        child: const Text('Hủy bỏ'),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
      ), // OutlinedButton
    );
  }
}
