import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myplug_ca/core/domain/models/toast.dart';
import 'package:myplug_ca/features/job/domain/models/job_type.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';
import 'package:myplug_ca/features/user/domain/models/transaction.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toastification/toastification.dart';

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

//address

Future<String?> getStateFromCordinates(
    {required double latitude, required double longitude}) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

  if (placemarks.isNotEmpty) {
    final Placemark place = placemarks.first;

    return place.subAdministrativeArea;
  }
  return null;
}

Future<String?> getAddressFromCordinates(
    {required double latitude, required double longitude}) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

  if (placemarks.isNotEmpty) {
    final Placemark place = placemarks.first;

    String fullAddress =
        "${place.street}, ${place.locality}, ${place.administrativeArea}";

    return fullAddress;
  }
  return null;
}

String formatPlanDuration(Duration duration) {
  final days = duration.inDays;

  if (days < 7) {
    return "$days day${days == 1 ? '' : 's'}";
  } else if (days < 30) {
    final weeks = (days / 7).floor();
    return "$weeks week${weeks == 1 ? '' : 's'}";
  } else if (days < 365) {
    final months = (days / 30).floor();
    return "$months month${months == 1 ? '' : 's'}";
  } else {
    final years = (days / 365).floor();
    return "$years year${years == 1 ? '' : 's'}";
  }
}

//show toast

void showToast(
  BuildContext context, {
  required String message,
  required ToastType type,
}) {
  ToastificationType toastType;

  switch (type) {
    case ToastType.success:
      toastType = ToastificationType.success;
      break;
    case ToastType.error:
      toastType = ToastificationType.error;
      break;
    case ToastType.info:
      toastType = ToastificationType.info;
      break;
  }

  toastification.show(
    context: context,
    type: toastType,
    style: ToastificationStyle.fillColored,
    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
    alignment: Alignment.topCenter,
    animationDuration: const Duration(milliseconds: 300),
    borderRadius: BorderRadius.circular(8),
    showProgressBar: true,
  );
}

//pick image
final ImagePicker _picker = ImagePicker();
Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 80, // Compress quality (0-100)
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null; // User cancelled
    }
  } catch (e) {
    print("Error picking image: $e");
    return null;
  }
}

Future<List<File>?> pickMultiImage(
    {ImageSource source = ImageSource.gallery}) async {
  try {
    final List<XFile> picked = await _picker.pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 80, // Compress quality (0-100)
    );

    if (picked.isNotEmpty) {
      return picked.map((i) => File(i.path)).toList();
    } else {
      return null; // User cancelled
    }
  } catch (e) {
    print("Error picking image: $e");
    return null;
  }
}

void openLink(String url) async {
  final Uri url0 = Uri.parse(url);
  try {
    launchUrl(url0).then((e) {
      if (!e) {
        print('cannot launch url');
      }
    });
  } catch (e) {
    print(e.toString());
  }
}
