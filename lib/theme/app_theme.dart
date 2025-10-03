import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Professional theme configuration for the Ambulance Driver App
class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryBlueDark = Color(0xFF1565C0);
  static const Color primaryBlueLight = Color(0xFF42A5F5);
  
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentGreenDark = Color(0xFF388E3C);
  static const Color accentGreenLight = Color(0xFF81C784);
  static const Color accentGreen50 = Color(0xFFE8F5E8);
  static const Color accentGreen300 = Color(0xFF81C784);
  static const Color accentGreen600 = Color(0xFF388E3C);
  static const Color accentGreen700 = Color(0xFF2E7D32);
  
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentRedDark = Color(0xFFD32F2F);
  static const Color accentRedLight = Color(0xFFEF5350);
  static const Color accentRed50 = Color(0xFFFFEBEE);
  static const Color accentRed300 = Color(0xFFEF5350);
  static const Color accentRed600 = Color(0xFFE53935);
  
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentOrangeDark = Color(0xFFF57C00);
  static const Color accentOrangeLight = Color(0xFFFFB74D);
  static const Color accentOrange50 = Color(0xFFFFF3E0);
  static const Color accentOrange300 = Color(0xFFFFB74D);
  static const Color accentOrange600 = Color(0xFFF57C00);
  static const Color accentOrange700 = Color(0xFFEF6C00);
  
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentPurpleDark = Color(0xFF7B1FA2);
  static const Color accentPurpleLight = Color(0xFFBA68C8);
  
  static const Color neutralGrey = Color(0xFF424242);
  static const Color neutralGreyLight = Color(0xFF757575);
  static const Color neutralGreyDark = Color(0xFF212121);
  
  // Additional grey variants
  static const Color neutralGrey50 = Color(0xFFFAFAFA);
  static const Color neutralGrey100 = Color(0xFFF5F5F5);
  static const Color neutralGrey200 = Color(0xFFEEEEEE);
  static const Color neutralGrey300 = Color(0xFFE0E0E0);
  static const Color neutralGrey400 = Color(0xFFBDBDBD);
  static const Color neutralGrey500 = Color(0xFF9E9E9E);
  static const Color neutralGrey600 = Color(0xFF757575);
  static const Color neutralGrey700 = Color(0xFF616161);
  static const Color neutralGrey800 = Color(0xFF424242);
  static const Color neutralGrey900 = Color(0xFF212121);
  
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color whatsappGreenDark = Color(0xFF128C7E);
  
  // Additional colors
  static const Color textSecondary = Color(0xFF757575);
  static const Color errorRed = Color(0xFFE53935);
  
  // Text colors for notifications and other components
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);

  // Text Styles
  static TextStyle get heading1 => GoogleFonts.roboto(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: neutralGreyDark,
  );

  static TextStyle get heading2 => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: neutralGreyDark,
  );

  static TextStyle get heading3 => GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: neutralGreyDark,
  );

  static TextStyle get bodyLarge => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: neutralGreyDark,
  );

  static TextStyle get bodyMedium => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: neutralGreyDark,
  );

  static TextStyle get bodySmall => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: neutralGreyLight,
  );

  static TextStyle get buttonText => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle get caption => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: neutralGreyLight,
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        primaryContainer: primaryBlueLight,
        secondary: accentGreen,
        secondaryContainer: accentGreenLight,
        surface: surfaceLight,
        background: backgroundLight,
        error: accentRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: neutralGreyDark,
        onBackground: neutralGreyDark,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceLight,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: buttonText,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: GoogleFonts.roboto(
          color: neutralGreyLight,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.roboto(
          color: neutralGreyLight,
          fontSize: 14,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: neutralGrey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Text Theme
      textTheme: GoogleFonts.robotoTextTheme().copyWith(
        headlineLarge: heading1,
        headlineMedium: heading2,
        headlineSmall: heading3,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: buttonText,
        labelMedium: caption,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: neutralGreyDark,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.grey[300],
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Dark Theme (for future use)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: const ColorScheme.dark(
        primary: primaryBlueLight,
        primaryContainer: primaryBlue,
        secondary: accentGreenLight,
        secondaryContainer: accentGreen,
        surface: surfaceDark,
        background: backgroundDark,
        error: accentRedLight,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceDark,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    );
  }
}

/// Custom decoration utilities
class AppDecorations {
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration statusCardDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: color, width: 2),
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration buttonDecoration(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

/// Animation constants
class AppAnimations {
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve slideCurve = Curves.easeOutCubic;
}

/// Centralized Button Styles
class AppButtonStyles {
  // Success Button (Green)
  static ButtonStyle get successButton => ElevatedButton.styleFrom(
    backgroundColor: AppTheme.accentGreen,
    foregroundColor: Colors.white,
    elevation: 2,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  // Danger Button (Red)
  static ButtonStyle get dangerButton => ElevatedButton.styleFrom(
    backgroundColor: AppTheme.accentRed,
    foregroundColor: Colors.white,
    elevation: 2,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  // Warning Button (Orange)
  static ButtonStyle get warningButton => ElevatedButton.styleFrom(
    backgroundColor: AppTheme.accentOrange,
    foregroundColor: Colors.white,
    elevation: 2,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  // Primary Button (Blue)
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryBlue,
    foregroundColor: Colors.white,
    elevation: 2,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  // Secondary Button (Grey)
  static ButtonStyle get secondaryButton => ElevatedButton.styleFrom(
    backgroundColor: AppTheme.neutralGreyLight,
    foregroundColor: Colors.white,
    elevation: 2,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    textStyle: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

/// Centralized Text Styles
class AppTextStyles {
  // Dialog Title
  static TextStyle get dialogTitle => GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppTheme.neutralGreyDark,
  );

  // Dialog Subtitle
  static TextStyle get dialogSubtitle => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppTheme.neutralGreyDark,
  );

  // Dialog Body
  static TextStyle get dialogBody => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppTheme.neutralGreyDark,
  );

  // Dialog Small Text
  static TextStyle get dialogSmall => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTheme.neutralGreyLight,
  );

  // Dialog Caption
  static TextStyle get dialogCaption => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppTheme.neutralGreyLight,
  );

  // Location Text
  static TextStyle get locationText => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.neutralGreyDark,
  );

  // Location Small Text
  static TextStyle get locationSmallText => GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppTheme.neutralGreyLight,
  );

  // Button Text
  static TextStyle get buttonText => GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Error Text
  static TextStyle get errorText => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.accentRed,
  );

  // Success Text
  static TextStyle get successText => GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.accentGreen,
  );
}

/// Centralized Icon Styles
class AppIconStyles {
  // Location Icon
  static const IconData locationIcon = Icons.location_on;
  static const Color locationIconColor = AppTheme.accentRed;
  static const double locationIconSize = 24.0;

  // My Location Icon
  static const IconData myLocationIcon = Icons.my_location;
  static const Color myLocationIconColor = AppTheme.primaryBlue;
  static const double myLocationIconSize = 24.0;

  // Success Icon
  static const IconData successIcon = Icons.check_circle;
  static const Color successIconColor = AppTheme.accentGreen;

  // Error Icon
  static const IconData errorIcon = Icons.error;
  static const Color errorIconColor = AppTheme.accentRed;

  // Warning Icon
  static const IconData warningIcon = Icons.warning;
  static const Color warningIconColor = AppTheme.accentOrange;
}

/// Centralized Container Styles
class AppContainerStyles {
  // Success Container
  static BoxDecoration get successContainer => BoxDecoration(
    color: AppTheme.accentGreen.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppTheme.accentGreen, width: 1),
  );

  // Error Container
  static BoxDecoration get errorContainer => BoxDecoration(
    color: AppTheme.accentRed.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppTheme.accentRed, width: 1),
  );

  // Warning Container
  static BoxDecoration get warningContainer => BoxDecoration(
    color: AppTheme.accentOrange.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppTheme.accentOrange, width: 1),
  );

  // Info Container
  static BoxDecoration get infoContainer => BoxDecoration(
    color: AppTheme.primaryBlue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppTheme.primaryBlue, width: 1),
  );
}

/// Centralized Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Common padding
  static const EdgeInsets paddingSmall = EdgeInsets.all(sm);
  static const EdgeInsets paddingMedium = EdgeInsets.all(md);
  static const EdgeInsets paddingLarge = EdgeInsets.all(lg);

  // Common margins
  static const EdgeInsets marginSmall = EdgeInsets.all(sm);
  static const EdgeInsets marginMedium = EdgeInsets.all(md);
  static const EdgeInsets marginLarge = EdgeInsets.all(lg);

  // Symmetric padding
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingHorizontalLarge = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingVerticalLarge = EdgeInsets.symmetric(vertical: lg);
}

/// Centralized Border Radius
class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 20.0;

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(extraLarge);
}