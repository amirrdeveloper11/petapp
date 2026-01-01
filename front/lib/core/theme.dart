import 'package:flutter/material.dart';

class AppColors {
  // Primary color
  static const Color primaryGreen = Color(0xFF4CAF50); // slightly deeper green
  static const Color primaryGreenLight = Color(
    0xFF81C784,
  ); // lighter green accent
  static const Color primaryGreenDark = Color(0xFF388E3C); // dark variant

  // Secondary accent color
  static const Color secondaryOrange = Color(0xFFFFA726);
  static const Color secondaryOrangeLight = Color(0xFFFFCC80);

  // Background
  static const Color background = Color(0xFFF5F5F5); // main background
  static const Color softBackground = Color(
    0xFFE8F5E9,
  ); // subtle greenish background
  static const Color cardBackground = Colors.white; // card backgrounds

  // Text colors
  static const Color textDark = Color(0xFF212121); // main text
  static const Color textPrimary = Color(0xFF2E3A2E); // headings
  static const Color textSecondary = Color(0xFF757575); // subtext / muted

  // Borders
  static const Color inputStroke = Color(0xFFBDBDBD);
  static const Color muted = Color(0xFF9E9E9E);

  // Shadowss
  static const Color shadowLight = Color(0x1F000000); // subtle shadow
  static const Color shadowDark = Color(
    0x33000000,
  ); // stronger shadow for cards
}
