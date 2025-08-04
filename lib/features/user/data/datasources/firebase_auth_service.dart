import 'package:firebase_auth/firebase_auth.dart';
import 'package:myplug_ca/features/user/domain/repositories/user_auth.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class FirebaseAuthService implements UserAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<MyplugUser?> signIn(
      {required String email, required String password}) async {
    final UserCredential res =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    if (res.user != null) {
      return MyplugUser(id: res.user!.uid, email: res.user!.email!);
    } else {
      return null;
    }
  }

  @override
  Future<MyplugUser?> signUp(
      {required String email, required String password}) async {
    final UserCredential res = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (res.user != null) {
      return MyplugUser(id: res.user!.uid, email: res.user!.email!);
    } else {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    auth.signOut();
  }

  @override
  MyplugUser? get currentUser {
    final user = auth.currentUser;

    if (user != null) {
      return MyplugUser(id: user.uid, email: user.email!);
    } else {
      return null;
    }
  }
}
