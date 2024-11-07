import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../../../utils/popups/loaders.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/user_post_controller.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  final postController = Get.put(PostController());

  void _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();

    List<File> pickedFiles = images.map((image) => File(image.path)).toList();

    String? sizeValidationMessage = TValidator.validateImageSize(pickedFiles);

    if (sizeValidationMessage != null) {
      TLoaders.warningSnackBar(
          title: 'Lỗi xác thực', message: sizeValidationMessage);
      return;
    }

    setState(() {
      _selectedImages = pickedFiles;
    });
  }

  void _submitPost() async {
    String? validationMessage = TValidator.validatePostContent(
      _contentController.text,
      _selectedImages.map((image) => image.path).toList(),
    );

    if (validationMessage != null) {
      TLoaders.warningSnackBar(
          title: 'Lỗi xác thực', message: validationMessage);
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    bool success = await postController.createPost(
      _contentController.text,
      _selectedImages,
    );

    Get.back();

    if (success) {
      TLoaders.successSnackBar(
          title: 'Thành công',
          message: 'Bài viết của bạn đã được tạo thành công!');
      _contentController.clear();
      setState(() {
        _selectedImages.clear();
      });
    } else {
      TLoaders.errorSnackBar(
          title: 'Lỗi rồi',
          message: 'Đã xảy ra lỗi khi tạo bài viết, vui lòng thử lại sau.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.image),
              label: const Text('Pick Images'),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: _selectedImages.map((image) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitPost,
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
