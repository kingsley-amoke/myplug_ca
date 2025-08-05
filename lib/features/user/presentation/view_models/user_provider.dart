import 'package:flutter/foundation.dart';
import 'package:myplug_ca/core/constants/conversations.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/features/user/data/repositories/user_repo_impl.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class UserProvider extends ChangeNotifier {
  final UserRepoImpl _userRepo;

  MyplugUser? _user = demoUsers[0];

  MyplugUser? get myplugUser => _user;

  bool get isLoggedIn => _user != null;

  UserProvider(this._userRepo);

  Future<void> signIn({required String email, required String password}) async {
    _user = await _userRepo.signUp(email: email, password: password);
    notifyListeners();
  }

  Future<void> signUp({required String email, required String password}) async {
    _user = await _userRepo.signUp(email: email, password: password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _userRepo.logout();
    _user = null;
    notifyListeners();
  }

  Stream<MyplugUser>? getUserStream() {
    if (_user != null) {
      return _userRepo.getUserStream(_user!.id);
    } else {
      return null;
    }
  }
}
