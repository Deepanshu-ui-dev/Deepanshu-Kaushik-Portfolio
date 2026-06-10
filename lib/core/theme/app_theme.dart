import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// COLORS
// Design language: "Obsidian & Zinc"
//
// Dark  → True cold-black zinc base. Clearer surface depth layering.
//          More perceptible steps between bg → surface → elevated → pop.
// Light → True white base. Cooler, airier. Strong ink contrast.
//
// Changes from v1:
//  • Dark surfaces: more distinct steps so cards "lift" off the page.
//  • Dark borders: slightly more visible (0.5px lines need enough contrast).
//  • Dark text secondary: bumped from zinc-400 to zinc-300 for readability.
//  • Light bg: true white base instead of zinc-100 (was too gray).
//  • Light surfaces: zinc-50 for panels, zinc-100 for elevated, cleaner ramp.
//  • Light borders: tighter — zinc-400 default, zinc-500 emphasis.
//  • Contribution heatmap: sharper delta between levels for readability.
//  • Semantic colors: error/warning/success all slightly more vivid on dark.
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  // ════════════════════════════════════════════════════════════════
  // DARK THEME — Obsidian Zinc (deeper surface stack)
  // ════════════════════════════════════════════════════════════════

  // Backgrounds — clear depth: 09 → 10 → 14 → 1C → 24
  static const Color bgDark           = Color(0xFF090909); // near-black — page
  static const Color surfaceDark      = Color(0xFF101012); // zinc-900 — cards/panels
  static const Color surfaceElevDark  = Color(0xFF18181B); // zinc-900 raised
  static const Color surfacePopDark   = Color(0xFF1C1C1F); // popovers / dropdowns
  static const Color surfaceHoverDark = Color(0xFF242428); // hover state — clear delta

  // Borders — enough presence for 0.5px lines
  static const Color borderDark       = Color(0xFF3F3F46); // zinc-700 — default
  static const Color border2Dark      = Color(0xFF52525B); // zinc-600 — emphasis
  static const Color borderFocusDark  = Color(0x99F4F4F5); // 60% accent — was 50%

  // Text — readable secondary (zinc-300 not zinc-400)
  static const Color textPrimaryDark  = Color(0xFFF4F4F5); // zinc-100
  static const Color textSecDark      = Color(0xFFD4D4D8); // zinc-300 ← bumped
  static const Color textTerDark      = Color(0xFF71717A); // zinc-500
  static const Color textMutedDark    = Color(0xFF3F3F46); // zinc-700
  static const Color textDisabledDark = Color(0xFF27272A); // zinc-800

  // Accent — near-white zinc
  static const Color accentDark       = Color(0xFFF4F4F5); // zinc-100
  static const Color accentDimDark    = Color(0xFFE4E4E7); // zinc-200
  static const Color accentGlowDark   = Color(0xFFFFFFFF); // white
  static const Color accentSubtleDark = Color(0xFF1C1C1F); // zinc-900 tint
  static const Color accentTintDark   = Color(0xFF27272A); // zinc-800
  static const Color accentInkDark    = Color(0xFF09090B); // zinc-950

  // Semantic — slightly more vivid on dark for better status readability
  static const Color errorDark        = Color(0xFFFF7070); // was 6B6B — more pop
  static const Color errorSubtleDark  = Color(0xFF2C0A0A);
  static const Color warningDark      = Color(0xFFFFB347); // was FFAA33 — warmer
  static const Color warnSubtleDark   = Color(0xFF2A1800);
  static const Color successDark      = Color(0xFF50D68E); // was 4ECC8A — brighter
  static const Color successSubtleDark= Color(0xFF042215);
  static const Color infoDark         = Color(0xFF6EC0EC); // was 60B8E8 — clearer
  static const Color infoSubtleDark   = Color(0xFF041A28);

  // ════════════════════════════════════════════════════════════════
  // LIGHT THEME — True White + Cool Ink
  // ════════════════════════════════════════════════════════════════

  // Backgrounds — true white base, zinc-50 surfaces, cleaner ramp
  static const Color bgLight          = Color(0xFFFFFFFF); // pure white — page bg
  static const Color surfaceLight     = Color(0xFFFAFAFA); // zinc-50 — cards/panels
  static const Color surfaceElevLight = Color(0xFFF4F4F5); // zinc-100 — elevated
  static const Color surfacePopLight  = Color(0xFFFFFFFF); // white popover
  static const Color surfaceHoverLight= Color(0xFFE4E4E7); // zinc-200 — hover

  // Borders — tighter for light mode (dark text does the heavy lifting)
  static const Color borderLight      = Color(0xFFA1A1AA); // zinc-400 ← was zinc-500
  static const Color border2Light     = Color(0xFF71717A); // zinc-500 ← was zinc-600
  static const Color borderFocusLight = Color(0x9918181B); // 60% accent

  // Text — unchanged, strong ink ramp
  static const Color textPrimaryLight = Color(0xFF09090B); // zinc-950
  static const Color textSecLight     = Color(0xFF52525B); // zinc-600
  static const Color textTerLight     = Color(0xFF71717A); // zinc-500
  static const Color textMutedLight   = Color(0xFFA1A1AA); // zinc-400
  static const Color textDisabledLight= Color(0xFFD4D4D8); // zinc-300

  // Accent — near-black ink
  static const Color accentLight      = Color(0xFF18181B); // zinc-900
  static const Color accentDimLight   = Color(0xFF27272A); // zinc-800
  static const Color accentGlowLight  = Color(0xFF09090B); // zinc-950
  static const Color accentSubtleLight= Color(0xFFF4F4F5); // zinc-100
  static const Color accentTintLight  = Color(0xFFE4E4E7); // zinc-200
  static const Color accentInkLight   = Color(0xFFFAFAFA); // zinc-50

  // Semantic — unchanged, already correct for light mode
  static const Color errorLight       = Color(0xFFB81C1C);
  static const Color errorSubtleLight = Color(0xFFFFF0F0);
  static const Color warningLight     = Color(0xFF924800);
  static const Color warnSubtleLight  = Color(0xFFFFF4E0);
  static const Color successLight     = Color(0xFF1E6B3C);
  static const Color successSubtleLight=Color(0xFFEAF7EE);
  static const Color infoLight        = Color(0xFF1A5E8C);
  static const Color infoSubtleLight  = Color(0xFFEBF4FC);

  // ════════════════════════════════════════════════════════════════
  // CONTRIBUTION HEATMAP — Sharper ramp for readability
  // More distinct deltas between levels 0–5
  // ════════════════════════════════════════════════════════════════

  // Dark — wider steps, level 4 is lighter, level 5 stays pure white
  static const Color contrib0Dark     = Color(0xFF111113); // surface (empty)
  static const Color contrib1Dark     = Color(0xFF27272A); // zinc-800
  static const Color contrib2Dark     = Color(0xFF3F3F46); // zinc-700
  static const Color contrib3Dark     = Color(0xFF71717A); // zinc-500 ← was zinc-600
  static const Color contrib4Dark     = Color(0xFFE4E4E7); // zinc-200 ← was zinc-300
  static const Color contrib5Dark     = Color(0xFFFFFFFF); // white (peak)

  // Light — stronger contrast, peak is true black
  static const Color contrib0Light    = Color(0xFFE4E4E7); // zinc-200 (empty)
  static const Color contrib1Light    = Color(0xFFD4D4D8); // zinc-300
  static const Color contrib2Light    = Color(0xFFA1A1AA); // zinc-400
  static const Color contrib3Light    = Color(0xFF71717A); // zinc-500
  static const Color contrib4Light    = Color(0xFF3F3F46); // zinc-700 ← was zinc-600
  static const Color contrib5Light    = Color(0xFF09090B); // zinc-950 (peak)

  // ════════════════════════════════════════════════════════════════
  // THEME FLAG & DYNAMIC ACCESSORS
  // ════════════════════════════════════════════════════════════════

  static bool isDarkMode = true;

  // Surfaces
  static Color get bg             => isDarkMode ? bgDark             : bgLight;
  static Color get background     => bg;
  static Color get surface        => isDarkMode ? surfaceDark        : surfaceLight;
  static Color get surfaceElev    => isDarkMode ? surfaceElevDark    : surfaceElevLight;
  static Color get surfacePop     => isDarkMode ? surfacePopDark     : surfacePopLight;
  static Color get surfaceHover   => isDarkMode ? surfaceHoverDark   : surfaceHoverLight;

  // Borders
  static Color get border         => isDarkMode ? borderDark         : borderLight;
  static Color get surfaceBorder  => border;
  static Color get border2        => isDarkMode ? border2Dark        : border2Light;
  static Color get borderFocus    => isDarkMode ? borderFocusDark    : borderFocusLight;

  // Text
  static Color get textPrimary    => isDarkMode ? textPrimaryDark    : textPrimaryLight;
  static Color get textSecondary  => isDarkMode ? textSecDark        : textSecLight;
  static Color get textTertiary   => isDarkMode ? textTerDark        : textTerLight;
  static Color get textTer        => textTertiary;
  static Color get textMuted      => isDarkMode ? textMutedDark      : textMutedLight;
  static Color get textDisabled   => isDarkMode ? textDisabledDark   : textDisabledLight;

  // Accent
  static Color get accent         => isDarkMode ? accentDark         : accentLight;
  static Color get accentDim      => isDarkMode ? accentDimDark      : accentDimLight;
  static Color get accentGlow     => isDarkMode ? accentGlowDark     : accentGlowLight;
  static Color get accentSubtle   => isDarkMode ? accentSubtleDark   : accentSubtleLight;
  static Color get accentMuted    => accentSubtle;
  static Color get accentTint     => isDarkMode ? accentTintDark     : accentTintLight;
  static Color get accentText     => isDarkMode ? accentInkDark      : accentInkLight;
  static Color get accentHover    => accentGlow;

  // Semantic
  static Color get error          => isDarkMode ? errorDark          : errorLight;
  static Color get errorSubtle    => isDarkMode ? errorSubtleDark    : errorSubtleLight;
  static Color get warning        => isDarkMode ? warningDark        : warningLight;
  static Color get warnSubtle     => isDarkMode ? warnSubtleDark     : warnSubtleLight;
  static Color get success        => isDarkMode ? successDark        : successLight;
  static Color get successSubtle  => isDarkMode ? successSubtleDark  : successSubtleLight;
  static Color get info           => isDarkMode ? infoDark           : infoLight;
  static Color get infoSubtle     => isDarkMode ? infoSubtleDark     : infoSubtleLight;

  // Heatmap
  static Color get contrib0       => isDarkMode ? contrib0Dark       : contrib0Light;
  static Color get contrib1       => isDarkMode ? contrib1Dark       : contrib1Light;
  static Color get contrib2       => isDarkMode ? contrib2Dark       : contrib2Light;
  static Color get contrib3       => isDarkMode ? contrib3Dark       : contrib3Light;
  static Color get contrib4       => isDarkMode ? contrib4Dark       : contrib4Light;
  static Color get contrib5       => isDarkMode ? contrib5Dark       : contrib5Light;

  static Color contribForLevel(int level) {
    switch (level.clamp(0, 5)) {
      case 0:  return contrib0;
      case 1:  return contrib1;
      case 2:  return contrib2;
      case 3:  return contrib3;
      case 4:  return contrib4;
      default: return contrib5;
    }
  }

  // Hatch background dots — very subtle
  static Color get gridDotColor => isDarkMode
      ? Colors.white.withValues(alpha: 0.025)
      : Colors.black.withValues(alpha: 0.025);
}

// ─────────────────────────────────────────────────────────────────────────────
// SPACING
// Editorial tight grid. 720px max content width.
// ─────────────────────────────────────────────────────────────────────────────

class AppSpacing {
  // Breakpoints
  static const double mobileMax       = 650;
  static const double tabletMax       = 1100;
  static const double maxContentWidth = 720; // editorial centering

  // Scale — tighter than before
  static const double xxs   = 2;   // hairline / icon nudge
  static const double xs    = 4;   // tight inline gap
  static const double sm    = 6;   // default inline gap (prefer 6 over 8)
  static const double md    = 10;  // component internal gap (prefer 10 over 12)
  static const double base  = 16;  // base unit
  static const double lg    = 24;  // section internal gap
  static const double xl    = 32;  // card padding / section gap
  static const double xxl   = 40;  // major section separation (was 48)
  static const double xxxl  = 56;  // hero / above-fold spacing
  static const double section= 80; // between page sections

  // Breakpoint helpers
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isLaptop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletMax;

  // Responsive horizontal padding — centers content at 720px max
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400) return (w - maxContentWidth) / 2;
    if (w >= tabletMax) return 80;
    if (w >= mobileMax) return 40;
    if (w >= 400)       return 24;
    return 16;
  }

  // Responsive headline sizing
  static double headlineSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double laptop,
  }) {
    if (isLaptop(context)) return laptop;
    if (isTablet(context)) return tablet;
    return mobile;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RADIUS
// Sharp editorial — minimal rounding, zero on cards by default.
// ─────────────────────────────────────────────────────────────────────────────

class AppRadius {
  static const double none  = 0;
  static const double xs    = 2;   // Subtle — input corners, tech chips
  static const double sm    = 4;   // Tags / chips
  static const double md    = 6;   // Buttons
  static const double lg    = 8;   // Standard cards
  static const double xl    = 12;  // Large cards / modals
  static const double xxl   = 16;  // Sheet / bottom drawer
  static const double pill  = 999; // Badges / toggles

  static const BorderRadius zero    = BorderRadius.zero;
  static const BorderRadius subtle  = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius card    = BorderRadius.zero; // flat editorial cards
  static const BorderRadius dialog  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius button  = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius chip    = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius avatar  = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius sheet   = BorderRadius.vertical(top: Radius.circular(xxl));

  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(sm));

  static const double cardValue = 0; // flat
  static BorderRadius top(double radius) => BorderRadius.vertical(top: Radius.circular(radius));
}

// ─────────────────────────────────────────────────────────────────────────────
// THEME DATA
// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  static ThemeData dark()  => _build(isDark: true);
  static ThemeData light() => _build(isDark: false);

  static ThemeData _build({required bool isDark}) {
    const mono = 'JetBrainsMono';

    final bg           = isDark ? AppColors.bgDark           : AppColors.bgLight;
    final surface      = isDark ? AppColors.surfaceDark      : AppColors.surfaceLight;
    final surfaceElev  = isDark ? AppColors.surfaceElevDark  : AppColors.surfaceElevLight;
    final surfacePop   = isDark ? AppColors.surfacePopDark   : AppColors.surfacePopLight;
    final border       = isDark ? AppColors.borderDark       : AppColors.borderLight;
    final border2      = isDark ? AppColors.border2Dark      : AppColors.border2Light;
    final borderFocus  = isDark ? AppColors.borderFocusDark  : AppColors.borderFocusLight;
    final textPrimary  = isDark ? AppColors.textPrimaryDark  : AppColors.textPrimaryLight;
    final textSec      = isDark ? AppColors.textSecDark      : AppColors.textSecLight;
    final textTer      = isDark ? AppColors.textTerDark      : AppColors.textTerLight;
    final textMuted    = isDark ? AppColors.textMutedDark    : AppColors.textMutedLight;
    final accent       = isDark ? AppColors.accentDark       : AppColors.accentLight;
    final accentSubtle = isDark ? AppColors.accentSubtleDark : AppColors.accentSubtleLight;
    final accentInk    = isDark ? AppColors.accentInkDark    : AppColors.accentInkLight;
    final error        = isDark ? AppColors.errorDark        : AppColors.errorLight;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ).copyWith(
      primary:              accent,
      onPrimary:            accentInk,
      primaryContainer:     accentSubtle,
      onPrimaryContainer:   accent,
      secondary:            accent,
      onSecondary:          accentInk,
      surface:              surface,
      onSurface:            textPrimary,
      surfaceContainer:     surfaceElev,
      surfaceContainerHigh: isDark ? AppColors.surfaceHoverDark : AppColors.surfaceHoverLight,
      outline:              border,
      outlineVariant:       border2,
      tertiary:             textTer,
      onTertiary:           bg,
      error:                error,
      onError:              accentInk,
    );

    return ThemeData(
      useMaterial3:             true,
      brightness:               isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor:  Colors.transparent,
      splashFactory:            NoSplash.splashFactory,
      highlightColor:           Colors.transparent,
      hoverColor:               Colors.transparent,
      colorScheme:              colorScheme,
      fontFamily:               mono,

      // ── Text theme ─────────────────────────────────────────────────────────
      textTheme: TextTheme(

        // Display — hero headlines, Outfit ExtraBold
        displayLarge: TextStyle(
          fontFamily: 'Outfit', fontSize: 36, fontWeight: FontWeight.w800,
          color: textPrimary, letterSpacing: -1.2, height: 1.0,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Outfit', fontSize: 28, fontWeight: FontWeight.w700,
          color: textPrimary, letterSpacing: -0.8, height: 1.05,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w700,
          color: textPrimary, letterSpacing: -0.5, height: 1.1,
        ),

        // Headline — section and card titles, Outfit SemiBold
        headlineLarge: TextStyle(
          fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: -0.2, height: 1.35,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: -0.1, height: 1.35,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600,
          color: textPrimary, letterSpacing: 0, height: 1.35,
        ),

        // Body — Outfit Regular, natural reading rhythm
        bodyLarge: TextStyle(
          fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400,
          color: textPrimary, height: 1.65, letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Outfit', fontSize: 13.5, fontWeight: FontWeight.w400,
          color: textSec, height: 1.65, letterSpacing: 0,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w400,
          color: textSec, height: 1.6, letterSpacing: 0,
        ),

        // Label — JetBrainsMono for code / metadata / tags
        labelLarge: TextStyle(
          fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w500,
          color: textPrimary, letterSpacing: 0.88,
        ),
        labelMedium: TextStyle(
          fontFamily: mono, fontSize: 10, fontWeight: FontWeight.w400,
          color: textSec, letterSpacing: 0.8,
        ),
        labelSmall: TextStyle(
          fontFamily: mono, fontSize: 9, fontWeight: FontWeight.w400,
          color: textMuted, letterSpacing: 0.72,
        ),
      ),

      // ── Inputs ─────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hoverColor: surfaceElev,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: AppRadius.button,
          borderSide: BorderSide(color: border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.button,
          borderSide: BorderSide(color: border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.button,
          borderSide: BorderSide(color: borderFocus, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.button,
          borderSide: BorderSide(color: error, width: 0.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.button,
          borderSide: BorderSide(color: error, width: 1.0),
        ),
        hintStyle: TextStyle(
          fontFamily: mono, fontSize: 12,
          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
        ),
        labelStyle:         TextStyle(fontFamily: mono, fontSize: 11, color: textTer),
        floatingLabelStyle: TextStyle(fontFamily: mono, fontSize: 10, color: accent),
      ),

      // ── Elevated buttons ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:    accent,
          foregroundColor:    accentInk,
          disabledBackgroundColor: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
          disabledForegroundColor: isDark ? AppColors.textMutedDark   : AppColors.textMutedLight,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
      ),

      // ── Outlined buttons ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border2, width: 0.5),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          textStyle: const TextStyle(
            fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ── Text buttons ────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          textStyle: const TextStyle(
            fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // ── Cards ──────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Dialogs ─────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surfacePop,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialog,
          side: BorderSide(color: border, width: 0.5),
        ),
      ),

      // ── Bottom sheet ────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfacePop,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.sheet,
          side: BorderSide(color: border, width: 0.5),
        ),
        dragHandleColor: border2,
        dragHandleSize: const Size(36, 3),
      ),

      // ── Dividers — hairlines ─────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 0.5,
        space: 0.5,
      ),

      // ── Scrollbar ────────────────────────────────────────────────────────────
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.hovered) ? border2 : border),
        thickness: WidgetStateProperty.all(2),
        radius: const Radius.circular(AppRadius.xs),
        interactive: true,
        mainAxisMargin: 2,
        crossAxisMargin: 2,
      ),

      // ── Tooltip ─────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceElev,
          border: Border.all(color: border, width: 0.5),
          borderRadius: AppRadius.subtle,
        ),
        textStyle: TextStyle(
          fontFamily: mono, fontSize: 10,
          fontWeight: FontWeight.w400, color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        waitDuration: const Duration(milliseconds: 300),
        showDuration: const Duration(seconds: 3),
      ),

      // ── Chips ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: accentSubtle,
        disabledColor: surface,
        labelStyle: TextStyle(
          fontFamily: mono, fontSize: 10,
          fontWeight: FontWeight.w400, color: textSec,
        ),
        side: BorderSide(color: border, width: 0.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.chip),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        elevation: 0,
        pressElevation: 0,
      ),

      // ── List tiles ──────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: accentSubtle,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.zero),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        titleTextStyle: TextStyle(
          fontFamily: mono, fontSize: 13,
          fontWeight: FontWeight.w400, color: textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: mono, fontSize: 11,
          fontWeight: FontWeight.w400, color: textSec,
        ),
        iconColor: textTer,
        minLeadingWidth: 20,
      ),

      // ── Switch ──────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? accentInk
                : border2),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : surfaceElev),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.transparent : border),
      ),

      // ── Checkbox ────────────────────────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : Colors.transparent),
        checkColor: WidgetStateProperty.all(accentInk),
        side: BorderSide(color: border2, width: 0.5),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs))),
        overlayColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.hovered)
                ? accentSubtle.withValues(alpha: 0.5)
                : Colors.transparent),
      ),

      // ── Radio ───────────────────────────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? accent : border2),
        overlayColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.hovered)
                ? accentSubtle.withValues(alpha: 0.5)
                : Colors.transparent),
      ),

      // ── Slider ──────────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor:   accent,
        inactiveTrackColor: border2,
        thumbColor:         accent,
        overlayColor:       accent.withValues(alpha: 0.1),
        trackHeight: 1.5,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
      ),

      // ── Progress indicator ──────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: accentSubtle,
        circularTrackColor: Colors.transparent,
        linearMinHeight: 1.5,
      ),

      // ── Tab bar ─────────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: textPrimary,
        unselectedLabelColor: textTer,
        indicatorColor: accent,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontFamily: mono, fontSize: 11,
          fontWeight: FontWeight.w600, letterSpacing: 0.4,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: mono, fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        dividerColor: border,
      ),

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: mono, fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimary,
          letterSpacing: 0.6,
        ),
        iconTheme: IconThemeData(color: textSec, size: 16),
        actionsIconTheme: IconThemeData(color: textSec, size: 16),
        toolbarHeight: 48,
      ),

      // ── Navigation bar (bottom) ─────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: accentSubtle,
        labelTextStyle: WidgetStateProperty.resolveWith((s) =>
            TextStyle(
              fontFamily: mono, fontSize: 10,
              fontWeight: s.contains(WidgetState.selected)
                  ? FontWeight.w600 : FontWeight.w400,
              color: s.contains(WidgetState.selected) ? accent : textTer,
            )),
        iconTheme: WidgetStateProperty.resolveWith((s) =>
            IconThemeData(
              color: s.contains(WidgetState.selected) ? accent : textTer,
              size: 18,
            )),
        elevation: 0,
        height: 58,
      ),

      // ── Popup menu ──────────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: surfacePop,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.subtle,
          side: BorderSide(color: border, width: 0.5),
        ),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontFamily: mono, fontSize: 12,
            fontWeight: FontWeight.w400, color: textPrimary,
          ),
        ),
      ),

      // ── Snack bar ───────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? AppColors.surfaceHoverDark
            : AppColors.textPrimaryLight,
        contentTextStyle: TextStyle(
          fontFamily: mono, fontSize: 12,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textPrimaryDark : AppColors.bgLight,
        ),
        actionTextColor: accent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
          side: BorderSide(color: border, width: 0.5),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Badge ───────────────────────────────────────────────────────────────
      badgeTheme: BadgeThemeData(
        backgroundColor: accent,
        textColor: accentInk,
        textStyle: const TextStyle(
          fontFamily: mono, fontSize: 9, fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        largeSize: 16,
        smallSize: 6,
      ),

      // ── Icons ───────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: textSec, size: 16),
      primaryIconTheme: IconThemeData(color: accent, size: 16),
    );
  }
}