import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/services/tour_post/tour_post_service.dart';
import '../../../utils/popups/loaders.dart';
import '../models/user_post_model.dart';

class PostController extends GetxController {
  final isLoading = false.obs;
  final postService = Get.put(TourPostService());

  static PostController get instance => Get.find();
  RxList<PostModel> featurePost = <PostModel>[].obs;

  @override
  void onInit() {
    fetchFeatureProducts();
    super.onInit();
  }

  void fetchFeatureProducts() async {
    try {
      isLoading.value = true;

      final posts = await postService.fetchPostData();

      featurePost.assignAll(posts);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Xảy ra lỗi rồi!',
          message: 'Đã xảy ra sự cố không xác định, vui lòng thử lại sau');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePost(String postId) async {
    bool deleted = await postService.deletePost(postId);
    if (deleted) {
      TLoaders.successSnackBar(
          title: 'Thành công', message: 'Bài viết đã được xóa');
      fetchFeatureProducts();
    } else {
      TLoaders.successSnackBar(
          title: 'Lỗi rồi',
          message: 'Bài viết chưa thể xóa, vui lòng thử lại sau.');
    }
  }

  Future<void> addComment(String content, String postId) async {
    try {
      isLoading.value = true;
      final success = await postService.addComment(content, postId);

      if (success) {
        fetchFeatureProducts();
      } else {
        TLoaders.errorSnackBar(
            title: 'Lỗi rồi',
            message: 'Đã xảy ra lỗi khi thêm bình luận, vui lòng thử lại sau.');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Lỗi rồi',
          message: 'Đã xảy ra lỗi khi thêm bình luận, vui lòng thử lại sau.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createPost(String content, List<File> photoFiles) async {
    try {
      bool success = await postService.createPost(content, photoFiles);
      return success;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Lỗi rồi',
          message: 'Xảy ra lỗi khi tạo bào viết vui lòng thử lại sau.');
      if (kDebugMode) {
        print('Error when create a new post: + $e');
      }
      return false;
    }
  }
}
