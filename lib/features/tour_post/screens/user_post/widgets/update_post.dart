import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../../../utils/popups/loaders.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/user_post_controller.dart';
import '../user_post.dart';

class UpdatePostScreen extends StatefulWidget {
  final String postId;
  final String initialContent;
  final List<Map<String, String>> initialImages;

  const UpdatePostScreen({
    super.key,
    required this.postId,
    required this.initialContent,
    required this.initialImages,
  });

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _newImages = [];
  List<Map<String, String>> _currentImages = []; // Update type
  final List<String> _imagesToRemove = [];
  final postController = Get.put(PostController());

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.initialContent;
    _currentImages = List.from(widget.initialImages);
  }

  void _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    List<File> pickedFiles = images.map((image) => File(image.path)).toList();

    String? sizeValidationMessage = TValidator.validateImageSize(pickedFiles);
    if (sizeValidationMessage != null) {
      TLoaders.warningSnackBar(
          title: 'Validation Error', message: sizeValidationMessage);
      return;
    }

    setState(() {
      _newImages.addAll(pickedFiles);
    });
  }

  void _removeImage(String id) {
    setState(() {
      int remainingImages = _currentImages.length +
          _newImages.length -
          _imagesToRemove.length -
          1;

      if (remainingImages >= 0) {
        final imageToRemove = _currentImages
            .firstWhere((image) => image['id'] == id, orElse: () => {});
        if (imageToRemove.isNotEmpty) {
          _imagesToRemove.add(id);
          _currentImages.remove(imageToRemove);
        }
      } else {
        TLoaders.warningSnackBar(
            title: 'Validation Error',
            message: 'At least one image is required for the post.');
      }
    });
  }

  void _submitUpdate() async {
    if (_contentController.text.isEmpty ||
        (_currentImages.isEmpty && _newImages.isEmpty)) {
      TLoaders.warningSnackBar(
          title: 'Validation Error',
          message: 'Content and at least one image are required.');
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    bool removeAllPhotos = _currentImages.isEmpty && _newImages.isEmpty;
    List<String> photosToRemove = _imagesToRemove;

    bool success = await postController.updatePost(
      postId: widget.postId,
      content: _contentController.text,
      status: 'Approved',
      removeAllComments: false,
      commentsToRemove: [],
      removeAllPhotos: removeAllPhotos,
      photosToRemove: photosToRemove,
    );

    if (success) {
      Get.back();
      postController.featurePost();
      TLoaders.successSnackBar(
          title: 'Success',
          message: 'Your post has been updated successfully.');
    } else {
      TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Failed to update the post, please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật bài viết')),
      body: SingleChildScrollView(
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
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.image),
              label: const Text('Chọn ảnh'),
            ),
            Wrap(
              children: _currentImages.map((image) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        image['url']!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeImage(image['id']!),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            Wrap(
              children: _newImages.map((image) {
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
            ElevatedButton(
              onPressed: _submitUpdate,
              child: const Text('Cập nhật bài viết'),
            ),
          ],
        ),
      ),
    );
  }
}
