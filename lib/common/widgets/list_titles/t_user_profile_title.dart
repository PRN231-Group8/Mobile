import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';

class TUserProfileTitle extends StatelessWidget {
  const TUserProfileTitle({
    super.key,
    required this.onPressed,
    required this.fullName,
    required this.email,
    required this.profilePicture,
    required this.isNetworkImage,
  });

  final VoidCallback onPressed;
  final String fullName;
  final String email;
  final String profilePicture;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: profilePicture.isNotEmpty && isNetworkImage
            ? NetworkImage(profilePicture)
            : const AssetImage(TImages.userImage2) as ImageProvider,
        radius: 30, // Adjust radius if needed
      ),
      title: Text(fullName,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: TColors.white)),
      subtitle: Text(email,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .apply(color: TColors.white)),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(Iconsax.edit),
        color: TColors.white,
        iconSize: 25,
      ),
    );
  }
}
