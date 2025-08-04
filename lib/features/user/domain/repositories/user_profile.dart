import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

abstract class UserProfile {
  Future<MyplugUser?> loadUser(String userId);
  Future<List<MyplugUser>> loadAllUsers();
  Future<MyplugUser> updateProfile(MyplugUser user);
  Future<MyplugUser?> addUser(MyplugUser user);
  Future<void> deleteUser(String userId);
  Stream<MyplugUser> getUserStream(String userId);
  Stream<List<MyplugUser>> getAllUsersStream();
}
