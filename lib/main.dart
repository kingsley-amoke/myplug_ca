import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fixnbuy/app.dart';
import 'package:fixnbuy/core/presentation/viewmodels/myplug_provider.dart';
import 'package:fixnbuy/core/services/upload_image_service.dart';
import 'package:fixnbuy/features/chat/data/datasources/firestore_chat_service.dart';
import 'package:fixnbuy/features/chat/data/repositories/chat_repo_impl.dart';
import 'package:fixnbuy/features/chat/presentation/viewmodels/chat_provider.dart';
import 'package:fixnbuy/features/chat/services/database_service.dart';
import 'package:fixnbuy/features/job/data/datasources/job_firestore_service.dart';
import 'package:fixnbuy/features/job/data/repositories/job_repo_impl.dart';
import 'package:fixnbuy/features/job/presentation/viewmodels/job_provider.dart';
import 'package:fixnbuy/features/job/services/job_database_service.dart';
import 'package:fixnbuy/features/product/data/datasources/product_firestore_service.dart';
import 'package:fixnbuy/features/product/data/repositories/product_repo_impl.dart';
import 'package:fixnbuy/features/product/presentation/view_models/product_provider.dart';
import 'package:fixnbuy/features/product/services/database_service.dart';
import 'package:fixnbuy/features/promotion/data/datasources/promotion_firestore.dart';
import 'package:fixnbuy/features/promotion/data/repositories/promotion_repo_impl.dart';
import 'package:fixnbuy/features/promotion/presentation/viewmodels/promotion_provider.dart';
import 'package:fixnbuy/features/subscription/data/datasources/firestore_subscription_service.dart';
import 'package:fixnbuy/features/subscription/data/repositories/subscription_repo_impl.dart';
import 'package:fixnbuy/features/subscription/presentation/viewmodels/subscription_provider.dart';
import 'package:fixnbuy/features/subscription/services/database_service.dart';
import 'package:fixnbuy/features/user/data/datasources/firebase_auth_service.dart';
import 'package:fixnbuy/features/user/data/repositories/user_repo_impl.dart';
import 'package:fixnbuy/features/user/data/datasources/firebase_firestore_service.dart';
import 'package:fixnbuy/features/user/presentation/view_models/user_provider.dart';
import 'package:fixnbuy/features/user/services/auth_service.dart';
import 'package:fixnbuy/features/user/services/profile_service.dart';
import 'package:fixnbuy/firebase_options.dart';
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
  final promotionDatabaseService = PromotionFirestore(firestore);
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
        )..loadAllSubscriptions(),
      ),
      ChangeNotifierProvider(
        create: (_) => JobProvider(
          JobRepoImpl(jobDatabaseService),
        )..loadJobs(),
      ),
      ChangeNotifierProvider(
        create: (_) => ChatProvider(
          ChatRepoImpl(chatDatabaseService),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => PromotionProvider(
          PromotionRepoImpl(promotionDatabaseService),
        )..loadAllPlans(),
      ),
      ChangeNotifierProvider(
        create: (_) => MyplugProvider(
          userRepoImpl: UserRepoImpl(
              userAuth: userAuthService, userProfile: userProfileService),
          chatRepoImpl: ChatRepoImpl(chatDatabaseService),
          jobRepoImpl: JobRepoImpl(jobDatabaseService),
          subscriptionRepoImpl:
              SubscriptionRepoImpl(subscriptionDatabaseService),
          promotionRepoImpl: PromotionRepoImpl(promotionDatabaseService),
          productRepoImpl: ProductRepoImpl(productDatabaseService),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}
