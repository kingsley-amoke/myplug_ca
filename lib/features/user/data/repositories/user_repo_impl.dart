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
      return userProfile.loadUser(res.id!);
    } else {
      return null;
    }
  }

  @override
  Future<MyplugUser?> signUp(
      {required MyplugUser user, required String password}) async {
    final res = await userAuth.signUp(email: user.email, password: password);
    if (res != null) {
      return await userProfile.addUser(user.copyWith(id: res.id!));
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

  @override
  Stream<MyplugUser> getUserStream(String userId) {
    return userProfile.getUserStream(userId);
  }

  @override
  Stream<List<MyplugUser>> getAllUsersStream() {
    return userProfile.getAllUsersStream();
  }

  MyplugUser? deductUserBalance(
      {required MyplugUser user, required double amount}) {
    if (user.balance < amount) {
      return null;
    }
    user.balance -= amount;
    return user;
  }
}
