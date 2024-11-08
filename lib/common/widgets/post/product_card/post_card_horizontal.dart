import 'package:explore_now/features/tour_post/models/user_post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../features/tour_post/controllers/user_post_controller.dart';
import '../../../../features/tour_post/models/comment_model.dart';
import '../../../../features/tour_post/models/photo_model.dart';
import '../../../../features/tour_post/screens/user_post/widgets/post_images.dart';
import '../../../../features/tour_post/screens/user_post/widgets/update_post.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/encrypt/encrypt_device_id.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../icons/t_circular_icon.dart';
import '../../texts/product_title_text.dart';

class TPostCardVertical extends StatelessWidget {
  const TPostCardVertical({super.key, required this.post});

  final PostModel post;
  final secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    double getContainerPictureHeight(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;

      if (screenHeight >= 867) {
        return 236;
      } else if (screenHeight >= 835) {
        return 218;
      } else if (screenHeight >= 732) {
        return 200;
      } else {
        return 218;
      }
    }

    return GestureDetector(
      onTap: () => showPostDetailPopup(context, post),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.white,
        ),
        child: Column(
          children: [
            ///Thumbnail, Discount, Tag
            TRoundedContainer(
              height: getContainerPictureHeight(context),
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.grey,
              child: Stack(
                children: [
                  ///Thumbnail Image
                  CustomPostImage(
                    photos: post.photos,
                    onTap: () => showPostDetailPopup(context, post),
                  ),

                  /// -- More Icon Button
                  Positioned(
                    top: 2,
                    right: 2,
                    child: FutureBuilder<String?>(
                      future: secureStorage.read(key: 'user_id'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }

                        final currentUserId = snapshot.data;
                        final bool isOwner = post.user.id == currentUserId;

                        return PopupMenuButton<String>(
                          icon: Container(
                            decoration: const BoxDecoration(
                              color: TColors.darkerGrey,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Iconsax.more,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          onSelected: (value) {
                            if (value == 'Report') {
                              Get.snackbar('Report', 'Reported successfully.');
                            } else if (value == 'Delete' && isOwner) {
                              deletePostWarningPopup();
                            } else if (value == 'Delete' && !isOwner) {
                              Get.snackbar('Unauthorized',
                                  'You are not the owner of this post.');
                            } else if (value == 'Edit' && isOwner) {
                              Get.to(UpdatePostScreen(
                                postId: post.postsId,
                                initialContent: post.content,
                                initialImages: post.photos
                                    .map((photo) => {'id': photo.id, 'url': photo.url})
                                    .toList(),
                              ));
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'Report',
                              child: Row(
                                children: [
                                  Icon(Iconsax.warning_2, color: Colors.yellow),
                                  SizedBox(width: 8),
                                  Text('Báo cáo'),
                                ],
                              ),
                            ),
                            if (isOwner)
                              const PopupMenuItem(
                                value: 'Edit',
                                child: Row(
                                  children: [
                                    Icon(Iconsax.pen_add, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text('Chỉnh sửa bài viết'),
                                  ],
                                ),
                              ),
                            const PopupMenuItem(
                              value: 'Delete',
                              child: Row(
                                children: [
                                  Icon(Iconsax.trash, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Xóa bài viết'),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            ///Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: TSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  (post.user.profilePicture.isNotEmpty)
                                      ? NetworkImage(post.user.profilePicture)
                                      : const AssetImage(TImages.userImage2)
                                          as ImageProvider,
                              maxRadius: 18,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.user.fullName,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: dark ? TColors.white : TColors.black,
                              ),
                            ),
                            Text(
                              THelperFunctions.formatPostDate(post.createDate),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    TProductTitleText(
                      title: post.content,
                      smallSize: true,
                      maxLines: 1,
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TCircularIcon(
                            icon: Iconsax.like_1,
                            color: Colors.white,
                            height: 35,
                            width: 100,
                            size: 18,
                            text: "Thích",
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          // Add space between the icons
                          InkWell(
                            onTap: () =>
                                _showCommentsPopup(context, post.comments),
                            child: TCircularIcon(
                              icon: Iconsax.messages_3,
                              color: Colors.white,
                              height: 35,
                              width: 155,
                              size: 18,
                              text: "Bình luận (${post.comments.length})",
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.smallSpace / 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPostDetailPopup(BuildContext context, PostModel post) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.sm),
      title: post.user.fullName,
      content: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                post.content,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              if (post.photos.isNotEmpty)
                Column(
                  children: post.photos.map((photo) {
                    return GestureDetector(
                      onTap: () {
                        _showEnlargedImage(context, post.photos);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Image.network(
                          photo.url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(8),
          backgroundColor: TColors.primary,
        ),
        child: const Icon(Icons.close, size: 25),
      ),
      // You can add a cancel button if needed
    );
  }

  void _showEnlargedImage(BuildContext context, List<PhotoModel> photos) {
    PageController pageController = PageController(initialPage: 0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: photos.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(photos[index].url),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: const BouncingScrollPhysics(),
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                pageController: pageController,
              ),
              // Left arrow
              Positioned(
                left: 16,
                top: MediaQuery.of(context).size.height * 0.5 - 20,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    if (pageController.page!.toInt() > 0) {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
              // Right arrow
              Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height * 0.5 - 20,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    if (pageController.page!.toInt() < photos.length - 1) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCommentsPopup(BuildContext context, List<CommentModel> comments) {
    TextEditingController commentController = TextEditingController();
    final dark = THelperFunctions.isDarkMode(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Bình luận",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Comments list
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: (comment
                                                .user?.profilePicture !=
                                            null &&
                                        comment.user!.profilePicture.isNotEmpty)
                                    ? NetworkImage(comment.user!.profilePicture)
                                    : const AssetImage(TImages.userImage2)
                                        as ImageProvider,
                                radius: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment.user?.fullName ?? "User",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      comment.content,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      THelperFunctions.formatCommentTimestamp(
                                          comment.createdDate),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText:
                                  "Bình luận dưới tên ${post.user.fullName}",
                              filled: true,
                              fillColor: dark
                                  ? TColors.darkCommentBox
                                  : TColors.lightCommentBox,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 0.0, // No border line
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  width: 0.0, // No border line
                                  color: Colors.transparent,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color:  dark
                                ? Colors.white.withOpacity(0.6)
                                : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            if (commentController.text.trim().isNotEmpty) {
                              _addComment(commentController.text.trim());
                              commentController.clear();
                              Navigator.of(Get.overlayContext!).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addComment(String content) async {
    final postController = Get.put(PostController());
    postController.addComment(content, post.postsId);
    final postUserId = post.user.id;
    final currentUserId = await secureStorage.read(key: 'user_id');

    if (currentUserId != postUserId) {
      final encryptedDeviceId = post.user.deviceId;
      final decryptedDeviceId =
          TEncryptionUtils().decryptDeviceId(encryptedDeviceId);

      final senderName = await secureStorage.read(key: 'user_name');

      await postController.notifyUserOfNewComment(
          decryptedDeviceId, content, senderName!);
    }
  }

  void deletePostWarningPopup() {
    final postController = Get.put(PostController());
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Xóa bài viết',
      middleText: 'Thao tác này sẽ xóa bài đăng của bạn vĩnh viễn ',
      confirm: ElevatedButton(
        onPressed: () async {
          postController.deletePost(post.postsId);
          Get.back();
        },
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
