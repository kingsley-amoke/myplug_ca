import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/repositories/user_profile.dart';

class FirebaseFirestoreService implements UserProfile {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService(this._firestore);

  @override
  Future<MyplugUser?> loadUser(String userId) async {
    final res = await _firestore.collection('users').doc(userId).get();
    if (res.data() != null) {
      return MyplugUser.fromMap(res.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<MyplugUser>> loadAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      return MyplugUser.fromMap(doc.data());
    }).toList();
  }

  @override
  Future<MyplugUser?> addUser(MyplugUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());

    return user;
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  @override
  Future<MyplugUser> updateProfile(MyplugUser user) async {
    await _firestore.collection('users').doc(user.id).update(user.toMap());
    return user;
  }

  @override
  Stream<MyplugUser> getUserStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      return MyplugUser.fromMap(doc.data()!..['id'] = userId);
    });
  }

  @override
  Stream<List<MyplugUser>> getAllUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return MyplugUser.fromMap(data);
            }).toList());
  }
}
