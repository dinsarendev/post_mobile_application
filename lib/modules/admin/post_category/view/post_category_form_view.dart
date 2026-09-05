import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_mobile_application/core/models/post/PostCategory.dart';
import 'package:post_mobile_application/modules/admin/post_category/controller/post_category_controller.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';
import 'package:post_mobile_application/widgets/button_custom_widget.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';
import 'package:post_mobile_application/widgets/image_picker_field.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

class PostCategoryFormView extends StatefulWidget {
  final PostCategory? editingCategory;
  const PostCategoryFormView({super.key, this.editingCategory});

  @override
  State<PostCategoryFormView> createState() => _PostCategoryFormViewState();
}

class _PostCategoryFormViewState extends State<PostCategoryFormView> {
  final PostCategoryController controller = Get.find<PostCategoryController>();

  late final nameController = TextEditingController(text: widget.editingCategory?.name ?? "");
  String? imageUrl;
  Uint8List? pickedImageBytes;
  bool isActive = true;

  bool get isEditing => widget.editingCategory != null;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.editingCategory?.imageUrl;
    isActive = (widget.editingCategory?.status ?? "ACT") == "ACT";
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    var file = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (file == null) return;
    var bytes = await file.readAsBytes();
    setState(() {
      pickedImageBytes = bytes;
    });
    var uploadedUrl = await controller.uploadCategoryImage(bytes: bytes, filename: file.name);
    if (uploadedUrl != null) {
      setState(() {
        imageUrl = uploadedUrl;
      });
    } else {
      AppSnackbar.error("Failed to upload image");
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
    var name = nameController.text.trim();
    var image = imageUrl ?? "";
    if (name.isEmpty) {
      AppSnackbar.error("Please enter the category name");
      return;
    }
    if (image.isEmpty) {
      AppSnackbar.error("Please select an image");
      return;
    }
    var status = isActive ? "ACT" : "INACT";

    bool success;
    if (isEditing) {
      success = await controller.updateCategory(
        id: widget.editingCategory!.id!,
        name: name,
        imageUrl: image,
        status: status,
      );
    } else {
      success = await controller.createCategory(name: name, imageUrl: image, status: status);
    }

    if (success) {
      Get.back();
      AppSnackbar.success(isEditing ? "Category updated successfully" : "Category created successfully");
    } else {
      AppSnackbar.error(isEditing ? "Failed to update category" : "Failed to create category");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppbarCustomWidget(title: isEditing ? "Edit Category" : "Create Category"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputFormCustom(
                    controller: nameController,
                    labelText: "Name",
                    hintText: "Category name",
                  ),
                  const SizedBox(height: 8),
                  Text("Image", style: TextStyle(color: Colors.grey.shade700)),
                  ImagePickerField(
                    imageUrl: imageUrl,
                    pickedBytes: pickedImageBytes,
                    uploading: controller.uploadingImage.value,
                    onTap: onPickImageTap,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Active"),
                    value: isActive,
                    activeColor: Colors.cyan,
                    onChanged: (value) => setState(() => isActive = value),
                  ),
                  const SizedBox(height: 24),
                  ButtonCustomWidget(
                    onClick: (controller.formLoading.value || controller.uploadingImage.value)
                        ? null
                        : onSubmit,
                    loading: controller.formLoading.value,
                    title: isEditing ? "Update Category" : "Create Category",
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
