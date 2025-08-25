import 'dart:io';

import 'package:fixnbuy/core/domain/repositories/image_upload_repo.dart';
import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';
import 'package:fixnbuy/features/user/domain/models/portfolio.dart';
import 'package:fixnbuy/features/user/domain/repositories/user_profile.dart';

class ProfileService implements UserProfile {
  final UserProfile userProfileService;
  final FileUploadRepo imageUploadService;

  const ProfileService(
      {required this.userProfileService, required this.imageUploadService});
  @override
  Future<MyplugUser?> loadUser(String userId) async {
    return await userProfileService.loadUser(userId);
  }

  @override
  Future<List<MyplugUser>> loadAllUsers() async {
    return await userProfileService.loadAllUsers();
  }

  @override
  Future<MyplugUser?> addUser(MyplugUser user) async {
    return await userProfileService.addUser(user);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await userProfileService.deleteUser(userId);
  }

  @override
  Future<MyplugUser> updateProfile(MyplugUser user) async {
    return await userProfileService.updateProfile(user);
  }

  @override
  Stream<MyplugUser> getUserStream(String userId) {
    return userProfileService.getUserStream(userId);
  }

  @override
  Stream<List<MyplugUser>> getAllUsersStream() {
    return userProfileService.getAllUsersStream();
  }

  Future<String?> uploadImage({
    required File imageFile,
    required String path,
    required String userId,
  }) async {
    return await imageUploadService.uploadImage(
        imageFile: imageFile, path: path, id: userId);
  }

  Future<void> deleteImage(String url) async {
    imageUploadService.deleteImage(url);
  }

  @override
  Future<String> uploadPortfolio(Portfolio portfolio) async {
    return await userProfileService.uploadPortfolio(portfolio);
  }
}
