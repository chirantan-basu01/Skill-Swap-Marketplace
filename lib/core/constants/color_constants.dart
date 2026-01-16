import 'package:flutter/material.dart';

/// App color palette based on design system
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueHover = Color(0xFF1D4ED8);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Secondary Colors
  static const Color secondaryTeal = Color(0xFF14B8A6);
  static const Color secondaryTealHover = Color(0xFF0D9488);
  static const Color secondarySurface = Color(0xFFF0FDFA);

  // Neutral / Gray Scale
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successSurface = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSurface = Color(0xFFEFF6FF);

  // Background Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray400;
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = gray200;
  static const Color borderLight = gray100;
  static const Color borderFocused = primaryBlue;

  // Match Badge Colors
  static const Color perfectMatchBg = Color(0xFFFEF3C7);
  static const Color perfectMatchText = Color(0xFFD97706);

  // Credit Colors
  static const Color creditEarned = success;
  static const Color creditSpent = error;
}