import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Returns a formatted date string from an integer representation of a date in milliseconds.
String intToDateString(int intDate) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(intDate * 1000);

  return DateFormat('dd-MM-yyyy').format(dateTime);
}

/// Returns a [DateTime] object from an integer representation of a date in milliseconds.
DateTime intToDateTime(int intDate) {
  return DateTime.fromMillisecondsSinceEpoch(intDate * 1000);
}

/// Returns an integer representation of a date from a [DateTime] object.
String dateTimeToInt(DateTime date) {
  var convert = DateUtils.dateOnly(date).millisecondsSinceEpoch / 1000;
  return convert.toString().substring(0, 10);
}

/// Returns the integer representation of a number without the decimal point.
String amounts(String input) {
  if (input.isNotEmpty) {
    return input.substring(0, input.indexOf('.'));
  }
  return '0';
}

/// Returns the date portion of a [DateTime] object as a string.
String datePaid(DateTime input) {
  var string = input.toString();
  return string.substring(0, string.indexOf(' '));
}

/// Returns a formatted date string from a [DateTime] object.
String dateTimeToString(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}

/// Launches the default phone app and dials the specified phone number.
Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

/// Returns a [TextStyle] object with a red color if the due date is in the past, or null if the due date is in the future or present.
overDueStyle(int dueDate) {
  if (intToDateTime(dueDate).isBefore(DateTime.now())) {
    return const TextStyle(color: Colors.red);
  } else {
    null;
  }
}

/// Creates a file from a base64-encoded string and returns the file path.
Future<String> createFileFromString(String encodedStr, String filename) async {
  Uint8List bytes = base64.decode(encodedStr);
  const String dir = '/storage/emulated/0/Download/';
  File file = File("$dir/$filename.pdf");
  await file.writeAsBytes(bytes);
  return file.path;
}

/// Checks the status of the manageExternalStorage permission on Android and requests it if it is not granted.
Future<bool> checkPermission(TargetPlatform? platform) async {
  if (platform == TargetPlatform.android) {
    final status = await Permission.manageExternalStorage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.manageExternalStorage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
  } else {
    return true;
  }
  return false;
}

String subString(String s) {
  return s.substring(0, s.indexOf('.'));
}
