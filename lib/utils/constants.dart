
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.red;
  static const Color primaryLight = Color(0xFFFFE0B2);
  static const Color background = Colors.white;
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyMedium = Color(0xFFE0E0E0);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle heading4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
   static const TextStyle button = TextStyle(
    fontSize: 16,
    color: AppColors.primary,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );
}

class AppDimens {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double borderRadius = 30.0;
  static const double high100= 100.0;
  static const double iconSize = 60.0;
}