import 'package:explore_now/utils/constants/colors.dart';
import 'package:explore_now/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animations/animations.dart';
import 'features/home_screens/screens/home/home.dart';
import 'features/personalization/screens/settings/setting.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Obx(
        () => PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: controller.screens[controller.selectedIndex.value],
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(
            () => BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: (index) {
                if (index != 2) {
                  controller.selectedIndex.value = index;
                }
              },
              backgroundColor: dark ? TColors.black : TColors.white,
              selectedItemColor: dark ? TColors.white : TColors.black,
              unselectedItemColor: dark
                  ? TColors.white.withOpacity(0.5)
                  : TColors.black.withOpacity(0.5),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.calendar_1),
                  label: 'Điểm danh',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.chart_1),
                  label: 'Thống kê',
                ),
                BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.shop),
                  label: 'Cửa hàng',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.setting_2),
                  label: 'Thiết lập',
                ),
              ],
            ),
          ),
          // Corrected floating button with proper touch area alignment
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  controller.selectedIndex.value = 2;
                },
                child: Obx(
                  () => Transform.translate(
                    offset: const Offset(0, -20),
                    // Adjust the offset to raise the button
                    child: AnimatedScale(
                      scale: controller.selectedIndex.value == 2 ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: CircleAvatar(
                        radius: 35, // Adjust size
                        backgroundColor: TColors.primary,
                        child: Image.asset(
                          'assets/logos/explore-now-logo.png',
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    Container(color: Colors.purple),
    Container(color: Colors.yellow),
    Container(color: Colors.green),
    const SettingsScreen(),
  ];
}
