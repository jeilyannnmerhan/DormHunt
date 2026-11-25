import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colors sampled from the DormHunt high-fidelity design.
class AppColors {
  static const blue = Color(0xFF0B4EA2);
  static const darkBlue = Color(0xFF0A2A66);
  static const slate = Color(0xFF2A3F5F);
  static const yellow = Color(0xFFFDB913);
  static const red = Color(0xFFDC2626);
  static const fieldFill = Color(0xFFE8EEFF);
  static const ink = Color(0xFF111827);
}

/// Width from which the web/desktop layout is used.
const double kWideBreakpoint = 900;

bool isWide(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kWideBreakpoint;

/// Scale factor so the UI adapts to any phone width.
/// Sizes in the screens are authored for a 390px-wide phone and multiplied
/// by this value. Wide screens (web/tablet) use a fixed scale of 1.
double scaleOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= kWideBreakpoint) return 1.2; // web / desktop
  if (width >= 600) return 1.1; // tablet
  return (width / 390).clamp(0.85, 1.2).toDouble();
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
    scaffoldBackgroundColor: Colors.white,
  );
  return base.copyWith(
    textTheme: GoogleFonts.lexendTextTheme(base.textTheme),
  );
}
