import 'package:flutter/material.dart';

class AppColors {
  // Primary & Dark Tones (Deep Slate / Obsidian)
  static const Color mainColor = Color(0xFF0F172A); // Deep Slate / Obsidian
  static const Color secondColor = Color(0xFF64748B); // Modern Slate Grey

  // Electric Accent Colors
  static const Color primaryAccent = Color(0xFF6366F1); // Indigo Electric
  static const Color mintAccent = Color(0xFF10B981); // Mint Emerald (Success / CTA)
  static const Color violetAccent = Color(0xFF8B5CF6); // Electric Violet

  // Background & Surfaces
  static const Color scaffoldBackground = Color(0xFFF8FAFC); // Warm soft grey
  static const Color cardSurface = Colors.white; // Pure white card
  static const Color white = Colors.white;
  static const Color black = Color(0xFF0F172A);
  static const Color greylight = Color(0xFFF1F5F9);
  static const Color red = Color(0xFFEF4444); // Modern soft red
  static const Color placeholderColor = Color(0xFFF1F5F9);
  static const Color borderColor = Color(0xFFE2E8F0); // Subtle slate border
  static const Color lightFillColor = Color(0xFFF8FAFC);

  // Soft Depth & Shadows System (Soft diffused shadows)
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x08000000), // Super soft and diffused
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x04000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static final Border subtleCardBorder = Border.all(
    color: Colors.black.withValues(alpha: 0.04),
    width: 1,
  );
}
