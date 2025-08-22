import 'package:myplug_ca/features/user/domain/repositories/user_auth.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class UserAuthService implements UserAuth {
  final UserAuth userAuthService;

  const UserAuthService(this.userAuthService);

  @override
  Future<MyplugUser?> signIn(
      {required String email, required String password}) async {
    return userAuthService.signIn(email: email, password: password);
  }

  @override
  Future<MyplugUser?> signUp(
      {required String email, required String password}) async {
    return userAuthService.signUp(email: email, password: password);
  }

  @override
  Future<void> changePassword(String email) async {
    return await userAuthService.changePassword(email);
  }

  @override
  Future<void> logout() async {
    userAuthService.logout();
  }

  @override
  MyplugUser? get currentUser => userAuthService.currentUser;
}
