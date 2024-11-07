import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/effects/shimmer_effect.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../personalization/controllers/user_controller.dart';
import 'create_post.dart';

class THomeAppbar extends StatelessWidget {
  const THomeAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.homeAppBarTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: TColors.grey)),
          Obx(() {
            if (userController.profileLoading.value) {
              return const TShimmerEffect(width: 200, height: 20);
            } else {
              return Text(
                  '${userController.firstName.text} ${userController.lastName.text}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .apply(color: TColors.white));
            }
          }),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => Get.to(const CreatePostScreen()),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: TColors.darkGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.add,
              color: TColors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
