import 'dart:io';

abstract class FileUploadRepo {
  Future<String?> uploadImage({
    required File imageFile,
    required String path,
    required String id,
  });

  Future<String?> uploadFile({required File file, required String path});

  Future<void> deleteImage(String url);
}
