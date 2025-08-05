import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myplug_ca/app.dart';
import 'package:myplug_ca/features/product/data/datasources/product_firestore_service.dart';
import 'package:myplug_ca/features/product/data/repositories/product_repo_impl.dart';
import 'package:myplug_ca/features/product/presentation/view_models/product_provider.dart';
import 'package:myplug_ca/features/product/services/database_service.dart';
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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(
          UserRepoImpl(
            userAuth: UserAuthService(
              FirebaseAuthService(FirebaseAuth.instance),
            ),
            userProfile: ProfileService(
              FirebaseFirestoreService(FirebaseFirestore.instance),
            ),
          ),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => ProductProvider(
          ProductRepoImpl(
            DatabaseService(
              ProductFirestoreService(FirebaseFirestore.instance),
            ),
          ),
        )..loadProducts(),
      ),
    ],
    child: const MyApp(),
  ));
}
