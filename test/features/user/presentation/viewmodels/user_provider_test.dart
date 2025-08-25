import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fixnbuy/core/constants/users.dart';
import 'package:fixnbuy/features/user/data/repositories/user_repo_impl.dart';
import 'package:fixnbuy/features/user/domain/models/myplug_user.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';

class MockUserRepoImpl extends Mock implements UserRepoImpl {}

void main() {
  late MockUserRepoImpl mockUserRepoImpl;
  late UserProvider provider;
  late MyplugUser demoUser;

  setUp(() {
    mockUserRepoImpl = MockUserRepoImpl();
    provider = UserProvider(mockUserRepoImpl);
    demoUser = demoUsers[0];
  });

  group('UserProvider Auth Tests', () {
    test('signIn should call repo and set user', () async {
      // Arrange
      when(() => mockUserRepoImpl.signIn(
            email: demoUser.email,
            password: '123456',
          )).thenAnswer((_) async => demoUser);

      when(() => mockUserRepoImpl.signUp(password: '123456', user: demoUser))
          .thenAnswer((_) async => demoUser);

      // Act
      await provider.signIn(email: 'smoq@gmail.com', password: '123456');

      // Assert
      expect(provider.myplugUser, equals(demoUser));
    });

    test('signUp should call repo and set user', () async {
      // Arrange
      when(() => mockUserRepoImpl.signUp(
            user: demoUser,
            password: '123456',
          )).thenAnswer((_) async => demoUser);

      // Act
      await provider.signUp(user: demoUser, password: '123456', address: '');

      // Assert
      expect(provider.myplugUser, equals(demoUser));
    });
    //
    // test('test logout', () async {
    //   //Arrange
    //   when(() => mockUserRepoImpl.signIn(
    //         email: demoUser.email,
    //         password: '123456',
    //       )).thenAnswer((_) async => demoUser);
    //   when(() => mockUserRepoImpl.signUp(
    //         email: demoUser.email,
    //         password: '123456',
    //       )).thenAnswer((_) async => demoUser);
    //   when(() => provider.logout()).thenAnswer((_) async => {});
    //
    //   // Act
    //   await provider.logout();
    //
    //   // Assert
    //   expect(provider.myplugUser, isNull);
    // });
  });
}
