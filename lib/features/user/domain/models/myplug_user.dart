import 'package:myplug_ca/core/domain/models/rating.dart';
import 'package:myplug_ca/features/user/domain/models/referee.dart';

import 'package:myplug_ca/features/user/domain/models/portfolio.dart';

import 'package:myplug_ca/features/user/domain/models/transaction.dart';

import 'package:myplug_ca/features/user/domain/models/location.dart';
import 'package:myplug_ca/features/user/domain/models/skill.dart';

class MyplugUser {
  final String? id;
  final String email;
  final String? bio;
  final String? firstName;
  final String? lastName;
  final String? phone;
  double balance;
  double bonus;
  final bool isAdmin;
  final bool isSuspended;
  final String? image;
  final UserLocation? location;
  final List<Skill> skills;
  final List<Rating> testimonials;
  final List<Transaction> transactions;
  final List<Portfolio> portfolios;
  final List<Referee> referees;
  final List<String> conversations;
  final Referee? referer;

  MyplugUser({
    this.id,
    required this.email,
    this.bio,
    this.firstName,
    this.lastName,
    this.phone,
    this.balance = 0.0,
    this.bonus = 0.0,
    this.isAdmin = false,
    this.isSuspended = false,
    this.image,
    this.location,
    this.skills = const [],
    this.testimonials = const [],
    this.transactions = const [],
    this.portfolios = const [],
    this.referees = const [],
    this.conversations = const [],
    this.referer,
  });

  factory MyplugUser.fromMap(Map<String, dynamic> map) {
    return MyplugUser(
      id: map['id'],
      email: map['email'],
      bio: map['bio'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      balance: (map['balance'] ?? 0).toDouble(),
      bonus: (map['bonus'] ?? 0).toDouble(),
      isAdmin: map['isAdmin'] ?? false,
      isSuspended: map['isSuspended'] ?? false,
      image: map['image'],
      location: map['location'] != null
          ? UserLocation.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      skills: (map['skills'] as List? ?? [])
          .map((e) => Skill.fromMap(e as Map<String, dynamic>))
          .toList(),
      testimonials: (map['testimonials'] as List? ?? [])
          .map((e) => Rating.fromMap(e as Map<String, dynamic>))
          .toList(),
      transactions: (map['transactions'] as List? ?? [])
          .map((e) => Transaction.fromMap(e as Map<String, dynamic>))
          .toList(),
      portfolios: (map['portfolios'] as List? ?? [])
          .map((e) => Portfolio.fromMap(e as Map<String, dynamic>))
          .toList(),
      referees: (map['referees'] as List? ?? [])
          .map((e) => Referee.fromMap(e as Map<String, dynamic>))
          .toList(),
      conversations: List<String>.from(map['conversations']),
      referer: map['referer'],
    );
  }

  String get fullname => '$firstName $lastName';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'bio': bio,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'balance': balance,
      'bonus': bonus,
      'isAdmin': isAdmin,
      'isSuspended': isSuspended,
      'image': image,
      'location': location?.toMap(),
      'skills': skills.map((e) => e.toMap()).toList(),
      'testimonials': testimonials.map((e) => e.toMap()).toList(),
      'transactions': transactions.map((e) => e.toMap()).toList(),
      'portfolios': portfolios.map((e) => e.toMap()).toList(),
      'referees': referees.map((e) => e.toMap()).toList(),
      'conversations': conversations,
      'referer': referer,
    };
  }

  MyplugUser copyWith({
    String? id,
    String? email,
    String? bio,
    String? firstName,
    String? lastName,
    String? phone,
    double? balance,
    double? bonus,
    bool? isAdmin,
    bool? isSuspended,
    String? image,
    UserLocation? location,
    List<Skill>? skills,
    List<Rating>? testimonials,
    List<Transaction>? transactions,
    List<Portfolio>? portfolios,
    List<String>? conversations,
    List<Referee>? referees,
    Referee? referer,
  }) {
    return MyplugUser(
      id: id ?? this.id,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      bonus: bonus ?? this.bonus,
      isAdmin: isAdmin ?? this.isAdmin,
      isSuspended: isSuspended ?? this.isSuspended,
      image: image ?? this.image,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      testimonials: testimonials ?? this.testimonials,
      transactions: transactions ?? this.transactions,
      portfolios: portfolios ?? this.portfolios,
      referees: referees ?? this.referees,
      conversations: conversations ?? this.conversations,
      referer: referer ?? this.referer,
    );
  }
}
