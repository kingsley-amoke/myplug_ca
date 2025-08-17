import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/features/user/data/datasources/firebase_auth_service.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late FirebaseAuthService firebaseAuthService;
  late User mockUser;
  late MyplugUser demoUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    demoUser = demoUsers[0];
    firebaseAuthService = FirebaseAuthService(mockFirebaseAuth);
  });

  group('Firebase  auth impl tests', () {
    test('user login', () async {
      //ARRANGE
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
          email: demoUser.email, password: '12345')).thenAnswer((_) async {
        return mockUserCredential;
      });

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn(demoUser.email);
      when(() => mockUser.uid).thenReturn(demoUser.id!);

      //ACT
      final user = await firebaseAuthService.signIn(
          email: demoUser.email, password: '12345');

      //ASSERT
      expect(user, isA<MyplugUser>());
      expect(user!.id, equals(demoUser.id));
      expect(user.email, equals(demoUser.email));
    });
    test('user signup', () async {
      //ARRANGE
      when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: demoUser.email, password: '12345')).thenAnswer((_) async {
        return mockUserCredential;
      });

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn(demoUser.email);
      when(() => mockUser.uid).thenReturn(demoUser.id!);

      //ACT
      final user = await firebaseAuthService.signUp(
          email: demoUser.email, password: '12345');

      //ASSERT
      expect(user, isA<MyplugUser>());
      expect(user!.id, equals(demoUser.id));
      expect(user.email, equals(demoUser.email));
    });
    test('test get current user', () {
      //ARRANGE
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.email).thenReturn(demoUser.email);
      when(() => mockUser.uid).thenReturn(demoUser.id!);

//ACT
      final user = firebaseAuthService.currentUser;
//ASSERT
      expect(user, isA<MyplugUser>());
      expect(user!.id, equals(demoUser.id));
      expect(user.email, equals(demoUser.email));
    });
  });
}
