import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/app.dart';
import 'package:myplug_ca/core/presentation/viewmodels/myplug_provider.dart';
import 'package:myplug_ca/core/services/upload_image_service.dart';
import 'package:myplug_ca/features/chat/data/datasources/firestore_chat_service.dart';
import 'package:myplug_ca/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:myplug_ca/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:myplug_ca/features/chat/services/database_service.dart';
import 'package:myplug_ca/features/job/data/datasources/job_firestore_service.dart';
import 'package:myplug_ca/features/job/data/repositories/job_repo_impl.dart';
import 'package:myplug_ca/features/job/presentation/viewmodels/job_provider.dart';
import 'package:myplug_ca/features/job/services/job_database_service.dart';
import 'package:myplug_ca/features/product/data/datasources/product_firestore_service.dart';
import 'package:myplug_ca/features/product/data/repositories/product_repo_impl.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/product/services/database_service.dart';
import 'package:myplug_ca/features/subscription/data/datasources/firestore_subscription_service.dart';
import 'package:myplug_ca/features/subscription/data/repositories/subscription_repo_impl.dart';
import 'package:myplug_ca/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:myplug_ca/features/subscription/services/database_service.dart';
import 'package:myplug_ca/features/user/data/datasources/firebase_auth_service.dart';
import 'package:myplug_ca/features/user/data/repositories/user_repo_impl.dart';
import 'package:myplug_ca/features/user/data/datasources/firebase_firestore_service.dart';
import 'package:myplug_ca/features/user/presentation/view_models/user_provider.dart';
import 'package:myplug_ca/features/user/services/auth_service.dart';
import 'package:myplug_ca/features/user/services/profile_service.dart';
import 'package:myplug_ca/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  final userAuthService = UserAuthService(FirebaseAuthService(auth));
  final userProfileService = ProfileService(
    userProfileService: FirebaseFirestoreService(firestore),
    imageUploadService: FirebaseImageUpload(storage),
  );

  final productDatabaseService = ProductDatabaseService(
    databaseService: ProductFirestoreService(firestore),
    fileUploadService: FirebaseImageUpload(storage),
  );
  final subscriptionDatabaseService =
      SubscriptionDatabaseService(FirestoreSubscriptionService(firestore));
  final jobDatabaseService = JobDatabaseService(
    databaseService: JobFirestoreService(firestore),
    fileUploadService: FirebaseImageUpload(storage),
  );
  final chatDatabaseService = ChatDatabaseService(
    FirestoreChatService(firestore),
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(
          UserRepoImpl(
            userAuth: userAuthService,
            userProfile: userProfileService,
          ),
        )..getLocation(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductProvider(
          ProductRepoImpl(productDatabaseService),
        )..loadProducts(),
      ),
      ChangeNotifierProvider(
        create: (_) => SubscriptionProvider(
          SubscriptionRepoImpl(subscriptionDatabaseService),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => JobProvider(
          JobRepoImpl(jobDatabaseService),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => ChatProvider(
          ChatRepoImpl(chatDatabaseService),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => MyplugProvider(
          userRepoImpl: UserRepoImpl(
              userAuth: userAuthService, userProfile: userProfileService),
          chatRepoImpl: ChatRepoImpl(chatDatabaseService),
          jobRepoImpl: JobRepoImpl(jobDatabaseService),
          subscriptionRepoImpl:
              SubscriptionRepoImpl(subscriptionDatabaseService),
          productRepoImpl: ProductRepoImpl(productDatabaseService),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}
