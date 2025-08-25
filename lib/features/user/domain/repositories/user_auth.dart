import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';

abstract class UserAuth {
  Future<MyplugUser?> signIn({required String email, required String password});
  Future<MyplugUser?> signUp({required String email, required String password});
  Future<void> logout();
  Future<void> changePassword(String email);
  MyplugUser? get currentUser;
}
