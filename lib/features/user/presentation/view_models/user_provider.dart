import 'package:flutter/foundation.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/features/user/data/repositories/user_repo_impl.dart';
import 'package:myplug_ca/features/user/domain/models/location.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/models/portfolio.dart';
import 'package:myplug_ca/features/user/domain/models/referee.dart';
import 'package:myplug_ca/features/user/domain/models/skill.dart';
import 'package:myplug_ca/features/user/domain/models/testimonial.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';

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

  //update profile
  Future<void> updateProfile({
    String? bio,
    String? firstName,
    String? lastName,
    String? phone,
    String? image,
    UserLocation? location,
    List<Skill>? skills,
    List<Testimonial>? testimonials,
    List<Transaction>? transactions,
    List<Portfolio>? portfolios,
    List<String>? conversations,
    List<Referee>? referees,
  }) async {
    final updatedProfile = _user?.copyWith(
      bio: bio,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      image: image,
      location: location,
      testimonials: testimonials,
      skills: skills,
      transactions: transactions,
      portfolios: portfolios,
      conversations: conversations,
      referees: referees,
    );
    if (updatedProfile != null) {
      await _userRepo.updateProfile(updatedProfile);
    }

    _user = updatedProfile;
    notifyListeners();
  }
}
