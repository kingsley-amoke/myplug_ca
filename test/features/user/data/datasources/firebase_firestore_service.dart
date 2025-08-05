import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myplug_ca/core/constants/users.dart';
import 'package:myplug_ca/features/user/data/datasources/firebase_firestore_service.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

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
  late MyplugUser demoUser;

  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late MockDocumentSnapshot mockDocSnap;
  setUp(() {
    mockFirestore = MockFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();
    mockDocSnap = MockDocumentSnapshot();
    userProfileService = FirebaseFirestoreService(mockFirestore);
    demoUser = demoUsers[0];
  });

  group('profile tests', () {
    test('load user', () async {
      //ARRANGE
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(demoUser.id)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnap);
      when(() => mockDocSnap.data()).thenReturn(demoUser.toMap());

      //ACT
      expectedUser = await userProfileService.loadUser(demoUser.id);
      //ASSERT
      expect(expectedUser, demoUser);
      expect(expectedUser, isA<MyplugUser>);
    });
    test('load user failed', () async {
      //ARRANGE
      when(() => mockFirestore.collection('users')).thenReturn(mockCollection);
      when(() => mockCollection.doc(demoUser.id)).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnap);
      when(() => mockDocSnap.data()).thenReturn(null);

      //ACT
      expectedUser = await userProfileService.loadUser(demoUser.id);
      //ASSERT
      expect(expectedUser, isNull);
    });
  });
}
