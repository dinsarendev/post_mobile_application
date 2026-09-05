import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePickerField extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? pickedBytes;
  final bool uploading;
  final VoidCallback? onTap;

  const ImagePickerField({
    super.key,
    this.imageUrl,
    this.pickedBytes,
    this.uploading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: uploading ? null : onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (pickedBytes != null)
              Image.memory(pickedBytes!, fit: BoxFit.cover)
            else if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(imageUrl!, fit: BoxFit.cover)
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, color: Colors.grey.shade500, size: 40),
                    const SizedBox(height: 8),
                    Text("Tap to select an image", style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            if (uploading)
              Container(
                color: Colors.black38,
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
