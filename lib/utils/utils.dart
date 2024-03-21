import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  /// Returns a formatted date string from an integer representation of a date in milliseconds.
  static String intToDayFirst(int intDate) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(intDate * 1000);

    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static intToYearFirst(int intDate) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(intDate * 1000);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// Returns a [DateTime] object from an integer representation of a date in milliseconds.
  static DateTime intToDateTime(int intDate) {
    return DateTime.fromMillisecondsSinceEpoch(intDate * 1000);
  }

  /// Returns an integer representation of a date from a [DateTime] object.
  static int dateTimeToInt(DateTime date) {
    final double convert =
        DateUtils.dateOnly(date).millisecondsSinceEpoch / 1000;
    return convert.toInt();
  }

  /// Returns the string representation of a number without the decimal point.
  static String amounts(String? input) {
    if (input != null) {
      return input.substring(0, input.indexOf('.'));
    } else {
      return '0';
    }
  }

  static int intAmounts(String? input) {
    if (input != null) {
      return int.parse(input.substring(0, input.indexOf('.')));
    } else {
      return 0;
    }
  }

  /// Returns the date portion of a [DateTime] object as a string.
  static String datePaid(DateTime input) {
    final String string = input.toString();
    return string.substring(0, string.indexOf(' '));
  }

  /// Returns a formatted date string from a [DateTime] object.
  static String dateTimeToString(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  /// Launches the default phone app and dials the specified phone number.
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  /// Returns a [TextStyle] object with a red color if the due date is in the past, or null if the due date is in the future or present.
  static overDueStyle(int dueDate) {
    if (intToDateTime(dueDate).isBefore(DateTime.now())) {
      return const TextStyle(color: Colors.red);
    } else {
      null;
    }
  }

  /// Creates a file from a base64-encoded string and returns the file path.
  static Future<String> createFileFromString(
      String encodedStr, String filename) async {
    final Uint8List bytes = base64.decode(encodedStr);
    const String dir = '/storage/emulated/0/Download/';
    final File file = File("$dir/$filename.pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Checks the status of the manageExternalStorage permission on Android and requests it if it is not granted.
  static Future<bool> checkPermission(TargetPlatform? platform) async {
    if (platform != TargetPlatform.android) {
      return true; // No need to check permissions for non-Android platforms.
    }

    final PermissionStatus status =
        await Permission.manageExternalStorage.status;
    if (status.isGranted) {
      return true; // Permission already granted.
    }

    final PermissionStatus result =
        await Permission.manageExternalStorage.request();
    return result.isGranted; // Returns true if granted, false otherwise.
  }

  static String subString(String s) {
    final int dotIndex = s.indexOf('.');
    return dotIndex == -1 ? s : s.substring(0, dotIndex);
  }
}
