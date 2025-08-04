import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/repositories/user_profile.dart';

class ProfileService implements UserProfile {
  final UserProfile _userProfileService;

  const ProfileService(this._userProfileService);
  @override
  Future<MyplugUser?> loadUser(String userId) async {
    return await _userProfileService.loadUser(userId);
  }

  @override
  Future<List<MyplugUser>> loadAllUsers() async {
    return await _userProfileService.loadAllUsers();
  }

  @override
  Future<MyplugUser?> addUser(MyplugUser user) async {
    return await _userProfileService.addUser(user);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _userProfileService.deleteUser(userId);
  }

  @override
  Future<MyplugUser> updateProfile(MyplugUser user) async {
    return await _userProfileService.updateProfile(user);
  }
}
