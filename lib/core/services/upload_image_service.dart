import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fixnbuy/core/domain/repositories/image_upload_repo.dart';

class FirebaseImageUpload extends FileUploadRepo {
  final FirebaseStorage _storage;

  FirebaseImageUpload(this._storage);

  /// Upload an image file and return the download URL
  @override
  Future<String?> uploadImage({
    required File imageFile,
    required String path,
    required String id,
  }) async {
    try {
      final fileName = "profile_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = _storage.ref().child("$path/$id/$fileName");

      // Upload file
      final uploadTask = await ref.putFile(imageFile);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> uploadFile({required File file, required String path}) async {
    try {
      final fileName = file.path.split('/').last;
      final storageRef = _storage.ref().child("$path/$fileName");

      final uploadTask = await storageRef.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  /// Delete an image from Firebase Storage using its download URL
  @override
  Future<void> deleteImage(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
