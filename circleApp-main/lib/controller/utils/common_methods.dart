import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

String toCamelCase(String input) => input
    .split(' ')
    .asMap()
    .map((i, word) => MapEntry(
        i,
        i == 0
            ? word.toLowerCase()
            : word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : ''))
    .values
    .join('');

String timeAgoSinceDate(DateTime dateTime) {
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    final int weeks = (difference.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  }
}

String getCurrentTimeIn12HourFormat(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

// List<String> processPhoneNumbers(List<String> phoneNumbers) {
//   IsoCode defaultCountryIsoCode = IsoCode.CA;
//
//   String sanitizeNumber(String number) {
//     print('Sanitizing number: $number');
//     return number.replaceAll(RegExp(r'[^\d+]'), '');
//   }
//
//   List<String> validNumbers = [];
//
//   for (var number in phoneNumbers) {
//     print('Processing number: $number');
//     String sanitizedNumber = sanitizeNumber(number);
//     print('Sanitized number: $sanitizedNumber');
//
//     try {
//       var phoneNumber = PhoneNumber.parse(sanitizedNumber, callerCountry: defaultCountryIsoCode);
//       print('Parsed phone number: $phoneNumber');
//
//       if (phoneNumber.isValid()) {
//         print('Valid phone number: ${phoneNumber.international}');
//         validNumbers.add(phoneNumber.international);
//       } else if (sanitizedNumber.startsWith('0')) {
//         print('Number starts with 0, adjusting: $sanitizedNumber');
//         var adjustedNumber = sanitizedNumber.replaceFirst('0', countryDialingCodes[defaultCountryIsoCode]!);
//         print('Adjusted number: $adjustedNumber');
//
//         var phoneNumberWithCountryCode = PhoneNumber.parse(adjustedNumber);
//         print('Parsed adjusted phone number: $phoneNumberWithCountryCode');
//
//         if (phoneNumberWithCountryCode.isValid()) {
//           print('Valid adjusted phone number: ${phoneNumberWithCountryCode.international}');
//           validNumbers.add(phoneNumberWithCountryCode.international);
//         } else {
//           print('Invalid adjusted phone number: $adjustedNumber');
//         }
//       } else {
//         print('Invalid phone number: $sanitizedNumber');
//       }
//     } catch (e) {
//       print('Failed to parse number: $number. Error: $e');
//     }
//   }
//
//   print('Valid numbers: $validNumbers');
//   return validNumbers;
// }

List<Contact> filterContacts(List<Contact> contacts) {
  try {
    // First remove: invalid phone numbers
    contacts.removeWhere((contact) {
      try {
        String sanitizedNumber = contact.phones.first.number.replaceAll(RegExp(r'[^\d+]'), '') ?? "";
        return !isValidPhoneNumber(sanitizedNumber);
      } catch (e) {
        print("Error sanitizing or validating phone number: ${contact.displayName}. Error: $e");
        return true; // Remove contact if there's an issue
      }
    });

    // Second remove: non-Canada or non-USA numbers
    contacts.removeWhere((contact) {
      try {
        if (contact.phones.isEmpty) {
          print("Contact has no phone number: ${contact.displayName}");
          return true; // Remove contacts with no phone numbers
        }
        String sanitizedNumber = contact.phones.first.number.replaceAll(RegExp(r'[^\d+]'), '') ?? "";
        return !isCanadaOrUSANumber(sanitizedNumber);
      } catch (e) {
        print("Error checking if number is Canada/USA: ${contact.displayName}. Error: $e");
        return true; // Remove contact if there's an issue
      }
    });

    // Update phone numbers for valid contacts
    for (var contact in contacts) {
      try {
        if (contact.phones.isNotEmpty) {
          contact.phones.first.number = contact.phones.first.number.replaceAll(RegExp(r'[^\d+]'), '') ?? "";
        }
      } catch (e) {
        print("Error sanitizing phone number for contact: ${contact.displayName}. Error: $e");
      }
    }
  } catch (e) {
    print("Unexpected error during contact filtering: $e");
  }

  return contacts;
}

bool isValidPhoneNumber(String phoneNumber) {
  return phoneNumber.startsWith("+");
}

bool isCanadaOrUSANumber(String phoneNumber) {
  return phoneNumber.startsWith("+1") || phoneNumber.startsWith("+141");
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0')}';
}

Color hexToColor(String hexString) {
  hexString = hexString.replaceFirst('#', '');
  if (hexString.length == 6) {
    hexString = 'ff$hexString';
  }
  return Color(int.parse(hexString, radix: 16));
}

bool isImageFile(XFile? file) {
  String extension = getFileExtension(file);
  return extension == 'jpg' || extension == 'jpeg' || extension == 'png';
}

String getFileExtension(XFile? file) {
  return file!.path.split('.').last.toLowerCase();
}

String localToUTC(DateTime dateTime) {
  return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(dateTime.toUtc());
}

DateTime utcToLocal(String utcString) {
  return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").parse(utcString, true).toLocal();
}

String getFormattedTime(TimeOfDay? timeOfDay) {
  timeOfDay ??= TimeOfDay.now();
  return DateFormat('hh:mm a').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, timeOfDay.hour, timeOfDay.minute));
}

String getFormattedDate(DateTime? dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime ?? DateTime.now());
}

const Map<String, String> eventColors = {
  "red": "#FF0000",
  "green": "#00FF00",
  "blue": "#0000FF",
  "yellow": "#FFFF00",
  "purple": "#800080",
  "orange": "#FFA500",
  "pink": "#FFC0CB",
  "brown": "#A52A2A",
  "cyan": "#00FFFF",
  "magenta": "#FF00FF",
};

String colorNameToCode(String colorName) {
  return eventColors[colorName.toLowerCase()] ?? "#000000";
}

String colorCodeToName(String colorCode) {
  return eventColors.entries.firstWhere((entry) => entry.value == colorCode, orElse: () => const MapEntry("red", "#FF0000")).key;
}

int colorCodeToInt(String colorCode) {
  return int.parse(colorCode.replaceFirst('#', '0xff'));
}

String intToColorCode(int colorInt) {
  String hex = colorInt.toRadixString(16).padLeft(8, '0'); // Convert to hex with 8 digits
  return '#${hex.substring(2)}';
}

