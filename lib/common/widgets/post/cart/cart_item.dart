import 'package:flutter/material.dart';

import '../../../../features/tour_post/screens/user_post_detail/widgets/product_title.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../images/t_rounded_image.dart';
import '../../texts/product_title_text.dart';
import '../../texts/t_brand_title_text_with_verified_icon.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TRoundedImage(
          imageUrl: TImages.productImages1,
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes.xs),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),

        const SizedBox(width: TSizes.spaceBtwItems),

        ///Title, Price
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TBrandTitleWithVerifiedIcon(title: 'KGrill'),
              const Flexible(
                  child: TProductTitleText(
                      title:
                      'Combo Nướng GoGi Sườn Hoàng đế & Thăn nội bò Mỹ',
                      maxLines: 1)),

              ///Attribute
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Cho ',
                        style:
                        Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: '1-2 người',
                        style:
                        Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}