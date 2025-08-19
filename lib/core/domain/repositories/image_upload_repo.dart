import 'dart:io';

abstract class ImageUploadRepo {
  Future<String?> uploadImage({
    required File imageFile,
    required String path,
    required String userId,
  });

  Future<void> deleteImage(String url);
}
