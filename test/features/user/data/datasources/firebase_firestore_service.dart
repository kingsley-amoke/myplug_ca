import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/features/user/data/datasources/firebase_firestore_service.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

void main() {
  late FirebaseFirestore mockFirestore;
  late FirebaseFirestoreService userProfileService;
  late MyplugUser? expectedUser;
  late MyplugUser demoUser1;
  late MyplugUser demoUser2;
  late MockQuerySnapshot mockSnapshot;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnap;
  late MockQueryDocumentSnapshot mockDoc1;
  late MockQueryDocumentSnapshot mockDoc2;
  setUp(() {
    mockFirestore = MockFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnap = MockDocumentSnapshot();
    mockSnapshot = MockQuerySnapshot();
    mockDoc1 = MockQueryDocumentSnapshot();
    mockDoc2 = MockQueryDocumentSnapshot();
    userProfileService = FirebaseFirestoreService(mockFirestore);
    demoUser1 = demoUsers[1];
    demoUser2 = demoUsers[2];
  });

  group('profile tests', () {
    test('load user', () async {
      //ARRANGE
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(demoUser1.id)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnap);
      when(() => mockDocSnap.data()).thenReturn(demoUser1.toMap());

      //ACT:
      expectedUser = await userProfileService.loadUser(demoUser1.id!);
      //ASSERT
      expect(expectedUser, demoUser1);
      expect(expectedUser, isA<MyplugUser>);
    });
    test('load user failed', () async {
      //ARRANGE
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(demoUser1.id)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnap);
      when(() => mockDocSnap.data()).thenReturn(null);

      //ACT
      expectedUser = await userProfileService.loadUser(demoUser1.id!);
      //ASSERT
      expect(expectedUser, isNull);
    });
    test('loadAllUsers returns list of MyplugUser', () async {
      // Arrange
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.docs).thenReturn([mockDoc1, mockDoc2]);
      when(() => mockDoc1.data()).thenReturn(demoUser1.toMap());
      when(() => mockDoc2.data()).thenReturn(demoUser2.toMap());

      // Act
      final users = await userProfileService.loadAllUsers();

      // Assert
      expect(users.length, 2);
      expect(users[0].id, demoUser1.id);
      expect(users[1].email, demoUser2.email);
      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollection.get()).called(1);
    });
  });
}
