import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
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

JobType jobTypeFromString(String? type) {
  switch (type?.toLowerCase()) {
    case 'parttime':
      return JobType.parttime;
    case 'fulltime':
      return JobType.fulltime;
    case 'internship':
      return JobType.internship;
    default:
      return JobType.fulltime; // fallback to fulltime
  }
}

String formatTimeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays >= 365) {
    final years = (difference.inDays / 365).floor();
    return years == 1 ? '1 year ago' : '$years years ago';
  } else if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return months == 1 ? '1 month ago' : '$months months ago';
  } else if (difference.inDays >= 1) {
    return difference.inDays == 1
        ? '1 day ago'
        : '${difference.inDays} days ago';
  } else if (difference.inHours >= 1) {
    return difference.inHours == 1
        ? '1 hour ago'
        : '${difference.inHours} hours ago';
  } else if (difference.inMinutes >= 1) {
    return difference.inMinutes == 1
        ? '1 minute ago'
        : '${difference.inMinutes} minutes ago';
  } else {
    return 'just now';
  }
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
