import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';

abstract class UserRepo {
  MyplugUser? get currentUser;

  Stream<MyplugUser> getUserStream(String userId);

  Future<MyplugUser?> signIn({required String email, required String password});

  Future<MyplugUser?> signUp(
      {required MyplugUser user, required String password});

  Future<void> logout();

  Future<MyplugUser?> loadUser(String userId);

  Future<List<MyplugUser>> loadAllUsers();

  Future<MyplugUser?> addUser(MyplugUser user);

  Future<void> deleteUser(String userId);

  Future<MyplugUser> updateProfile(MyplugUser user);

  Stream<List<MyplugUser>> getAllUsersStream();
}
