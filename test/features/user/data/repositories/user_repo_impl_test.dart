import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/features/user/data/repositories/user_repo_impl.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/services/auth_service.dart';
import 'package:myplug_ca/features/user/services/profile_service.dart';

class MockAuthService extends Mock implements UserAuthService {}

class MockProfileService extends Mock implements ProfileService {}

void main() {
  late MockAuthService mockAuthService;
  late MockProfileService mockProfileService;
  late UserRepoImpl userRepoImpl;
  late MyplugUser expectedUser;

  setUp(() {
    mockAuthService = MockAuthService();
    mockProfileService = MockProfileService();
    userRepoImpl = UserRepoImpl(
        userAuth: mockAuthService, userProfile: mockProfileService);
    expectedUser = demoUsers[0];
  });

  group('Auth tests for user repo impl', () {
    test('sign in', () async {
      //ARRANGE
      when(() => mockProfileService.loadUser(expectedUser.id))
          .thenAnswer((_) async => demoUsers[0]);
      when(() => mockAuthService.signUp(
          email: expectedUser.email,
          password: '123456')).thenAnswer((_) async => demoUsers[0]);
      when(() => mockAuthService.signIn(
          email: expectedUser.email,
          password: '123456')).thenAnswer((_) async => demoUsers[0]);

//ACT
      final user = await userRepoImpl.signIn(
          email: expectedUser.email, password: '123456');

//ASSERT
      expect(user, expectedUser);
    });
    test('sign up', () async {
      //ARRANGE
      when(() => mockProfileService.loadUser(expectedUser.id))
          .thenAnswer((_) async => demoUsers[0]);
      when(() => mockAuthService.signUp(
          email: expectedUser.email,
          password: '123456')).thenAnswer((_) async => demoUsers[0]);
      when(() => mockAuthService.signIn(
          email: expectedUser.email,
          password: '123456')).thenAnswer((_) async => demoUsers[0]);

//ACT
      final user = await userRepoImpl.signUp(
          email: expectedUser.email, password: '123456');

//ASSERT
      expect(user, expectedUser);
    });
  });

  group('Database tests for user repo impl', () {
    test('load user', () async {
      //ARRANGE
      when(() => mockProfileService.loadUser(expectedUser.id))
          .thenAnswer((_) async => demoUsers[0]);
      //ACT
      final user = await userRepoImpl.loadUser(expectedUser.id);

      //ASSERT
      expect(user, expectedUser);
    });
  });
}
