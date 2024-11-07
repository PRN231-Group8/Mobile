import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../effects/shimmer_effect.dart';
import '../layouts/grid_layout.dart';

class TVerticalPostShimmer extends StatelessWidget {
  const TVerticalPostShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return TGridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => const SizedBox(
        width: 380,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            TShimmerEffect(width: 380, height: 180),
            SizedBox(height: TSizes.spaceBtwItems),
            // Text
            TShimmerEffect(width: 380, height: 15),
            SizedBox(height: TSizes.spaceBtwItems / 2),
            TShimmerEffect(width: 380, height: 15),
          ],
        ),
      ),
    );
  }
}
