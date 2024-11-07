import 'package:explore_now/features/tour_post/screens/user_post/widgets/home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/post/product_card/post_card_horizontal.dart';
import '../../../../common/widgets/shimmers/horizontal_post_shimmer.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_post_controller.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  ///Appbar
                  SizedBox(height: TSizes.borderRadiusMd),
                  THomeAppbar(),
                  SizedBox(height: TSizes.borderRadiusLg),

                  ///Searchbar
                  TSearchContainer(
                    text: 'Tìm trong Explore Now',
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            ///Body
            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwItems),
              child: Column(
                children: [
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const TVerticalPostShimmer();
                    }
                    if (controller.featurePost.isEmpty) {
                      return Center(
                          child: Text(
                        'Không tìm thấy dữ liệu',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ));
                    }
                    return TGridLayout(
                        itemCount: controller.featurePost.length,
                        itemBuilder: (_, index) => TPostCardVertical(
                            post: controller.featurePost[index]));
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
