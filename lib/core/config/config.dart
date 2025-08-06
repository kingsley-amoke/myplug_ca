import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myplug_ca/features/product/domain/models/rating.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';
// import 'package:url_launcher/url_launcher.dart';

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getAverageRating({required List<Rating> ratings}) {
  double total = 0.0;
  if (ratings.isEmpty) return total;

  for (Rating item in ratings) {
    total += item.rating;
  }

  return total / ratings.length;
}

String formatDate({required DateTime date}) {
  return DateFormat('EEE, d MMM yy').format(date);
}

String formatPrice({required double amount, String currency = 'NGN'}) {
  return NumberFormat.simpleCurrency(
    locale: Platform.localeName,
    name: currency,
  ).format(amount);
}

String createConversationId(
    {required String senderId, required String receiverId}) {
  final List<String> sorted = [senderId, receiverId]..sort();
  return '${sorted[0]}_${sorted[1]}';
}

Map<String, List<Transaction>> groupTransactionsByDate(List<Transaction> txns) {
  final Map<String, List<Transaction>> grouped = {};
  for (var txn in txns) {
    final dateStr = DateFormat.yMMMd().format(txn.date);
    grouped.putIfAbsent(dateStr, () => []).add(txn);
  }
  return grouped;
}
// void openLink(String url) async {
//   final Uri _url = Uri.parse(url);
//   try {
//     launchUrl(_url).then((e) {
//       if (!e) {
//         print('cannot launch url');
//       }
//     });
//   } catch (e) {
//     print(e.toString());
//   }
// }
