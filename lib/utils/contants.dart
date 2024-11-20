
import 'package:agriplant/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';


const tomatoColor = Color(0xFFFF6347);
const primaryColor = Color.fromRGBO(27, 94, 32, 1);

void showCustomSnackBar(BuildContext context, String message,
    {String type = "info",
    IconData? icon,
    Color backgroundColor = Colors.white,
    Duration duration = const Duration(seconds: 2)}) {
  Map<String, Map<String, dynamic>> types = {
    "info": {
      "icon": Icons.info,
      "color": Colors.white,
      "textColor": Colors.black
    },
    "success": {"icon": Icons.check, "color": Colors.green},
    "warning": {"icon": Icons.warning, "color": Colors.orange},
    "error": {"icon": Icons.error, "color": Colors.red},
  };

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(types[type]!["icon"], color: types[type]!["textColor"] ?? Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: types[type]!["textColor"] ?? Colors.white),
          ),
        ),
      ],
    ),
    backgroundColor: types[type]!["color"],
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    duration: duration,
    action: SnackBarAction(
      label: 'Đóng',
      textColor: Colors.white,
      onPressed: () {
        // Hành động khi nhấn vào nút "Đóng"
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


Widget showAdvancedAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
  Color? titleColor,
  Color? contentColor,
  Color? confirmTextColor,
  Color? cancelTextColor,
  Color? backgroundColor,
  Widget? icon,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return AlertDialog(
    backgroundColor: backgroundColor ?? Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    title: Row(
      children: [
        if (icon != null) ...[
          icon,
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    content: Text(
      content,
      style: TextStyle(
        color: contentColor ?? Colors.black87,
      ),
    ),
    actions: [
      TextButton(
        child: Text(
          cancelText ?? 'Hủy',
          style: TextStyle(
            color: cancelTextColor ?? Colors.red,
          ),
        ),
        onPressed: onCancel ??
            () {
              Navigator.of(context).pop(false);
            },
      ),
      TextButton(
        child: Text(
          confirmText ?? 'Đồng ý',
          style: TextStyle(
            color: confirmTextColor ?? Colors.blueAccent,
          ),
        ),
        onPressed: onConfirm ??
            () {
              Navigator.of(context).pop(true);
            },
      ),
    ],
  );
}



 const imageUrl = "${ baseImageUrl != ""? baseImageUrl : baseUrl}/images/download?filename=";
 const noImage = "https://t3.ftcdn.net/jpg/04/34/72/82/360_F_434728286_OWQQvAFoXZLdGHlObozsolNeuSxhpr84.jpg";



class CustomObjectId {
  static int _counter = Random().nextInt(0xFFFFFF);
  final int timestamp;
  final int machineId;
  final int processId;
  final int counter;

  CustomObjectId()
      : timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000,
        machineId = _generateMachineId(),
        processId = _generateProcessId(),
        counter = _getNextCounter();

  static int _generateMachineId() {
    // Tạo một ID máy ngẫu nhiên 5 byte (40 bit)
    return Random().nextInt(0xFFFFFFF);
  }

  static int _generateProcessId() {
    // Tạo một ID quá trình ngẫu nhiên 3 byte (24 bit)
    return Random().nextInt(0xFFFFFF);
  }

  static int _getNextCounter() {
    _counter = (_counter + 1) & 0xFFFFFF; // Giới hạn 3 byte
    return _counter;
  }

  String toHexString() {
    return _toHex(timestamp, 8) +
        _toHex(machineId, 6) +
        _toHex(processId, 4) +
        _toHex(counter, 6);
  }

  String _toHex(int value, int length) {
    return value.toRadixString(16).padLeft(length, '0').substring(0, length);
  }
}

Color hexToColor(String? hexColor) {
  // If hexColor is null, default to white
  hexColor = hexColor?.replaceAll("#", "") ?? "FFFFFF";

  // If the hex code is 3 characters, convert it to 6 characters (e.g., "FFF" to "FFFFFF")
  if (hexColor.length == 3) {
    hexColor = hexColor.split('').map((c) => '$c$c').join();
  }

  // Add alpha value if not provided
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  } else if (hexColor.length != 8) {
    throw FormatException("Invalid hex color format. Use #RRGGBB or #AARRGGBB.");
  }

  return Color(int.parse(hexColor, radix: 16));
}