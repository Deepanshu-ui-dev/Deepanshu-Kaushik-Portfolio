import 'package:flutter/material.dart';

/// Design tokens for the editorial layout: warm paper whites, zinc greys,
/// a serif display face and Inter for everything else (two fonts only) for body copy.
class Ed {
  Ed._(this.dark);
  final bool dark;

  factory Ed.of(BuildContext context) =>
      Ed._(Theme.of(context).brightness == Brightness.dark);

  static const double column = 760;
  static const double headerH = 52;

  // ── colour ──────────────────────────────────────────────────────────
  Color get page => dark ? const Color(0xFF09090A) : const Color(0xFFFCFCFB);
  Color get paper => dark ? const Color(0xFF0C0C0D) : const Color(0xFFFEFEFD);
  Color get card => dark ? const Color(0xFF111113) : Colors.white;
  Color get raised => dark ? const Color(0xFF18181B) : const Color(0xFFF4F4F5);
  Color get line => dark ? const Color(0xFF232326) : const Color(0xFFE6E6E4);
  Color get line2 => dark ? const Color(0xFF34343A) : const Color(0xFFD4D4D2);
  Color get hatch => dark ? const Color(0xFF1E1E21) : const Color(0xFFE9E9E6);
  Color get ink => dark ? const Color(0xFFF4F4F5) : const Color(0xFF111113);
  Color get ink2 => dark ? const Color(0xFFB4B4BB) : const Color(0xFF52525B);
  Color get ink3 => dark ? const Color(0xFF71717A) : const Color(0xFFA1A1AA);
  Color get live => const Color(0xFF22C55E);

  // Design-tool accents — used sparingly so the page stays monochrome.
  Color get select => const Color(0xFF0D99FF); // Figma selection blue
  Color get redline => const Color(0xFFF2416B); // spec / measurement pink
  Color get cursor => const Color(0xFFA259FF); // collaborator cursor
  Color get canvas => dark ? const Color(0xFF0F0F11) : const Color(0xFFF7F7F5);

  // ── type ────────────────────────────────────────────────────────────
  TextStyle serif(double size, {Color? color, bool italic = false}) => TextStyle(
        fontFamily: 'InstrumentSerif',
        fontSize: size,
        height: 1.1,
        letterSpacing: -0.2,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: color ?? ink,
      );

  TextStyle mono(double size, {Color? color, FontWeight w = FontWeight.w400, double ls = 0.2}) =>
      TextStyle(
        fontFamily: 'Inter',
        fontSize: size + 0.5,
        height: 1.4,
        letterSpacing: ls,
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: w,
        color: color ?? ink3,
      );

  TextStyle sans(double size, {Color? color, FontWeight w = FontWeight.w400, double h = 1.6}) =>
      TextStyle(
        fontFamily: 'Inter',
        fontSize: size,
        height: h,
        letterSpacing: -0.1,
        fontWeight: w,
        color: color ?? ink2,
      );

  static const ColorFilter grayscale = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const ColorFilter identity = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);
}
