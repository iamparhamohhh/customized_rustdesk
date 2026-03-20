/// ─────────────────────────────────────────────────────────────────────────────
/// RahbarHesab — Centralised Color Palette
/// Purple × Yellow  (Dorsan / modern-app aesthetic)
///
/// HOW TO CUSTOMISE
/// ────────────────
/// Every pixel of colour in the app ultimately traces back to one of the
/// `const Color` values declared inside [RahbarColors].  To re-skin the whole
/// app you only ever need to change values in this file.
///
/// Token hierarchy
/// ───────────────
///   RahbarColors          → raw design tokens (raw hex, no semantics)
///   RahbarSemanticColors  → semantic aliases  ("what it's used for")
///
/// The [MyTheme] class in common.dart consumes [RahbarSemanticColors], so
/// you can also swap out semantic mappings without touching the raw palette.
/// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ─── Raw palette ─────────────────────────────────────────────────────────────

// ignore_for_file: constant_identifier_names

abstract final class RahbarColors {
  RahbarColors._();

  // ── Purple family ───────────────────────────────────────────────────────────
  /// Brand primary – vivid deep-purple.  Bars, active indicators, highlights.
  static const Color purple900 = Color(0xFF4A0080); // deepest
  static const Color purple800 = Color(0xFF6B21A8); // ← main brand primary
  static const Color purple700 = Color(0xFF7C3AED); // slightly lighter variant
  static const Color purple600 = Color(0xFF8B5CF6); // hover states, icon fills
  static const Color purple400 = Color(0xFFA78BFA); // chip backgrounds (light)
  static const Color purple200 = Color(0xFFDDD6FE); // very light tint
  static const Color purple100 = Color(0xFFEDE9FE); // scaffold bg (light mode)
  static const Color purple50 = Color(0xFFF5F3FF); // near-white lavender
  // Dark-mode "container" purples (add colour without blinding brightness)
  static const Color purpleDark900 = Color(0xFF0D0118); // darkest bg
  static const Color purpleDark800 = Color(0xFF160327); // scaffold (dark)
  static const Color purpleDark700 = Color(0xFF1E0A38); // dialog bg (dark)
  static const Color purpleDark600 = Color(0xFF2D1458); // card / surface (dark)
  static const Color purpleDark500 = Color(0xFF3B1A6E); // border (dark)
  static const Color purpleDark400 = Color(0xFF4C2485); // hover (dark)

  // ── Yellow / Amber family ───────────────────────────────────────────────────
  /// Brand accent – golden yellow.  Primary buttons, CTAs, icons, badges.
  static const Color yellow700 = Color(0xFFFFD600); // pure golden-yellow
  static const Color yellow600 = Color(0xFFCABF00); // slightly muted
  static const Color yellow500 = Color(0xFFFFBF00); // amber-warm
  static const Color yellow400 = Color(0xFFFFE57F); // pastel; pressed states
  static const Color yellow200 = Color(0xFFFFF9C4); // very light; hint text bg
  static const Color yellowDark = Color(0xFFB38600); // text on light bg (a11y)
  // Pre-baked opacity variants (const-compatible)
  static const Color yellow50pct = Color(0x77FFD600); // yellow @ ~47 %
  static const Color yellow80pct = Color(0xAAFFD600); // yellow @ ~67 %

  // ── Neutrals (purple-tinted grays) ─────────────────────────────────────────
  static const Color neutral900 = Color(0xFF12082A); // near-black
  static const Color neutral800 = Color(0xFF241544); // dark text
  static const Color neutral700 = Color(0xFF3E2A63); // secondary text (dark)
  static const Color neutral500 = Color(0xFF7B68A8); // placeholder / hint
  static const Color neutral300 = Color(0xFFBAADD6); // dividers (light)
  static const Color neutral200 = Color(0xFFD8CCEA); // borders (light)
  static const Color neutral100 = Color(0xFFEFEBF8); // light card bg
  static const Color neutral50 = Color(0xFFF9F7FF); // lightest bg

  // ── Status colours (harmonised with the palette) ───────────────────────────
  static const Color green500 = Color(0xFF34D399); // success (emerald)
  static const Color green900 = Color(0xFF064E3B); // success dark bg
  static const Color red500 = Color(0xFFFC6B68); // error (warm-red)
  static const Color red900 = Color(0xFF7F1D1D); // error dark bg
  static const Color amber500 = Color(0xFFFFB300); // warning
  static const Color blue400 = Color(0xFF60A5FA); // info / link

  // ── Misc ───────────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}

// ─── Semantic layer ──────────────────────────────────────────────────────────

/// Maps raw tokens to their purpose.  Two static sub-classes: [light] and
/// [dark].  All [MyTheme] / [ColorThemeExtension] constants reference these.
abstract final class RahbarSemanticColors {
  // ── Light mode ──────────────────────────────────────────────────────────────
  static const Color primaryLight = RahbarColors.purple800;
  static const Color primaryVariantLight = RahbarColors.purple700;
  static const Color primaryContainerLight = RahbarColors.purple100;

  static const Color accentLight = RahbarColors.yellow700;
  static const Color accentVariantLight = RahbarColors.yellow500;
  static const Color onAccentLight =
      RahbarColors.neutral900; // text on yellow button

  /// Main window / scaffold — clearly lavender-purple, not near-white.
  static const Color scaffoldBgLight = RahbarColors.purple100; // #EDE9FE
  /// Cards and panels float as white on the purple scaffold.
  static const Color cardBgLight = RahbarColors.white;
  static const Color surfaceLight = RahbarColors.white;
  static const Color dialogBgLight = RahbarColors.white;

  static const Color borderLight = RahbarColors.neutral200;
  static const Color border2Light = RahbarColors.neutral300;
  static const Color border3Light =
      RahbarColors.neutral500; // with opacity in use

  static const Color textPrimaryLight = RahbarColors.neutral900;
  static const Color textSecondaryLight = RahbarColors.neutral700;
  static const Color textHintLight = RahbarColors.neutral500;

  static const Color highlightLight = RahbarColors.purple100;
  static const Color hoverLight = RahbarColors.purple200;
  static const Color dividerLight = RahbarColors.neutral300;

  static const Color successLight = RahbarColors.green500;
  static const Color errorLight = RahbarColors.red500;
  static const Color errorBannerBgLight = Color(0xFFFFF0EF); // soft red tint
  static const Color warningLight = RahbarColors.amber500;
  static const Color infoLight = RahbarColors.purple700;

  static const Color toastBgLight = Color(0xCC160327); // dark purple 80 %
  static const Color toastTextLight = RahbarColors.white;

  static const Color idColorLight = RahbarColors.purple700;
  static const Color dragIndicatorLight = RahbarColors.neutral800;
  static const Color shadowLight = RahbarColors.black;
  static const Color meColorLight = RahbarColors.green500; // "online" dot

  // ── Dark mode ───────────────────────────────────────────────────────────────
  static const Color primaryDark = RahbarColors.purple600; // lighter so it pops
  static const Color primaryVariantDark = RahbarColors.purple700;
  static const Color primaryContainerDark = RahbarColors.purpleDark600;

  static const Color accentDark = RahbarColors.yellow700;
  static const Color accentVariantDark = RahbarColors.yellow600;
  static const Color onAccentDark = RahbarColors.neutral900;

  static const Color scaffoldBgDark = RahbarColors.purpleDark800;
  static const Color cardBgDark = RahbarColors.purpleDark600;
  static const Color surfaceDark = RahbarColors.purpleDark700;
  static const Color dialogBgDark = RahbarColors.purpleDark700;

  static const Color borderDark = RahbarColors.purpleDark500;
  static const Color border2Dark = RahbarColors.neutral300; // light on dark
  static const Color border3Dark = RahbarColors.purpleDark400; // with opacity

  static const Color textPrimaryDark = Color(0xFFEDE9FE); // soft white-purple
  static const Color textSecondaryDark = RahbarColors.neutral300;
  static const Color textHintDark = RahbarColors.neutral500;

  static const Color highlightDark = RahbarColors.purpleDark500;
  static const Color hoverDark = RahbarColors.purpleDark400;
  static const Color dividerDark = RahbarColors.purpleDark500;

  static const Color successDark = RahbarColors.green500;
  static const Color errorDark = RahbarColors.red500;
  static const Color errorBannerBgDark = Color(0xFF380D2A); // dark red-purple
  static const Color warningDark = RahbarColors.amber500;
  static const Color infoDark = RahbarColors.purple400;

  static const Color toastBgDark = Color(0xCCEDE9FE); // light lavender 80 %
  static const Color toastTextDark = RahbarColors.neutral900;

  static const Color idColorDark = RahbarColors.yellow700;
  static const Color dragIndicatorDark = RahbarColors.neutral300;
  static const Color shadowDark = RahbarColors.neutral300;
  static const Color meColorDark = RahbarColors.green500;
}
