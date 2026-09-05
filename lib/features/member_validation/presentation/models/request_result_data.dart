import 'package:flutter/material.dart';

class RequestResultData {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String message;

  const RequestResultData({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.message,
  });
}