import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/services/location_service.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';
import 'package:myplug_ca/features/user/data/repositories/user_repo_impl.dart';
import 'package:myplug_ca/features/user/domain/models/location.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';
import 'package:myplug_ca/features/user/domain/models/portfolio.dart';
import 'package:myplug_ca/features/user/domain/models/referee.dart';
import 'package:myplug_ca/features/user/domain/models/skill.dart';
import 'package:myplug_ca/features/user/domain/models/testimonial.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';

class UserProvider extends ChangeNotifier {
  final UserRepoImpl _userRepo;

  List<MyplugUser> allUsers = [];
  List<MyplugUser> usersByService = [];
  MyplugUser? _user;

  UserLocation? userLocation;

  MyplugUser? get myplugUser => _user;

  bool get isLoggedIn => _user != null;

  UserProvider(this._userRepo);

  Future<void> signIn({required String email, required String password}) async {
    _user = await _userRepo.signIn(email: email, password: password);
    getLocation();
    notifyListeners();
  }

  Future<void> signUp(
      {required MyplugUser user,
      required String address,
      required String password}) async {
    userLocation = userLocation?.copyWith(address: address);
    user.copyWith(location: userLocation);
    _user = await _userRepo.signUp(user: user, password: password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _userRepo.logout();
    _user = null;
    notifyListeners();
  }

  Stream<MyplugUser>? getUserStream() {
    if (_user != null) {
      return _userRepo.getUserStream(_user!.id!);
    } else {
      return null;
    }
  }

  void getUsersByService(Skill service) async {
    await _userRepo.loadAllUsers();

    usersByService = allUsers.where((item) {
      return item.skills.first.name == service.name;
    }).toList();

    // notifyListeners();
  }

  Future<void> getLocation() async {
    allUsers = await _userRepo.loadAllUsers();
    final locationData = await LocationService.getUserLocationInfo();
    if (locationData != null) {
      userLocation = UserLocation(
        latitude: locationData['latitude'],
        longitude: locationData['longitude'],
      );

      if (FirebaseAuth.instance.currentUser != null) {
        _user =
            await _userRepo.loadUser(FirebaseAuth.instance.currentUser!.uid);
        if (userLocation != null) {
          final fullAddress = await getAddressFromCordinates(
              latitude: userLocation!.latitude,
              longitude: userLocation!.longitude);

          userLocation = userLocation!.copyWith(address: fullAddress);
          print(userLocation.toString());
          _user = _user?.copyWith(location: userLocation);
          _userRepo.updateProfile(_user!);
        }
      }
    } else {
      if (FirebaseAuth.instance.currentUser != null) {
        _user =
            await _userRepo.loadUser(FirebaseAuth.instance.currentUser!.uid);

        userLocation = _user!.location;
      }
    }

    notifyListeners();
  }

  //update profile
  Future<void> updateProfile({
    String? bio,
    String? firstName,
    String? lastName,
    String? phone,
    String? image,
    UserLocation? location,
    List<Skill>? skills,
    List<Rating>? testimonials,
    List<Transaction>? transactions,
    List<Portfolio>? portfolios,
    List<String>? conversations,
    List<Referee>? referees,
  }) async {
    final updatedProfile = _user?.copyWith(
      bio: bio,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      image: image,
      location: location,
      testimonials: testimonials,
      skills: skills,
      transactions: transactions,
      portfolios: portfolios,
      conversations: conversations,
      referees: referees,
    );
    if (updatedProfile != null) {
      await _userRepo.updateProfile(updatedProfile);
    }

    _user = updatedProfile;
    notifyListeners();
  }

  Future<bool> uploadProfilePic(File imageFile) async {
    if (isLoggedIn) {
      if (myplugUser!.image != null) {
        _userRepo.deleteImage(myplugUser!.image!);
      }
      _userRepo
          .uploadImage(
        imageFile: imageFile,
        path: 'users',
        userId: myplugUser!.id!,
      )
          .then((url) {
        if (url != null) {
          updateProfile(image: url);
          return true;
        } else {
          return false;
        }
      });
      notifyListeners();
    }

    return false;
  }

  Future<void> addTestimonial(
      {required MyplugUser user, required Rating rating}) async {
    user.testimonials.add(rating);
    List<Rating> newTestimonials = user.testimonials;

    await updateProfile(testimonials: newTestimonials);

    notifyListeners();
  }

  Future<void> uploadPortfolio({
    required List<File> images,
    required String title,
    required String description,
    String? link,
  }) async {
    final List<String> downloadUrls = [];

    for (File image in images) {
      final downloadUrl = await _userRepo.uploadImage(
          imageFile: image, path: 'portfolio', userId: myplugUser!.id!);

      if (downloadUrl != null) {
        downloadUrls.add(downloadUrl);
      }
    }

    Portfolio newPortfolio = Portfolio(
      title: title,
      description: description,
      imageUrls: downloadUrls,
      link: link,
    );

    final id = await _userRepo.uploadPortfolio(newPortfolio);
    myplugUser!.portfolios.add(
      newPortfolio.copyWith(id: id),
    );

    List<Portfolio> newPortfolios = myplugUser!.portfolios;

    updateProfile(portfolios: newPortfolios);

    notifyListeners();
  }
}
