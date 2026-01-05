import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTypography {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const section = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const body = TextStyle(fontSize: 14, color: AppColors.text);
  static const caption = TextStyle(fontSize: 12, color: AppColors.muted);
  static const button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
