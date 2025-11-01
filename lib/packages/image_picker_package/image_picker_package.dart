import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tetco_attendance/utils/size_constant.dart';

class ImagePickerPackage {
  static Future<File?> pickImage({
    required BuildContext context,
  }) async {
    final ImagePicker picker = ImagePicker();

    // show options to user
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topLeft: Radius.circular(sizeConstants.radiusMedium),
          topRight: Radius.circular(sizeConstants.radiusMedium),
        ),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return null; // user cancelled

    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80, // compress quality 0-100
      maxWidth: 800, // optional: resize
      maxHeight: 800,
    );

    if (pickedFile == null) return null; // user cancelled

    return File(pickedFile.path);
  }
}
