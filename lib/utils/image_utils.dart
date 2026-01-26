import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageAsBase64() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (image == null) return null;
    return base64Encode(await File(image.path).readAsBytes());
  }

  static Future<String?> takePhotoAsBase64() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (image == null) return null;
    return base64Encode(await File(image.path).readAsBytes());
  }
}