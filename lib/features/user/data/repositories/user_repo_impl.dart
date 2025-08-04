import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/services/auth_service.dart';
import 'package:myplug_ca/features/user/services/profile_service.dart';
import 'package:myplug_ca/features/user/domain/repositories/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final UserAuthService userAuth;
  final ProfileService userProfile;

  UserRepoImpl({required this.userAuth, required this.userProfile});

  @override
  MyplugUser? get currentUser => userAuth.currentUser;

  @override
  Future<MyplugUser?> signIn(
      {required String email, required String password}) async {
    final res = await userAuth.signIn(email: email, password: password);
    if (res != null) {
      return userProfile.loadUser(res.id);
    } else {
      return null;
    }
  }

  @override
  Future<MyplugUser?> signUp(
      {required String email, required String password}) async {
    final res = await userAuth.signUp(email: email, password: password);
    if (res != null) {
      return await userProfile.loadUser(res.id);
    } else {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    userAuth.logout();
  }

  @override
  Future<MyplugUser?> loadUser(String userId) async {
    return await userProfile.loadUser(userId);
  }

  @override
  Future<List<MyplugUser>> loadAllUsers() async {
    return await userProfile.loadAllUsers();
  }

  @override
  Future<MyplugUser?> addUser(MyplugUser user) async {
    return await userProfile.addUser(user);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await userProfile.deleteUser(userId);
  }

  @override
  Future<MyplugUser> updateProfile(MyplugUser user) async {
    return await userProfile.updateProfile(user);
  }
}
