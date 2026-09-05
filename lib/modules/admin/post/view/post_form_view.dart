import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_mobile_application/core/models/post/Content.dart';
import 'package:post_mobile_application/modules/admin/post/controller/post_controller.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';
import 'package:post_mobile_application/widgets/button_custom_widget.dart';
import 'package:post_mobile_application/widgets/image_picker_field.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

class PostFormView extends StatefulWidget {
  final Content? editingPost;
  const PostFormView({super.key, this.editingPost});

  @override
  State<PostFormView> createState() => _PostFormViewState();
}

class _PostFormViewState extends State<PostFormView> {
  final PostController controller = Get.find<PostController>();

  late final titleController = TextEditingController(text: widget.editingPost?.title ?? "");
  late final descriptionController = TextEditingController(text: widget.editingPost?.description ?? "");
  late final bodyController = TextEditingController(text: widget.editingPost?.body ?? "");
  late final tagsController = TextEditingController(text: widget.editingPost?.tags?.join(", ") ?? "");
  int? selectedCategoryId;
  String? imageUrl;
  Uint8List? pickedImageBytes;

  bool get isEditing => widget.editingPost != null;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.editingPost?.postCategory?.id;
    imageUrl = widget.editingPost?.image;
    if (controller.categories.isEmpty) {
      controller.loadCategories();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    bodyController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    var file = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (file == null) return;
    var bytes = await file.readAsBytes();
    setState(() {
      pickedImageBytes = bytes;
    });
    var uploadedUrl = await controller.uploadPostImage(bytes: bytes, filename: file.name);
    if (uploadedUrl != null) {
      setState(() {
        imageUrl = uploadedUrl;
      });
    } else {
      Get.snackbar("Error", "Failed to upload image");
    }
  }

  Future<void> onPickImageTap() async {
    var source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Colors.cyan),
              title: const Text("Choose from gallery"),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: Colors.cyan),
              title: const Text("Take a photo"),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      await pickImage(source);
    }
  }

  onSubmit() async {
    var title = titleController.text.trim();
    var description = descriptionController.text.trim();
    var image = imageUrl ?? "";
    if (title.isEmpty || description.isEmpty) {
      Get.snackbar("Error", "Please fill in the title and description");
      return;
    }
    if (image.isEmpty) {
      Get.snackbar("Error", "Please select an image");
      return;
    }
    if (selectedCategoryId == null) {
      Get.snackbar("Error", "Please select a category");
      return;
    }

    bool success;
    if (isEditing) {
      success = await controller.updatePost(
        id: widget.editingPost!.id!,
        title: title,
        description: description,
        image: image,
        categoryId: selectedCategoryId!,
      );
    } else {
      var body = bodyController.text.trim();
      if (body.isEmpty) {
        Get.snackbar("Error", "Please enter the post content");
        return;
      }
      var tags = tagsController.text
          .split(",")
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();
      success = await controller.createPost(
        title: title,
        description: description,
        body: body,
        image: image,
        categoryId: selectedCategoryId!,
        tags: tags,
      );
    }

    if (success) {
      Get.back();
      Get.snackbar("Success", isEditing ? "Post updated successfully" : "Post created successfully");
    } else {
      Get.snackbar("Error", isEditing ? "Failed to update post" : "Failed to create post");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories;
      final categoryValue = categories.any((c) => c.id == selectedCategoryId)
          ? selectedCategoryId
          : null;
      return Scaffold(
        appBar: AppbarCustomWidget(title: isEditing ? "Edit Post" : "Create Post"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputFormCustom(
                    controller: titleController,
                    labelText: "Title",
                    hintText: "Post title",
                  ),
                  InputFormCustom(
                    controller: descriptionController,
                    labelText: "Description",
                    hintText: "Short description",
                  ),
                  if (!isEditing)
                    InputFormCustom(
                      controller: bodyController,
                      labelText: "Content",
                      hintText: "Full post content",
                    ),
                  const SizedBox(height: 8),
                  Text("Image", style: TextStyle(color: Colors.grey.shade700)),
                  ImagePickerField(
                    imageUrl: imageUrl,
                    pickedBytes: pickedImageBytes,
                    uploading: controller.uploadingImage.value,
                    onTap: onPickImageTap,
                  ),
                  if (!isEditing)
                    InputFormCustom(
                      controller: tagsController,
                      labelText: "Tags",
                      hintText: "comma, separated, tags",
                    ),
                  const SizedBox(height: 8),
                  Text("Category", style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  categories.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator(color: Colors.cyan)),
                        )
                      : DropdownButtonFormField<int>(
                          value: categoryValue,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          hint: const Text("Select a category"),
                          items: categories
                              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? "")))
                              .toList(),
                          onChanged: (value) => setState(() => selectedCategoryId = value),
                        ),
                  const SizedBox(height: 32),
                  ButtonCustomWidget(
                    onClick: (controller.formLoading.value || controller.uploadingImage.value)
                        ? null
                        : onSubmit,
                    loading: controller.formLoading.value,
                    title: isEditing ? "Update Post" : "Create Post",
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
